class SnBindgen < Formula
  desc "Scala 3 Native binding generator for C libraries"
  homepage "https://sn-bindgen.indoorvivants.com"

  # GENERATED: METADATA START
  _version = "0.2.4"
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
    "aarch64-apple-darwin" => "e22103a42d73271c68679996057c90ef44035990b23ec9ef7cb27a1f986b04b0",
  "aarch64-pc-linux" => "e5d576891a8dff50c8f63d73f87f2eb64d7563276cc4064e9eedbf4290cfeac6",
  "x86_64-apple-darwin" => "d741cd7fde66424d1b18730db88b75fb54402cb9057048e6e3262e5cff8cfec4",
  "x86_64-pc-linux" => "72992e541fb2b2c38ec098a719c93b75759ff2c671f64118d972dbb3d0a050f2"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.2.4/sn-bindgen-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.2.4/sn-bindgen-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.2.4/sn-bindgen-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.2.4/sn-bindgen-x86_64-apple-darwin"
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