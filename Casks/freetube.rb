cask "freetube" do
  arch arm: "arm64", intel: "x64"

  version "0.23.8"
  sha256 arm:   "16b76817a7b423fe6cbb9b00d256ef669a94db41a6a66a87526a44765aa04b43",
         intel: "96e75bd43126ca2b8a963f3f08b9a7cc6336b3850dc5c58733802886b06c206e"

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
