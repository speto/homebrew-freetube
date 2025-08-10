# homebrew-freetube

Homebrew tap for [FreeTube](https://freetubeapp.io/), the open source desktop YouTube player focusing on privacy.

## Why this tap exists

FreeTube has been deprecated in the official Homebrew repository and is scheduled to be disabled on 2026-09-01. The reason for this deprecation is that the application is **unsigned** (lacks proper macOS code signing certificates). This tap provides a way to continue installing FreeTube via Homebrew despite the unsigned status.

## Installation

```bash
brew tap speto/freetube
brew install --cask speto/freetube/freetube
```

**Note:** After 2026-09-01, the official Homebrew cask will be disabled and `brew install --cask freetube` will no longer work. This tap will continue to provide FreeTube installation capability beyond that date.

## About FreeTube

FreeTube is a YouTube client for Windows, Mac, and Linux built around privacy. It uses a local API to fetch data from YouTube without requiring an account or exposing your real IP address.

## License

This tap is maintained independently from the FreeTube project. FreeTube itself is licensed under [AGPL-3.0](https://github.com/FreeTubeApp/FreeTube/blob/master/LICENSE).