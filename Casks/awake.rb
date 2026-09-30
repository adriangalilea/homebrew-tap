cask "awake" do
  version "0.7.1"
  sha256 "3dc6ddcd7faa6b7a135129ea5350c1eba9e4e9a83918a8fcb11b00a634c6e6d0"

  # The garden URL, not GitHub: it counts the download, then 302s to the CDN.
  url "https://awake.untitled.garden/releases/awake-#{version}.dmg"
  name "awake"
  desc "Prevents sleeping, including with the lid closed"
  homepage "https://awake.untitled.garden/"

  depends_on macos: :tahoe

  app "awake.app"
  binary "#{appdir}/awake.app/Contents/MacOS/awake"
  binary "#{appdir}/awake.app/Contents/MacOS/awake", target: "asleep"

  # Dropping the app in /Applications leaves the state machine unbootstrapped,
  # and the daemon IS the product: safety nets need a resident process. The
  # binary owns this step so every install path lands the same agent. Deliberately
  # the legacy block, deprecation warning and all: `postflight_steps` run sandboxed,
  # launchd refuses `bootstrap` to any sandboxed caller (EIO), and the sandbox also
  # denies LaunchServices, so no step form can start the agent.
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
