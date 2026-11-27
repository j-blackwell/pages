#!/usr/bin/env bash
# Render the site locally for previewing. GitHub Pages does the real build on push.
#
#   ./build.sh          build into a new timestamped folder _site/<YYYY-MM-DD_HH-MM-SS>/ (gitignored),
#                       print the CV to cv.pdf inside it, point _site/latest at it, print file:// links
#   ./build.sh serve    build into _site/serve/, watch for changes and serve on http://localhost:4000
#
# Uses a local `jekyll` if one is installed, otherwise the jekyll/jekyll:pages Docker image.
# The PDF needs Chrome or Chromium; the one-page check needs pdfinfo (poppler).
set -euo pipefail
cd "$(dirname "$0")"

stamp="$(date +%Y-%m-%d_%H-%M-%S)"
port=4000
pages=("" "portfolio-short.html")

# Each build gets its own folder. Jekyll empties its destination, so serve uses a
# separate one rather than _site/ itself, which would wipe the timestamped builds.
mode="${1:-build}"
case "$mode" in
  build) dest="_site/$stamp" ;;
  serve) dest="_site/serve" ;;
  *) echo "usage: $0 [build|serve]" >&2; exit 1 ;;
esac
site_dir="$PWD/$dest"

case "$mode" in
  # baseurl = absolute path of the build folder, so root-relative links resolve over file://
  build) args=(build --destination "$dest" --baseurl "$site_dir") ;;
  serve) args=(serve --destination "$dest" --host 0.0.0.0 --port "$port" --watch --force_polling) ;;
esac

if command -v jekyll >/dev/null 2>&1; then
  cmd=(jekyll "${args[@]}")
elif command -v docker >/dev/null 2>&1; then
  docker_flags=(--rm -v "$PWD:/srv/jekyll" --user "$(id -u):$(id -g)" -e JEKYLL_ROOTLESS=1)
  [[ -t 0 ]] && docker_flags+=(-it)  # so Ctrl-C stops the container
  [[ "$mode" == serve ]] && docker_flags+=(--name pages-preview -p "$port:$port")
  cmd=(docker run "${docker_flags[@]}" jekyll/jekyll:pages jekyll "${args[@]}")
else
  echo "Needs either jekyll (Ruby) or docker." >&2
  exit 1
fi

if [[ "$mode" == serve ]]; then
  echo "Serving on:"
  for page in "${pages[@]}"; do echo "  http://localhost:$port/$page"; done
  echo
  exec "${cmd[@]}"
fi

mkdir -p "$site_dir"  # create it as us, not as Docker's root
"${cmd[@]}"

# Print the CV to PDF.
pdf="$site_dir/cv.pdf"
chrome=""
for c in chromium chromium-browser google-chrome-stable google-chrome; do
  if command -v "$c" >/dev/null 2>&1; then chrome="$c"; break; fi
done
if [[ -n "$chrome" ]]; then
  "$chrome" --headless --disable-gpu --no-pdf-header-footer --virtual-time-budget=5000 \
    --print-to-pdf="$pdf" "file://$site_dir/portfolio-short.html" >/dev/null 2>&1
  if command -v pdfinfo >/dev/null 2>&1; then
    n=$(pdfinfo "$pdf" | awk '/^Pages:/ {print $2}')
    if [[ "$n" != 1 ]]; then
      echo "WARNING: the CV is $n pages long; it should fit on one A4 page." >&2
    fi
  fi
else
  pdf=""
  echo "Skipping cv.pdf: install Chrome or Chromium to print the CV." >&2
fi

ln -sfn "$stamp" "$PWD/_site/latest"

echo
echo "Built into $dest/ (also at _site/latest/). Open:"
for page in "${pages[@]}"; do echo "  file://$site_dir/${page:-index.html}"; done
[[ -n "$pdf" ]] && echo "  file://$pdf"
exit 0
