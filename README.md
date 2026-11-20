# opensource.weirdbrains.com

The directory of public [Weird Brains](https://weirdbrains.com) projects that have a website: a
screenshot, a short description and a link for each. Live at <https://opensource.weirdbrains.com>.
Built with [Jaspr](https://jaspr.site) in static mode (`jaspr_cli` 0.24.0-beta.1) and deployed to
GitHub Pages by `.github/workflows/site.yml`.

## Add a project

A project qualifies when its repository in the [WeirdBrains organization](https://github.com/WeirdBrains)
is public and its website is live (HTTP 200).

1. Add one entry to `data/projects.json`:

   ```json
   {
     "slug": "example",
     "name": "Example",
     "kind": "CLI",
     "blurb": "One or two sentences, taken from the project's README or site.",
     "site": "https://example.weirdbrains.com/",
     "repo": "https://github.com/WeirdBrains/example",
     "tags": ["Rust"],
     "license": "BSD-3-Clause"
   }
   ```

   `repo`, `tags` and `license` are optional. `slug` names the screenshot file. `tags` are the
   main languages or technologies, shown as badges; `license` is the repository's SPDX id.
2. Run `scripts/screenshots.sh example` to capture `web/images/projects/example.webp`. With no
   arguments the script refreshes every screenshot. It needs `chromium` (or set `CHROMIUM`),
   ImageMagick (`magick`) and `python3`. It runs Chromium headless with a clean environment, so no
   window opens.
3. Commit and push to `main`. The workflow builds and deploys.

## Design

- Logo: `web/logo.svg` (a brain split by a slash, its folds forming `</>`, plus a spark) and
  `web/favicon.svg` (the same mark on a navy tile). `scripts/icons.sh` rebuilds the favicons,
  `apple-touch-icon.png`, `logo-512.png` and `og-image.png` (from `scripts/og-image.html`).
- Colors: CSS variables at the top of `web/styles.css`, dark by default with a light theme through
  `prefers-color-scheme`.
- Type: Space Grotesk for headings and Inter for text, self-hosted in `web/fonts` under the SIL
  Open Font License. No third-party requests.
- The hero carousel is `web/carousel.js`, plain JavaScript. Without JavaScript the slides stay a
  scrollable strip.

## Build locally

```sh
dart pub global activate jaspr_cli 0.24.0-beta.1
dart pub get
jaspr serve                # development
jaspr build                # static output in build/jaspr
```

## License

BSD 3-Clause, copyright Weird Brains LLC. See [LICENSE](LICENSE).
