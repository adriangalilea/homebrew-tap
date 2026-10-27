cask "trash" do
  version "1.3.0"
  sha256 "4fc7e66611164cf560db4ae4388998c3fd38d5c0e6be7ab8068619867fe5d36d"

  # The garden URL, not GitHub: it counts the download, then 302s to the CDN.
  url "https://trash.untitled.garden/releases/trash-#{version}.dmg"
  name "trash"
  desc "macOS Trash CLI with real Put Back (list/restore/empty, origin xattr)"
  homepage "https://trash.untitled.garden/"

  depends_on macos: ">= :ventura"

  app "trash.app"
  binary "#{appdir}/trash.app/Contents/MacOS/trash"

  caveats <<~EOS
    Moving things to the Trash works from anywhere. Reading it (list, restore,
    empty) needs Full Disk Access, which macOS never asks for: open trash.app
    once and it shows you where to give it. A terminal that already has Full
    Disk Access never needs it.

    Coming from the trash formula? `brew uninstall trash` first.
  EOS
end
