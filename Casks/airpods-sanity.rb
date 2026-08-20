cask "airpods-sanity" do
  version "1.0.5.0"
  sha256 "820b0de73856431dfd27db6ee6db80cd23c944ba7831669fc5a844af42e4ec40"

  url "https://github.com/Gaulomatic/AirPodsSanity/releases/download/#{version}/AirPods.Sanity.#{version}.dmg"
  name "AirPods Sanity"
  desc "Keeps AirPods on high-quality output by holding the input device"
  homepage "https://github.com/Gaulomatic/AirPodsSanity"

  app "AirPods Sanity.app"

  zap trash: [
    "~/Library/Preferences/de.gaulomatic.AirPodsSanity.plist",
  ]
end
