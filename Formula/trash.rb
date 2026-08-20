class Trash < Formula
  desc "macOS Trash CLI with real Put Back (list/restore/empty, origin xattr)"
  homepage "https://github.com/adriangalilea/trash"
  url "https://github.com/adriangalilea/trash/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b6f20319616eb6036b46b847a2b6eee5bf012493be631d7ab482275fd6871812"
  license "MIT"

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
