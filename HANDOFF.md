# Handoff

Running log for [opensource.weirdbrains.com](https://opensource.weirdbrains.com), a directory of public [Weird Brains](https://weirdbrains.com) projects. Newest entry first.

## 2026-11-21: TAUR package server added

- **Changed:** added a "TAUR Packages" entry (kind: Package server) to `data/projects.json`, right after the TAUR entry. It links to <https://pkg.taur.weirdbrains.com/> with the [TAUR repository](https://github.com/WeirdBrains/taur), and its blurb says to point yay or paru at it. Added the screenshot `web/images/projects/taur-packages.webp`. The site now lists 12 projects.
- **Commits:** [06a6ede](https://github.com/WeirdBrains/opensource-site/commit/06a6ede).
- **Checks:** `dart analyze` clean; `jaspr build` succeeded and the built page contains the new link and "12 open source projects". The deploy workflow runs the same checks on push.
- **Not tested:** nothing outstanding; the screenshot was refreshed after the package server moved to [TAUR v1.13.1](https://github.com/WeirdBrains/taur/releases/tag/v1.13.1).
- **Left:** none for this change.
- **Next:** nothing for this change.
