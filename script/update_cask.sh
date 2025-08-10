#!/usr/bin/env bash
set -euo pipefail

owner="FreeTubeApp"
repo="FreeTube"
cask_file="Casks/freetube.rb"

# Get the most recent release (including pre-releases)
json=$(curl -s "https://api.github.com/repos/$owner/$repo/releases" | jq -r '.[0]')
tag=$(jq -r '.tag_name' <<<"$json" | sed 's/^v//' | sed 's/-beta$//')

# Check for universal build (currently not used by FreeTube, but keep for future)
uni=$(jq -r '.assets[] | select(.name|test("mac.*universal.*\\.(dmg|zip)$"; "i")) | .browser_download_url' <<<"$json" | head -n1)

if [[ -n "${uni:-}" ]]; then
  # Universal build found (not currently used by FreeTube)
  echo "Universal build found, but FreeTube cask expects separate arch builds"
  echo "Falling back to arch-specific builds..."
fi

# Get arch-specific builds
url_arm=$(jq -r '.assets[] | select(.name|test("mac.*(arm64|aarch64).*\\.(dmg|zip)$"; "i")) | .browser_download_url' <<<"$json" | head -n1)
url_intel=$(jq -r '.assets[] | select(.name|test("mac.*(x64|amd64).*\\.(dmg|zip)$"; "i")) | .browser_download_url' <<<"$json" | head -n1)

[[ -n "$url_arm" && -n "$url_intel" ]] || { echo "Could not find both arch assets"; exit 1; }

# Download and calculate SHA256
f_arm=$(basename "$url_arm")
f_intel=$(basename "$url_intel")

echo "Downloading ARM64 build..."
curl -L -o "$f_arm" "$url_arm"
echo "Downloading Intel build..."
curl -L -o "$f_intel" "$url_intel"

sha_arm=$(shasum -a 256 "$f_arm" | awk '{print $1}')
sha_intel=$(shasum -a 256 "$f_intel" | awk '{print $1}')

echo "ARM64 SHA256: $sha_arm"
echo "Intel SHA256: $sha_intel"

# Clean up downloaded files
rm -f "$f_arm" "$f_intel"

# Update the cask file
# We need to update:
# 1. version line
# 2. sha256 arm: and intel: values
# The URL pattern should remain the same with interpolation

tmp="$(mktemp)"

awk -v ver="$tag" -v sha_arm="$sha_arm" -v sha_intel="$sha_intel" '
  # Update version line
  /^[[:space:]]*version[[:space:]]+"/ {
    print "  version \"" ver "\""
    next
  }
  
  # Update sha256 line
  /^[[:space:]]*sha256[[:space:]]+arm:/ {
    print "  sha256 arm:   \"" sha_arm "\","
    # Read and update intel line on next line
    getline
    if ($0 ~ /intel:/) {
      print "         intel: \"" sha_intel "\""
    } else {
      print
    }
    next
  }
  
  # Print all other lines as-is
  { print }
' "$cask_file" > "$tmp"

# Validate the file has proper Ruby syntax
if ruby -c "$tmp" 2>/dev/null; then
  mv "$tmp" "$cask_file"
  echo "Successfully updated $cask_file to version $tag"
else
  echo "Error: Generated cask file has syntax errors"
  cat "$tmp"
  rm "$tmp"
  exit 1
fi