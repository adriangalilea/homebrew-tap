class Trash < Formula
  desc "macOS Trash CLI with real Put Back (list/restore/empty, origin xattr)"
  homepage "https://github.com/adriangalilea/trash"
  url "https://github.com/adriangalilea/trash/archive/refs/tags/1.1.1.tar.gz"
  sha256 "64be75bd78c269dcb8670ef5a03d23cf0c93a2bb819127f3750b3eb299b26e62"
  license "MIT"

  # The bottle is the point: pouring needs NO toolchain. Source build (and
  # its Xcode requirement) is the fallback for platforms without one.
  bottle do
    root_url "https://github.com/adriangalilea/trash/releases/download/1.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "afcce0c97673702413d00b36385b2a9b458ada18247db365d650a8968a557412"
  end

  depends_on :macos
  depends_on xcode: ["16.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/trash"
  end

  test do
    assert_match "Trash CLI", shell_output("#{bin}/trash help")
  end
end
