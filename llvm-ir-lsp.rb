
class LlvmIrLsp < Formula
  desc "LLVM IR LSP – navigate .ll files in your editor of choice"
  homepage "https://github.com/indoorvivants/llvm-ir-lsp"

  # GENERATED: METADATA START
  _version = "0.1.0"
  _repo = "indoorvivants/llvm-ir-lsp"
  _bin_name = "llvm-ir-lsp"
  # GENERATED: METADATA END

  version  "#{_version}"

  url "https://github.com/indoorvivants/llvm-ir-lsp/archive/refs/tags/v#{_version}.tar.gz"

  head do
    depends_on "sbt"
    depends_on "llvm@17"
  end

# GENERATED: DOWNLOAD_URLS START
  _checksums = {
    "aarch64-apple-darwin" => "46770a533bbce51491bbb8659d7805c4086bc63e52dc1b58006bf53f2f3b5e79",
  "aarch64-pc-linux" => "0d01d351bd8ef961a6faab05c5c52380fe8c418b7d0ad4cf3aed2a36bfb9b5b5",
  "x86_64-apple-darwin" => "e45cfdcbb9f1335d7ee63d21139064828ca3468657f973e3a234431a783c65d6",
  "x86_64-pc-linux" => "573693f6ca9a4bf9729e143341f6d1991cc130d44ffb4de50ab5f4c14e024660"
  }
  resource "binary" do
    on_arm do
      on_linux do
        url "https://github.com/indoorvivants/llvm-ir-lsp/releases/download/v0.1.0/llvm-ir-lsp-aarch64-pc-linux"
         sha256 _checksums["aarch64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/llvm-ir-lsp/releases/download/v0.1.0/llvm-ir-lsp-aarch64-apple-darwin"
         sha256 _checksums["aarch64-apple-darwin"]
      end
    end
    on_intel do
      on_linux do
        url "https://github.com/indoorvivants/llvm-ir-lsp/releases/download/v0.1.0/llvm-ir-lsp-x86_64-pc-linux"
         sha256 _checksums["x86_64-pc-linux"]
      end
      on_macos do
        url "https://github.com/indoorvivants/llvm-ir-lsp/releases/download/v0.1.0/llvm-ir-lsp-x86_64-apple-darwin"
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

      cp "out/release/llvm-ir-lsp", buildpath / "llvm-ir-lsp"
    else
      cp resource("binary").cached_download, buildpath / "llvm-ir-lsp"
    end


    bin.install "llvm-ir-lsp"
  end

  # test do
  #   system "#{bin}/llvm-ir-lsp", "--help"
  # end
end
