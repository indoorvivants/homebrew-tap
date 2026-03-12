class SnBindgen < Formula
  desc "Scala 3 Native binding generator for C libraries"
  homepage "https://sn-bindgen.indoorvivants.com"

  # GENERATED: METADATA START
  _version = "0.4.1"
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
    "aarch64-apple-darwin" => "5f4bad4a20f4145ffe5a38840b2b543395ec59be374d62d35466c0549b34872c",
  "aarch64-pc-linux" => "b9c6f4e78ca086562068483185d0996e602aa883b19bec2caca56908d1a7685e",
  "x86_64-apple-darwin" => "45fa15109b857d16a4a1991abce6251486a11fcc44170253aa83a6dbea17e162",
  "x86_64-pc-linux" => "98382a8a165932f90803446ee68cc9539202357c804e3b33e715a41a5e64bcd5"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.4.1/sn-bindgen-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.4.1/sn-bindgen-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.4.1/sn-bindgen-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/sn-bindgen/releases/download/v0.4.1/sn-bindgen-x86_64-apple-darwin"
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