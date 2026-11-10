# typed: strict
# frozen_string_literal: true

class Rdm < Formula
  desc "A download manager in Rust"
  homepage "https://github.com/SimonPerryman/rust-download-manager"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.2.0/rdm-aarch64-apple-darwin.tar.xz"
      sha256 "0956a06b34688203c70961104f196857b85fde6747b24d776c0c4f26621be1d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.2.0/rdm-x86_64-apple-darwin.tar.xz"
      sha256 "f3c30272471359e547ccb4d33e29af3e9ce59583726a8d0960739bf3f0e6bcfa"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/SimonPerryman/rust-download-manager/releases/download/v0.2.0/rdm-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5747de1cb070552eab06d7cb571cae1754248a91e18f927033e555e6944e0a22"
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
