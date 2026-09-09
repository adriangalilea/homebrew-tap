cask "vial" do
  version "0.7.5"
  sha256 "b628db11f8df012faafcceef7deb36b54821b507d4c970336f85a56c800e8876"

  url "https://github.com/vial-kb/vial-gui/releases/download/v#{version}/Vial-v#{version}.dmg"
  name "Vial"
  desc "Configurator for Vial-firmware keyboards (Svalboard), live over raw HID"
  homepage "https://get.vial.today/"

  # Lives here because homebrew-cask disabled its copy on 2026-09-01: the app
  # is not code-signed, so it fails their Gatekeeper check. Same upstream dmg,
  # pinned by sha. Install with --no-quarantine or macOS refuses to open it.
  app "Vial.app"

  zap trash: [
    "~/Library/Preferences/com.vial.Vial.plist",
    "~/Library/Saved Application State/Vial.savedState",
  ]
end
