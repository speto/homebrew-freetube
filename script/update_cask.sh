#!/usr/bin/env bash
set -euo pipefail

owner="FreeTubeApp"
repo="FreeTube"
cask_file="Casks/freetube.rb"

# Get the most recent release (including pre-releases)
json=$(curl -s "https://api.github.com/repos/$owner/$repo/releases" | jq -r '.[0]')
tag=$(jq -r '.tag_name' <<<"$json" | sed 's/^v//' | sed 's/-beta$//')

# Prefer universal if present
uni=$(jq -r '.assets[] | select(.name|test("mac.*universal.*\\.(dmg|zip)$"; "i")) | .browser_download_url' <<<"$json" | head -n1)

if [[ -n "${uni:-}" ]]; then
  # One URL + one SHA
  url="$uni"
  file=$(basename "$url")
  curl -L -o "$file" "$url"
  sha=$(shasum -a 256 "$file" | awk '{print $1}')

  # Replace to single-url cask (no on_arm/on_intel blocks)
  awk -v ver="$tag" -v sha="$sha" -v url="$url" '
    BEGIN{arm=0;intel=0}
    {print}
  ' "$cask_file" \
  | sed -E "s/version \"[^\"]+\"/version \"${tag}\"/" \
  | sed -E "s#sha256 \".*\"#sha256 \"${sha}\"#" \
  | sed -E "s#url \".*\"#url \"${url}\"#" \
  > "${cask_file}.tmp" && mv "${cask_file}.tmp" "$cask_file"

else
  # Fallback: arm64 + x64
  url_arm=$(jq -r '.assets[] | select(.name|test("mac.*(arm64|aarch64).*\\.(dmg|zip)$"; "i")) | .browser_download_url' <<<"$json" | head -n1)
  url_intel=$(jq -r '.assets[] | select(.name|test("mac.*(x64|amd64).*\\.(dmg|zip)$"; "i")) | .browser_download_url' <<<"$json" | head -n1)

  [[ -n "$url_arm" && -n "$url_intel" ]] || { echo "Could not find both arch assets"; exit 1; }

  f_arm=$(basename "$url_arm"); curl -L -o "$f_arm" "$url_arm"
  f_intel=$(basename "$url_intel"); curl -L -o "$f_intel" "$url_intel"

  sha_arm=$(shasum -a 256 "$f_arm" | awk '{print $1}')
  sha_intel=$(shasum -a 256 "$f_intel" | awk '{print $1}')

  # Update version + arch-specific url/sha
  tmp="$(mktemp)"
  awk -v ver="$tag" -v sha_arm="$sha_arm" -v sha_intel="$sha_intel" -v url_arm="$url_arm" -v url_intel="$url_intel" '
    {
      gsub(/version "[^"]+"/, "version \"" ver "\"")
      if ($0 ~ /on_arm do/)  in_arm=1
      if ($0 ~ /on_intel do/) in_intel=1
      if (in_arm && $0 ~ /sha256 "/) gsub(/sha256 "[^"]+"/, "sha256 \"" sha_arm "\"")
      if (in_arm && $0 ~ /url "/)    gsub(/url "[^"]+"/,    "url \"" url_arm "\"")
      if (in_intel && $0 ~ /sha256 "/) gsub(/sha256 "[^"]+"/, "sha256 \"" sha_intel "\"")
      if (in_intel && $0 ~ /url "/)    gsub(/url "[^"]+"/,    "url \"" url_intel "\"")
      if ($0 ~ /end/ && in_arm)   in_arm=0
      if ($0 ~ /end/ && in_intel) in_intel=0
      print
    }
  ' "$cask_file" > "$tmp"
  mv "$tmp" "$cask_file"
fi
