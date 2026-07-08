#!/usr/bin/env bash
# Deploy the current stable manuals to the public website (www.journeyways.ca).
# Run this whenever there is a new STABLE version of the documents. It rebuilds,
# copies the readable 1-up PDFs into the site's download folder (same filenames,
# so existing links keep working), and refreshes the file-size labels in
# boardgame.html.
#
# After running: commit the www repo, and if journeyways.ca is proxied through
# Cloudflare, purge the cache for /download/*.pdf so visitors get the new files.
set -euo pipefail
cd "$(dirname "$0")"

./build.sh >/dev/null

WWW="$HOME/apps/journeyways/www"
DL="$WWW/download"

# Website "Rulebook" = the readable game rules; "Player Booklet" = the 1-up booklet.
cp manual.pdf         "$DL/JOURNEYWAYS Game Rules 1.0.pdf"
cp player-booklet.pdf "$DL/JOURNEYWAYS Player Booklet 1.0.pdf"

# Keep the (PDF, size) labels in the download links accurate.
rb=$(awk "BEGIN{printf \"%.1f MB\", $(stat -c%s manual.pdf)/1048576}")
pb=$(awk "BEGIN{printf \"%.1f MB\", $(stat -c%s player-booklet.pdf)/1048576}")
sed -i -E \
  -e "s#(Download Rulebook \(PDF, )[^)]*#\1${rb}#" \
  -e "s#(Download Player Booklet \(PDF, )[^)]*#\1${pb}#" \
  "$WWW/boardgame.html"

echo "Deployed to the website:"
echo "  Rulebook       -> JOURNEYWAYS Game Rules 1.0.pdf   (${rb})"
echo "  Player Booklet -> JOURNEYWAYS Player Booklet 1.0.pdf (${pb})"
echo "Next: commit the www repo; purge Cloudflare cache for /download/*.pdf if proxied."
