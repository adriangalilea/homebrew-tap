class Trash < Formula
  desc "macOS Trash CLI with real Put Back (list/restore/empty, origin xattr)"
  homepage "https://github.com/adriangalilea/trash"
  url "https://github.com/adriangalilea/trash/archive/refs/tags/1.2.0.tar.gz"
  sha256 "365af7ada823e66152142978062010963c88b295380e93317c1f8fe218658ec8"
  license "MIT"

  # The bottle is the point: pouring needs NO toolchain. Source build (and
  # its Xcode requirement) is the fallback for platforms without one.
  bottle do
    root_url "https://github.com/adriangalilea/trash/releases/download/1.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "35646a7e00a409277637be1925440534d43f28a527cda72180bbec4ba785bce8"
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
