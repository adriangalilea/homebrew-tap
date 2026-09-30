cask "chill" do
  version "0.1.2"
  sha256 "b4f8c63b1522679ed2546843e1c2c9485be2af9ccd2a3423ffd315f5d3feddc2"

  # The garden URL, not GitHub: it counts the download, then 302s to the CDN.
  url "https://chill.untitled.garden/releases/chill-#{version}.dmg"
  name "chill"
  desc "Fan control with Apple in charge by default"
  homepage "https://chill.untitled.garden/"

  depends_on macos: :tahoe
  depends_on arch: :arm64

  app "chill.app"
  binary "#{appdir}/chill.app/Contents/MacOS/chill"

  # No install or uninstall hooks, by design: cask steps run sandboxed, and
  # SMAppService refuses a sandboxed caller, so no step can register or
  # unregister chilld. The app registers it from its popover; `chill daemon
  # uninstall` hands the fans to Apple and unregisters it.

  zap trash: [
    "~/.local/state/chill",
    "~/Library/Preferences/garden.untitled.chill.plist",
    "/Library/Application Support/chill",
    "/Library/Logs/chill",
  ]

  caveats <<~EOS
    Open chill from Applications and press "install chilld" in its popover,
    then approve it once under System Settings > General > Login Items &
    Extensions. chilld is the root daemon, the only thing that writes to the
    fans.

    Before uninstalling, run:

      chill daemon uninstall

    It hands the fans back to Apple and removes the daemon's registration.
  EOS
end
