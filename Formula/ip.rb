class Ip < Formula
  desc "Simplest CLI to get your IP on macOS (local, external, gateway)"
  homepage "https://github.com/adriangalilea/ip"
  url "https://github.com/adriangalilea/ip/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "8012a2b6cd2c756941fecaeca7bf5d4a22e86e16c54bc6cdb6ce7b914654604c"
  license "MIT"

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ip --version")
  end
end
