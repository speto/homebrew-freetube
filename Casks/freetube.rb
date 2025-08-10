cask "freetube" do
  arch arm: "arm64", intel: "x64"

  version "0.23.6"
  sha256 arm:   "abb36ad569689cfc80c4e213a5e3033110938084fc4f40fe63fc3600cf8334b4",
         intel: "8aa309b4c6c70cf7458d452059e4bc7542b6b7333b597285ffdf54a2b549a431"

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