# typed: strict
# frozen_string_literal: true

class Rdm < Formula
  desc "A download manager in Rust"
  homepage "https://github.com/SimonPerryman/rust-download-manager"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.4.0/rdm-aarch64-apple-darwin.tar.xz"
      sha256 "cfe11a9841ed8d639acb42b4d1540b5d24d6449a394110742550700cc71fa1b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.4.0/rdm-x86_64-apple-darwin.tar.xz"
      sha256 "b931f60cba73c12db42f47e08f9d7145fd61dbe1a0526f4a28e26d034b0f8b9d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.4.0/rdm-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f3401c2c4bac5d7beb8369efc549c84a4f80fdd8061edb55c8e954fe72e74713"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rdm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rdm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rdm"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
