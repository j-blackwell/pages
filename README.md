# pages

Source for [james.blackwellmail.co.uk](https://james.blackwellmail.co.uk), built by GitHub Pages (Jekyll).

## Layout

All content lives in one file, [`_data/cv.yml`](_data/cv.yml). Two pages render it:

| Page | Template | Shows |
| --- | --- | --- |
| `/` (full profile) | `index.html` | everything: profile, `summary` and `details` fields, certifications, hobbies, links |
| `/portfolio-short.html` (one-page CV) | `portfolio-short.html` | skills, experience and education `summary` fields only |

| File | Purpose |
| --- | --- |
| `_layouts/cv.html` | page shell: header, photo, contact links, timeline |
| `_includes/cv.html` | skills, experience and education sections |
| `_includes/timeline.html` | career timeline built from role and education dates |
| `_includes/month-index.html`, `date-range.html` | date helpers |
| `assets/css/site.css` | all styles, including the A4 print layout for the CV |
| `assets/fonts/` | self-hosted IBM Plex Sans and Mono (SIL Open Font License) |

## Editing

- Text fields in `_data/cv.yml` are Markdown.
- Add a `details:` field to any skill, job or school to show extra content on the full profile only.
- Dates (`start`, `end`, `since`) take a year (`2019`), year-month (`2019-09`) or full date.
  Leave out `end` for a current role. Pages show years; the timeline and skill years use months when given.
- Years of experience for skills are calculated from `since` each time the site builds.
- Jobs with `compact: true` are grouped under "Other" on the CV.
- Links with `cv: true` appear on the CV, using `label` as readable text; `profile: false` hides one on the full profile.

## Building locally

GitHub Pages builds and deploys the site on push to `main`; local builds are only for previewing.

```sh
./build.sh          # render into _site/ (gitignored) and print the CV to _site/cv.pdf
./build.sh serve    # live preview on http://localhost:4000
```

The script uses a local `jekyll` if installed, otherwise the `jekyll/jekyll:pages` Docker image.
The PDF needs Chrome or Chromium, and the script warns if the CV runs past one A4 page.
