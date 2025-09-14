cask "freetube" do
  arch arm: "arm64", intel: "x64"

  version "0.23.9"
  sha256 arm:   "e526d78d6aa4bf930e52cdd8f77212197c1997349f6918c5a5c0da8cc53d0688",
         intel: "2b63006eec35326efe9f5f28e3c36664a702b521795130c720ae1f91f5fbfc01"

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
