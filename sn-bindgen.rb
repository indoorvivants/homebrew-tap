class SnBindgen < Formula
  desc "Scala 3 Native binding generator for C libraries"
  homepage "https://sn-bindgen.indoorvivants.com"

  _version = "0.2.0"

  version  "#{_version}"

  url "https://github.com/indoorvivants/sn-bindgen/archive/refs/tags/v#{_version}.tar.gz"

  head do
    depends_on "sbt" => :build
  end

  depends_on "llvm@17"

  resource "binary" do
    on_arm do
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v#{_version}/sn-bindgen-aarch64-apple-darwin"
        # sha256 checksums["darwin-arm64"]
      end
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v#{_version}/sn-bindgen-aarch64-pc-linux"
        # sha256 checksums["linux-arm64"]
      end
    end
    on_intel do
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v#{_version}/sn-bindgen-x86_64-apple-darwin"
        # sha256 checksums["darwin-amd64"]
      end
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v#{_version}/sn-bindgen-x86_64-pc-linux"
        # sha256 checksums["linux-amd64"]
      end
    end
  end

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
