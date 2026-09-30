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
  # binary owns this step so every install path lands the same agent. Cask steps
  # run sandboxed and launchd refuses `bootstrap` to ANY sandboxed caller (EIO), so
  # the step cannot install the agent itself: it opens the app through
  # LaunchServices, which runs it outside this sandbox, and an argument-less LS
  # launch is awake's "install my agent" (`-n`: the daemon is the same bundle, and
  # without it LaunchServices would just reactivate a running one).
  postflight_steps do
    run "/usr/bin/open", args: ["-g", "-n", "{{appdir}}/awake.app"]
  end

  # Teardown is the binary's job too, symmetric with the step above. NOT
  # `uninstall launchctl:`: that stanza also attempts a root `rm` for
  # /Library/LaunchAgents, so it prompts for a password and fails outright in any
  # non-interactive upgrade. The agent is a user agent; removing it needs no root,
  # and `bootout` (unlike bootstrap) works from the sandbox; the plist is declared.
  uninstall_preflight_steps do
    run "{{appdir}}/awake.app/Contents/MacOS/awake",
        args:           ["agent", "uninstall"],
        writable_paths: ["Library/LaunchAgents"],
        writable_base:  :home
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
