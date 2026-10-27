cask "trash" do
  version "1.3.3"
  sha256 "d574a952b7b8ca1bcd8c67f950d5b0ad717391fb8deb6bb097d0104b1d8d0bbb"

  # The garden URL, not GitHub: it counts the download, then 302s to the CDN.
  url "https://trash.untitled.garden/releases/trash-#{version}.dmg"
  name "trash"
  desc "macOS Trash CLI with real Put Back (list/restore/empty, origin xattr)"
  homepage "https://trash.untitled.garden/"

  depends_on macos: ">= :tahoe"

  app "trash.app"
  binary "#{appdir}/trash.app/Contents/MacOS/trash"

  caveats <<~EOS
    Moving things to the Trash works from anywhere. Reading it (list, restore,
    empty) needs Full Disk Access: the first time, trash.app asks for it in a
    window of its own, then the command finishes. A terminal that already has
    Full Disk Access never needs it.

    Coming from the trash formula? `brew uninstall trash` first.
  EOS
end
