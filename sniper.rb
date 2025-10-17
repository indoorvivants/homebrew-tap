class Sniper < Formula
  desc "Snippet manager"
  homepage "https://github.com/indoorvivants/sniper"

  _version = "0.0.5"

  version  "#{_version}"

  url "https://github.com/indoorvivants/sniper/archive/refs/tags/v#{_version}.tar.gz"

  head do
    depends_on "Virtuslab/scala-cli/scala-cli"
    depends_on "llvm@17"
  end

  checksums = {
    "darwin-amd64" => "13c71f480e68454ecbe1fb461efc1599caa00ef59311293d543b783f7b988dc2",
    "darwin-arm64" => "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
    "linux-amd64" => "97085c830992fde6ad9140e7e1c4cda3e6aa46a9456ee4a5886934e819afb55d",
    "linux-arm64" => "61d0850aeade8ccc858cdd2c871f9e76025ae51f569fe5363d3d2e7674b1ba2a"
  }

  resource "binary" do
    on_arm do
      on_macos do
        url "https://github.com/indoorvivants/sniper/releases/download/v#{_version}/sniper-aarch64-apple-darwin"
        sha256 checksums["darwin-arm64"]
      end
      on_linux do
        url "https://github.com/indoorvivants/sniper/releases/download/v#{_version}/sniper-aarch64-pc-linux"
        # sha256 checksums["linux-arm64"]
      end
    end
    on_intel do
      on_macos do
        url "https://github.com/indoorvivants/sniper/releases/download/v#{_version}/sniper-x86_64-apple-darwin"
        # sha256 checksums["darwin-amd64"]
      end
      on_linux do
        url "https://github.com/indoorvivants/sniper/releases/download/v#{_version}/sniper-x86_64-pc-linux"
        # sha256 checksums["linux-amd64"]
      end
    end
  end

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
