cask "chill" do
  version "0.1.10"
  sha256 "a1b0a7a3bd06801b51547830b6c0eeebdeecdcf93c547fa25a05ce99d68c6b9f"

  # The garden URL, not GitHub: it counts the download, then 302s to the CDN.
  url "https://chill.untitled.garden/releases/chill-#{version}.dmg"
  name "chill"
  desc "Fan curves that keep your laptop cool to the touch"
  homepage "https://chill.untitled.garden/"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "chill.app"
  binary "#{appdir}/chill.app/Contents/MacOS/chill"

  # No install or uninstall hooks, by design: cask steps run sandboxed, and
  # SMAppService refuses a sandboxed caller, so no step can register or
  # unregister chilld. The app registers it from its popover; when the app is
  # deleted, chilld hands the fans to Apple and removes itself and its files.

  zap trash: [
    "/Library/Application Support/chill",
    "/Library/Logs/chill",
    "~/.local/state/chill",
    "~/Library/Preferences/garden.untitled.chill.plist",
  ]

  caveats <<~EOS
    Open chill from Applications and press "install chilld" in its popover,
    then approve it once under System Settings > General > Login Items &
    Extensions. chilld is the root daemon, the only thing that writes to the
    fans.
  EOS
end
