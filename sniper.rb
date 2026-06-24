class Sniper < Formula
  desc "Snippet manager"
  homepage "https://github.com/indoorvivants/sniper"

  # GENERATED: METADATA START
  _version = "0.0.9"
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
    "aarch64-apple-darwin" => "111c49e47095e8cfba401311d86624cbec075869c7b9701dc58dbede8837a1a0",
  "aarch64-pc-linux" => "4c5881177d8fd4b1a96cdfe022bdefd0bcf1bc0e6193e0f3bef99075c8e0bffe",
  "x86_64-apple-darwin" => "4a688f5c7bec2bec9e84141a52274d8593525c7e57599ad33f455ce9ec7aa322",
  "x86_64-pc-linux" => "5bd1fa3c6dbce0eda2111266124c43501a9dfb240e24370a324db091027a0db9"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.9/sniper-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.9/sniper-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.9/sniper-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.9/sniper-x86_64-apple-darwin"
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