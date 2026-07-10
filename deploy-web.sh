#!/usr/bin/env bash
# Deploy the current stable manuals to the public website (www.journeyways.ca),
# in every language. Run this whenever there is a new STABLE version of the
# documents. It rebuilds all languages and copies the readable 1-up PDFs into the
# site's download folder as language-suffixed files:
#   JOURNEYWAYS Game Rules 1.0 {EN,ES,FR}.pdf
#   JOURNEYWAYS Player Booklet 1.0 {EN,ES,FR}.pdf
# The English copies are also written to the legacy un-suffixed names so any
# existing external links keep working.
#
# After running: re-render the component-page previews if the layout changed,
# bump the ?v= on the on-site PDF links (same-name files stay Cloudflare-cached;
# the DNS-scoped cloudflare-token cannot purge), commit the www repo, and purge
# the /download/*.pdf cache once a dedicated Cache-Purge token exists.
set -euo pipefail
cd "$(dirname "$0")"

./build.sh >/dev/null

WWW="$HOME/apps/journeyways/www"
DL="$WWW/download"

declare -A UP=( [en]=EN [es]=ES [fr]=FR )

echo "Deployed to the website:"
for L in en es fr; do
  U=${UP[$L]}
  cp "manual_${L}.pdf"         "$DL/JOURNEYWAYS Game Rules 1.0 ${U}.pdf"
  cp "player-booklet_${L}.pdf" "$DL/JOURNEYWAYS Player Booklet 1.0 ${U}.pdf"
  rb=$(awk "BEGIN{printf \"%.1f MB\", $(stat -c%s "manual_${L}.pdf")/1048576}")
  pb=$(awk "BEGIN{printf \"%.1f MB\", $(stat -c%s "player-booklet_${L}.pdf")/1048576}")
  echo "  ${U}: Game Rules (${rb}) + Player Booklet (${pb})"
done

# English also written to the legacy un-suffixed names (external-link stability).
cp "manual_en.pdf"         "$DL/JOURNEYWAYS Game Rules 1.0.pdf"
cp "player-booklet_en.pdf" "$DL/JOURNEYWAYS Player Booklet 1.0.pdf"

echo "Next: bump ?v= on the on-site PDF links if these overwrote cached files;"
echo "      commit the www repo; purge Cloudflare /download/*.pdf once a purge token exists."
