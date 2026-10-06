cask "chill" do
  version "0.1.3"
  sha256 "7f1eac5088e41e5bb678d391f180b1bd75cf6f9f3aa0ac9d0f0d86af5ec7b84a"

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
