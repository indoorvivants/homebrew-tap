
class SnSizemap < Formula
  desc "Scala Boot - start your projects from templates"
  homepage "https://github.com/indoorvivants/sn-sizemap"

  # GENERATED: METADATA START
  _version = "0.0.2"
  _repo = "indoorvivants/sn-sizemap"
  _bin_name = "sn-sizemap"
  # GENERATED: METADATA END

  version  "#{_version}"

  url "https://github.com/indoorvivants/sn-sizemap/archive/refs/tags/v#{_version}.tar.gz"

  head do
    depends_on "Virtuslab/scala-cli/scala-cli"
    depends_on "llvm@17"
  end

# GENERATED: DOWNLOAD_URLS START
  _checksums = {
    "aarch64-apple-darwin" => "438db856793903bf83a91180edd9d4f02bab9bb2048d97014ff4019565364a74",
  "aarch64-pc-linux" => "3c600623d475f00c66159c31f875f8f07fc527fc4e9559ca32b6dbacb2184815",
  "x86_64-apple-darwin" => "280fc009d636446547124d3978e61e2fcdc47eb1a0340f096f4b4a3e65636831",
  "x86_64-pc-linux" => "3989029ff0f18a2aac43f3aed6772319eeb1a02f3617bb2771b9707c1fe87214"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/sn-sizemap/releases/download/v0.0.2/sn-sizemap-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-sizemap/releases/download/v0.0.2/sn-sizemap-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/sn-sizemap/releases/download/v0.0.2/sn-sizemap-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-sizemap/releases/download/v0.0.2/sn-sizemap-x86_64-apple-darwin"
         sha256 _checksums["x86_64-apple-darwin"]
      end
    end
  end
# GENERATED: DOWNLOAD_URLS END


  def install
    if build.head?
      ENV["SCALANATIVE_MODE"] = "release-fast"
      ENV["LLVM_BIN"] = Formula["llvm@17"].opt_bin

      system "sbt", "cli/buildBinaryRelease"

      cp "out/release/sn-sizemap", buildpath / "sn-bindgen"
    else
      cp resource("binary").cached_download, buildpath / "sn-sizemap"
    end


    bin.install "sn-sizemap"
  end

  test do
    system "#{bin}/sn-sizemap", "--help"
  end
end
