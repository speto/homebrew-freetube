cask "freetube" do
  version "0.23.6"
  
  on_arm do
    sha256 "abb36ad569689cfc80c4e213a5e3033110938084fc4f40fe63fc3600cf8334b4"
    url "https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.6-beta/freetube-0.23.6-beta-mac-arm64.dmg"
  end

  on_intel do
    sha256 "8aa309b4c6c70cf7458d452059e4bc7542b6b7333b597285ffdf54a2b549a431"
    url "https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.6-beta/freetube-0.23.6-beta-mac-x64.dmg"
  end

  name "FreeTube"
  desc "YouTube player focusing on privacy"
  homepage "https://freetubeapp.io/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]beta)?$/i)
  end

  app "FreeTube.app"

  zap trash: [
    "~/Library/Application Support/FreeTube",
    "~/Library/Preferences/io.freetubeapp.freetube.plist",
    "~/Library/Saved Application State/io.freetubeapp.freetube.savedState",
  ]
end
