class Sniper < Formula
  desc "Snippet manager"
  homepage "https://github.com/indoorvivants/sniper"

  # GENERATED: METADATA START
  _version = "0.0.6"
  _repo = "indoorvivants/sniper"
  _bin_name = "sniper"
  # GENERATED: METADATA END

  version  "#{_version}"

  url "https://github.com/indoorvivants/sniper/archive/refs/tags/v#{_version}.tar.gz"

  head do
    depends_on "Virtuslab/scala-cli/scala-cli"
    depends_on "llvm@17"
  end

# GENERATED: DOWNLOAD_URLS START
  _checksums = {
    "aarch64-apple-darwin" => "611e63c082bb46a9217c2bca5148958fc26df88fcb2949002b4bf6aead7d2888",
  "aarch64-pc-linux" => "791c999da8591e1ffb67c2bb815878ec634c480b4313fcf05a4fc6f20f1a476d",
  "x86_64-apple-darwin" => "0774c04670a5d89798f41da8e8403ae52fce2fb64e9d409eaa9cda9decbfdc46",
  "x86_64-pc-linux" => "684c5fe777a4bc6973aef10bd02d956a526a7aee42a9eea0d7edb7ae4795a1e0"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.6/sniper-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.6/sniper-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.6/sniper-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.6/sniper-x86_64-apple-darwin"
         sha256 _checksums["x86_64-apple-darwin"]
      end
    end
  end
# GENERATED: DOWNLOAD_URLS END


  def install
    if build.head?
      system "make", "bin"

      cp "out/release/sniper", buildpath / "sniper"
    else
      cp resource("binary").cached_download, buildpath / "sniper"
    end

    bin.install "sniper"
  end

  test do
    system "#{bin}/sniper", "print-config"
  end
end