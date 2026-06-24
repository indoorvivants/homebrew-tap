
class SnSizemap < Formula
  desc "Scala Boot - start your projects from templates"
  homepage "https://github.com/indoorvivants/sn-sizemap"

  # GENERATED: METADATA START
  _version = "0.1.1"
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
    "aarch64-apple-darwin" => "a540182faa3a977a4e863ad624b580bd4c586f2f7e94eb5c217968d63a5e6b03",
  "aarch64-pc-linux" => "e9c8f522f218a1dfe3db9f74e70624aaf1288f6764c214c0c923a25cdca0d133",
  "x86_64-apple-darwin" => "11266fe4a792d962362c4f976c4316bfa26a0b5e5855cc113323e427aa9bc8bc",
  "x86_64-pc-linux" => "d28551bae827eef1b65b334b72f3141960b9a1b60d4ceb39a7a44c43fe3ce3d6"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/sn-sizemap/releases/download/v0.1.1/sn-sizemap-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-sizemap/releases/download/v0.1.1/sn-sizemap-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/sn-sizemap/releases/download/v0.1.1/sn-sizemap-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-sizemap/releases/download/v0.1.1/sn-sizemap-x86_64-apple-darwin"
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