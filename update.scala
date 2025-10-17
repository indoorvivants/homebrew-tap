//> using dep com.indoorvivants::decline-derive::0.3.2
//> using dep com.indoorvivants::rendition::0.0.4
//> using toolkit default

import sttp.client4.quick.*, upickle.default.*
import decline_derive.*
import java.nio.file.Path
import sttp.model.Uri
import rendition.*

case class CLI(file: Path) derives CommandApplication

case class Asset(name: String, digest: Option[String]) derives ReadWriter
case class ReleaseData(tag_name: String, assets: List[Asset]) derives ReadWriter

case class Metadata(binary: String, repo: String, version: String)

def getSection(lines: IndexedSeq[String], section: String) =
  val start = lines.takeWhile(_.trim != s"# GENERATED: $section START")
  val metadata =
    lines.drop(start.size + 1).takeWhile(_.trim != s"# GENERATED: $section END")
  val rest = lines.drop(start.size + metadata.length + 2)

  (before = start, section = metadata, rest = rest)

def replaceSection(
    lines: IndexedSeq[String],
    section: String,
    replacement: Seq[String]
) =
  val start = lines.takeWhile(_.trim != s"# GENERATED: $section START")
  val metadata =
    lines.drop(start.size + 1).takeWhile(_.trim != s"# GENERATED: $section END")
  val rest = lines.drop(start.size + metadata.length + 2)

  if metadata.length == 0 then sys.error(s"Section $section not found")

  start ++ (s"# GENERATED: $section START" +: replacement :+ s"# GENERATED: $section END") ++ rest

def readMetadata(lines: IndexedSeq[String]) =

  val meta = getSection(lines, "METADATA")

  val rgx = """\s*(\w+)\s*=\s*"(.*?)"\s*""".trim.r

  val attrs = meta.section.foldLeft(Map.empty[String, String]):
    case (agg, rgx(name, value)) => agg.updated(name, value)

  Metadata(
    binary = attrs("_bin_name"),
    repo = attrs("_repo"),
    version = attrs("_version")
  )

@main def hello(args: String*) =
  val cmd = CommandApplication.parseOrExit[CLI](args)
  val path = os.Path(cmd.file, os.pwd)
  val meta = readMetadata(os.read.lines(path))

  val releases =
    read[List[ReleaseData]](
      quickRequest
        .header("Accept", "application/vnd.github+json")
        .header("X-GitHub-Api-Version", "2022-11-28")
        .get(
          Uri.unsafeParse(s"https://api.github.com/repos/${meta.repo}/releases")
        )
        .response(asStringOrFail)
        .send()
        .body
    )

  println(releases)

  val release = releases.find(_.tag_name == "v" + meta.version).get

  val assetsMap = release.assets.map(ass => ass.name -> ass.digest).toMap

  val binaries =
    for
      arch <- List("aarch64", "x86_64")
      os <- List("apple-darwin", "pc-linux")
      binary = s"${meta.binary}-$arch-$os"
      asset <- assetsMap.get(binary)
    yield Binary(binary = binary, token = s"$arch-$os", digest = asset)

  os.write.over(
    path,
    replaceSection(
      os.read.lines(path),
      "DOWNLOAD_URLS",
      generateDownloadUrls(meta, binaries)
    ).mkString("\n")
  )

case class Binary(binary: String, token: String, digest: Option[String])

def generateDownloadUrls(
    metadata: Metadata,
    d: List[Binary]
) =
  val checksums =
    List(
      "_checksums = {",
      d
        .flatMap(d =>
          d.digest
            .map(_.stripPrefix("sha256:"))
            .map(hash => s"""  "${d.token}" => "$hash"""")
        )
        .mkString(",\n"),
      "}"
    )

  def renderUrl(b: Binary) =
    s"""
    | url "https://github.com/${metadata.repo}/releases/download/v${metadata.version}/${metadata.binary}-${b.token}"
    | ${b.digest.map(_ => s"sha256 _checksums[\"${b.token}\"]").getOrElse("")}
    """.stripMargin.trim()
  end renderUrl

  val grouped = d
    .groupBy(b => b.token.split("-", 2).head)
    .view
    .mapValues(_.groupBy(b => b.token.split("-", 2).tail.head))
    .toMap

  def indent(l: String | Seq[String]) =
    l match
      case s: String      => s.split("\n").map("  " + _).toSeq
      case s: Seq[String] => s.map("  " + _)

  def renderByOS(m: Map[String, List[Binary]]) =
    m.flatMap: (moniker, binaries) =>
      val m = if moniker == "apple-darwin" then "on_macos" else "on_linux"
      List(s"$m do") ++ binaries.map(renderUrl).flatMap(indent) :+ "end"
    .mkString("\n")

  val lines =
    List("resource \"binary\" do") ++
      indent(
        grouped.toList.flatMap: (moniker, byOS) =>
          val m = if moniker == "aarch64" then "on_arm" else "on_intel"
          List(m + " do") ++ indent(renderByOS(byOS)) :+ "end"
      ) ++
      List("end")

  indent(checksums ++ lines)
