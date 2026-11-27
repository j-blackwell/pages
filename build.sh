#!/usr/bin/env bash
# Render the site locally for previewing. GitHub Pages does the real build on push.
#
#   ./build.sh          build into _site/ (gitignored) and print file:// links to open
#   ./build.sh serve    build, watch for changes and serve on http://localhost:4000
#
# Uses a local `jekyll` if one is installed, otherwise the jekyll/jekyll:pages Docker image.
set -euo pipefail
cd "$(dirname "$0")"

site_dir="$PWD/_site"
port=4000
pages=("" "portfolio-short.html")

mode="${1:-build}"
case "$mode" in
  # baseurl = absolute path of _site/, so the theme's /assets/... links resolve over file://
  build) args=(build --baseurl "$site_dir") ;;
  serve) args=(serve --host 0.0.0.0 --port "$port" --watch --force_polling) ;;
  *) echo "usage: $0 [build|serve]" >&2; exit 1 ;;
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

"${cmd[@]}"
echo
echo "Built into _site/. Open:"
for page in "${pages[@]}"; do echo "  file://$site_dir/${page:-index.html}"; done
