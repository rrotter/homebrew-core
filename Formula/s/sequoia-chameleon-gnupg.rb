class SequoiaChameleonGnupg < Formula
  desc "Reimplementatilon of gpg and gpgv using Sequoia"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg/-/archive/v0.11.2/sequoia-chameleon-gnupg-v0.11.2.tar.gz"
  sha256 "e254146d42facc704bd68c33fec174f15edf6921dd1bc578b37c93ae61c99781"
  license "GPL-3.0-or-later"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "gmp"
  depends_on "nettle"
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args
    man1.install Dir["man-pages/*.1"]

    zsh_completion.install "shell-completions/_gpg-sq"
    zsh_completion.install "shell-completions/_gpgv-sq"
    bash_completion.install "shell-completions/gpg-sq.bash"
    bash_completion.install "shell-completions/gpgv-sq.bash"
    fish_completion.install "shell-completions/gpg-sq.fish"
    fish_completion.install "shell-completions/gpgv-sq.fish"
  end

  test do
    assert_match "B0976E51E5C047AD0FD051294E402EBF7C3C6A71",
        `#{bin}/gpg-sq --verify #{test_fixtures("cask/container.tar.xz.gpg")} 2>&1`
  end
end
