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
     "repo": "https://github.com/WeirdBrains/example"
   }
   ```

   `repo` is optional. `slug` names the screenshot file.
2. Run `scripts/screenshots.sh example` to capture `web/images/projects/example.webp`. With no
   arguments the script refreshes every screenshot. It needs `chromium` (or set `CHROMIUM`),
   ImageMagick (`magick`) and `python3`. It runs Chromium headless with a clean environment, so no
   window opens.
3. Commit and push to `main`. The workflow builds and deploys.

## Build locally

```sh
dart pub global activate jaspr_cli 0.24.0-beta.1
dart pub get
jaspr serve                # development
jaspr build                # static output in build/jaspr
```

## License

BSD 3-Clause, copyright Weird Brains LLC. See [LICENSE](LICENSE).
