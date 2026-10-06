cask "chill" do
  version "0.1.6"
  sha256 "b766dc1d74e5f78d8c1b664189e64bda7353978ce349e9924cd819b36aeab181"

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
