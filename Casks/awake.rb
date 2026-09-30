cask "awake" do
  version "0.8.2"
  sha256 "80bb533f53d90905dab1d41c0567e626431e68ac083bf71b1c480cfb229b73d9"

  # The garden URL, not GitHub: it counts the download, then 302s to the CDN.
  url "https://awake.untitled.garden/releases/awake-#{version}.dmg"
  name "awake"
  desc "Prevents sleeping, including with the lid closed"
  homepage "https://awake.untitled.garden/"

  depends_on macos: :tahoe

  app "awake.app"
  binary "#{appdir}/awake.app/Contents/MacOS/awake"
  binary "#{appdir}/awake.app/Contents/MacOS/awake", target: "asleep"

  # No install or uninstall hooks, by design: the app owns its agent. Cask steps
  # run sandboxed, and launchd, LaunchServices and SMAppService all refuse a
  # sandboxed caller, so no step can start anything; uninstall steps also run on
  # every upgrade, where removing the agent is wrong. awake registers its agent
  # (SMAppService, plist inside the bundle) on first use, restarts itself into a
  # replaced bundle, and unregisters itself when the bundle is gone.

  zap trash: [
    "~/.local/state/awake",
    "~/Library/Logs/awake",
    "~/Library/Preferences/garden.untitled.awake.plist",
  ]

  caveats <<~EOS
    awake starts on first use: open it from Applications, or run any command
    (`awake status`). It stays running from then on, across logins, and macOS
    lists it under Login Items.

    Keeping the Mac awake with the lid CLOSED needs one privileged flag, so run
    this once and authenticate when macOS asks:

      awake grant

    It installs a sudoers rule scoped to exactly two commands. Remove it with
    `awake grant --remove`; uninstalling the cask does not (that would need a
    second authentication prompt).
  EOS
end
