cask "freetube" do
  arch arm: "arm64", intel: "x64"

  version "0.23.7"
  sha256 arm:   "70a8d24a15a1b4dc0c341b1c3687ccd6c8f53c22a94c63e26511596ecf66c6be",
         intel: "060b5fcbcb6898491ba9897d0560d780113fc7c5f77c68470499a1224c805627"

  url "https://github.com/FreeTubeApp/FreeTube/releases/download/v#{version}-beta/freetube-#{version}-beta-mac-#{arch}.dmg",
      verified: "github.com/FreeTubeApp/FreeTube/"

  name "FreeTube"
  desc "YouTube player focusing on privacy"
  homepage "https://freetubeapp.io/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)/i)
  end

  depends_on macos: ">= :big_sur"

  app "FreeTube.app"

  uninstall quit: "io.freetubeapp.freetube"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/io.freetubeapp.freetube.sfl*",
    "~/Library/Application Support/FreeTube",
    "~/Library/Preferences/io.freetubeapp.freetube.plist",
    "~/Library/Saved Application State/io.freetubeapp.freetube.savedState",
  ]
end
