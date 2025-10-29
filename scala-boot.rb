class ScalaBoot < Formula
  desc "Scala Boot - start your projects from templates"
  homepage "https://github.com/indoorvivants/scala-boot"

  # GENERATED: METADATA START
  _version = "0.0.4"
  _repo = "indoorvivants/scala-boot"
  _bin_name = "scala-boot"
  # GENERATED: METADATA END

  version  "#{_version}"

  url "https://github.com/indoorvivants/sniper/archive/refs/tags/v#{_version}.tar.gz"

  head do
    depends_on "sbt" => :build
  end

# GENERATED: DOWNLOAD_URLS START
  _checksums = {
    "aarch64-apple-darwin" => "16e33d96d8fe92886cd3ca6c290de21b0237699ebf50675b9cfa79dd0c7ad7ad",
  "aarch64-pc-linux" => "871394ebd64b3b5660858a602c7f8f6e78cdea8fd875ab5d0fc23e2af1b5399d",
  "x86_64-apple-darwin" => "7fb71f9e3574482d773f310bc9ada7c2a86c1b7d8d56e24255367fdc2f7d258d",
  "x86_64-pc-linux" => "32e0ccfc09a2edf25c33dbd55b215aa29e409f07d2d04c8a6507a86b773a0cc5"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/scala-boot/releases/download/v0.0.4/scala-boot-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/scala-boot/releases/download/v0.0.4/scala-boot-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/scala-boot/releases/download/v0.0.4/scala-boot-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/scala-boot/releases/download/v0.0.4/scala-boot-x86_64-apple-darwin"
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

      cp "out/release/scala-boot", buildpath / "sn-bindgen"
    else
      cp resource("binary").cached_download, buildpath / "scala-boot"
    end


    bin.install "scala-boot"
  end

  test do
    system "#{bin}/scala-boot", "go", "indoorvivants/smithy4s-fullstack.g8", "-y"
  end
end
