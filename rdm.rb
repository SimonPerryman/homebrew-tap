# typed: strict
# frozen_string_literal: true

class Rdm < Formula
  desc "A download manager in Rust"
  homepage "https://github.com/SimonPerryman/rust-download-manager"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.1.0/rdm-aarch64-apple-darwin.tar.xz"
      sha256 "b336b2f41c2d407cbedd32784e734ae977a2174b598804c29bbd7ac97c6affc3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.1.0/rdm-x86_64-apple-darwin.tar.xz"
      sha256 "66edde635d9911b80abb37e82efaf2e53fb57fd6701d32e508f77ab5d863e648"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.1.0/rdm-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8b850ba88a7bb9699082312403e668fb93e1a0a7c235e2cf039b76b2121f819c"
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
