class SnBindgen < Formula
  desc "Scala 3 Native binding generator for C libraries"
  homepage "https://sn-bindgen.indoorvivants.com"

  # GENERATED: METADATA START
  _version = "0.3.1"
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
    "aarch64-apple-darwin" => "f6ab16ec4109235f7cf12a69352312e2ab98d1fab303b3c57fef8b6e28cbcd35",
  "aarch64-pc-linux" => "7bedb79e4d600d1e106b0ed7011a851dc6a154a7f95563bd2c9a6d06d8c6aef1",
  "x86_64-apple-darwin" => "4615f23c82e8d4090f0974e65479b9043a8d85fea03293aa36d332928d945595",
  "x86_64-pc-linux" => "c7f5fc75015a3873edc2b859d78b50221abfb39f151d1782d22aae71d6e7b863"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.3.1/sn-bindgen-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.3.1/sn-bindgen-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.3.1/sn-bindgen-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.3.1/sn-bindgen-x86_64-apple-darwin"
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