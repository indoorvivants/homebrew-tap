class Sniper < Formula
  desc "Snippet manager"
  homepage "https://github.com/indoorvivants/sniper"

  # GENERATED: METADATA START
  _version = "0.0.7"
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
    "aarch64-apple-darwin" => "d5b6cfcbcd3817e3f4c1a5fdf32118852eb427661729bd841d9936d40c2eac20",
  "aarch64-pc-linux" => "eebdf843a5b5e7a392fdfa43d2d4ef1a6fbb4073933503c07e9855c14a3b5204",
  "x86_64-apple-darwin" => "825bf033656c6df7243322d4e595e5b97bb45807fc475d376355a7e5989e30b8",
  "x86_64-pc-linux" => "23115852b3c53319196846157807add2121501529af43e5d2339b9536e7f1aa7"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.7/sniper-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.7/sniper-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.7/sniper-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sniper/releases/download/v0.0.7/sniper-x86_64-apple-darwin"
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