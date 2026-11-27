# pages

Source for [james.blackwellmail.co.uk](https://james.blackwellmail.co.uk), built by GitHub Pages
(Jekyll, `jekyll-theme-tactile`).

## Layout

All content lives in one file, [`_data/cv.yml`](_data/cv.yml). Two templates render it:

| Page | Template | Shows |
| --- | --- | --- |
| `/` (full profile) | `index.html` | everything: profile, `summary` and `details` fields, certifications, hobbies, links |
| `/portfolio-short.html` | `portfolio-short.html` | skills, experience and education `summary` fields only |

The shared skills / experience / education markup is in `_includes/cv.html`.

## Editing

- Text fields in `_data/cv.yml` are Markdown.
- Add a `details:` field to any skill, job or school to show extra content on the full profile only.
- Jobs with `compact: true` are grouped under "Other" on the short portfolio.

## Building locally

GitHub Pages builds and deploys the site on push to `main`; local builds are only for previewing.

```sh
./build.sh          # render into _site/ (gitignored)
./build.sh serve    # live preview on http://localhost:4000
```

The script uses a local `jekyll` if installed, otherwise the `jekyll/jekyll:pages` Docker image.
