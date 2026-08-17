cask "awake" do
  version "0.4.0"
  sha256 "abb56e31c76925efd40c9aa534998fc6ebbb833cb510ddf6ac98bfaa5bbf935c"

  # The garden URL, not GitHub: it counts the download, then 302s to the CDN.
  url "https://awake.untitled.garden/releases/awake-#{version}.dmg"
  name "awake"
  desc "Prevents sleeping, including with the lid closed"
  homepage "https://awake.untitled.garden"

  depends_on macos: :tahoe

  app "awake.app"
  binary "#{appdir}/awake.app/Contents/MacOS/awake"
  binary "#{appdir}/awake.app/Contents/MacOS/awake", target: "asleep"

  # Dropping the app in /Applications leaves the state machine unbootstrapped,
  # and the daemon IS the product: safety nets need a resident process. The
  # binary owns this step so every install path lands the same agent.
  postflight do
    system_command "#{appdir}/awake.app/Contents/MacOS/awake", args: ["agent", "install"]
  end

  # Teardown is the binary's job too, symmetric with the postflight above. NOT
  # `uninstall launchctl:`: that stanza also attempts a root `rm` for
  # /Library/LaunchAgents, so it prompts for a password and fails outright in any
  # non-interactive upgrade. The agent is a user agent; removing it needs no root.
  uninstall_preflight do
    system_command "#{appdir}/awake.app/Contents/MacOS/awake", args: ["agent", "uninstall"]
  end

  zap trash: [
    "~/.local/state/awake",
    "~/Library/LaunchAgents/garden.untitled.awake.plist",
    "~/Library/Logs/awake",
    "~/Library/Preferences/garden.untitled.awake.plist",
  ]

  caveats <<~EOS
    Keeping the Mac awake with the lid CLOSED needs one privileged flag, so run
    this once and authenticate when macOS asks:

      awake grant

    It installs a sudoers rule scoped to exactly two commands. Remove it with
    `awake grant --remove`; uninstalling the cask does not (that would need a
    second authentication prompt).
  EOS
end
