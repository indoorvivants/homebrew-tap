class SnBindgen < Formula
  desc "Scala 3 Native binding generator for C libraries"
  homepage "https://sn-bindgen.indoorvivants.com"

  # GENERATED: METADATA START
  _version = "0.4.4"
  _repo = "indoorvivants/sn-bindgen"
  _bin_name = "sn-bindgen"
  # GENERATED: METADATA END

  version  "#{_version}"

  url "https://github.com/indoorvivants/sn-bindgen/archive/refs/tags/v#{_version}.tar.gz"

  head do
    depends_on "sbt" => :build
  end

  depends_on "llvm@17"

# GENERATED: DOWNLOAD_URLS START
  _checksums = {
    "aarch64-apple-darwin" => "e4fe43dcf31386fbeb8819e3f8589cbf5795c4d06528b2f43b9a2f3c340eb5f5",
  "aarch64-pc-linux" => "4cb6de273648ed1a9bd4c2d82b481a185a144255398d6d44eea6b4a2bb9307a3",
  "x86_64-apple-darwin" => "05b004a6bd60cf17d3d6f429878da03b9c937f04d7f0919c347c7096d6fdf615",
  "x86_64-pc-linux" => "cf4e66d1cc0cf6e6eb3a230a5d950a42a47d7fd76bb44634a3037ee1d2feb2a3"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.4.4/sn-bindgen-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.4.4/sn-bindgen-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.4.4/sn-bindgen-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.4.4/sn-bindgen-x86_64-apple-darwin"
         sha256 _checksums["x86_64-apple-darwin"]
      end
    end
  end
# GENERATED: DOWNLOAD_URLS END


  def install
    if build.head?
      ENV["SCALANATIVE_MODE"] = "release-fast"
      ENV["LLVM_BIN"] = Formula["llvm@17"].opt_bin

      system "sbt", "buildBinary sn-bindgen"

      cp "bin/sn-bindgen", buildpath / "sn-bindgen"
    else
      cp resource("binary").cached_download, buildpath / "sn-bindgen"
    end

    bin.install "sn-bindgen"

  end

  test do
    (testpath/"test.h").write("void test_my_func(int i);")
    system "#{bin}/sn-bindgen", "--header", (testpath / "test.h"), "--package", "test", "--scala", "--out", "test.scala"
    assert_predicate (testpath / "test.h"), :exist?
  end
end