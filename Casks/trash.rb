cask "trash" do
  version "1.3.1"
  sha256 "0bc366d4e793521e059064c03d3d31ce0329144eccbe3f0fb121d8b3fd99b370"

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
