cask "freetube" do
  arch arm: "arm64", intel: "x64"

  version "0.23.10"
  sha256 arm:   "5171d8a74c2a0dc3fde19f9896de12ad7ca1aa5f5ead54da236f2696e726927b",
         intel: "f5f2befeaa54e31ee8e237fc7385b71c26b4267b2b872cd521739b5251922400"

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
