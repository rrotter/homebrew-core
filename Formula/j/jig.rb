class Jig < Formula
  desc "Dev kit for building and publishing Puppet modules"
  homepage "https://github.com/avitacco/jig"
  url "https://github.com/avitacco/jig/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "058510574cd3308b5cd9e4a76eb19153317a7fd158c6413996c6f687b3812bbb"
  license "GPL-3.0-or-later"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"jig", shell_parameter_format: :cobra)
  end

  test do
    system bin/"jig", "new", "module", "mock-module", "-u", "testbot", "-a", "Test Bot", "-i"
    assert_match '"name": "testbot-mock-module"', File.read("mock-module/metadata.json")
  end
end
