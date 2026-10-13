class Ip < Formula
  desc "Simplest CLI to get your IP on macOS (local, external, gateway)"
  homepage "https://github.com/adriangalilea/ip"
  url "https://github.com/adriangalilea/ip/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "f198ffafb40996655e0c396525fb1f30df3ae76f360d2944182f7ab528722885"
  license "MIT"

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ip --version")
  end
end
