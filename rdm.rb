# typed: strict
# frozen_string_literal: true

class Rdm < Formula
  desc "A download manager in Rust"
  homepage "https://github.com/SimonPerryman/rust-download-manager"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.5.0/rdm-aarch64-apple-darwin.tar.xz"
      sha256 "c8fecf80a81ac23f0ff88b6e73c100210de97aed7e6862d9fb690d246c119bb0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.5.0/rdm-x86_64-apple-darwin.tar.xz"
      sha256 "f579701c2ad5a2252cdfbb1856ff0085db49408c73ef6e3c695994e7624bb9b3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.5.0/rdm-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "df3a106b28b1ba5da84a5bf3193e78587e34ade51dcfd142691fb73e7359aca9"
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
