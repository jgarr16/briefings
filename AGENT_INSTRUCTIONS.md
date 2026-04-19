# Instructions for automated briefings (local repo → GitHub Pages)

This repository powers a **static site** on GitHub Pages. The live page always reads **one file**: `briefings/latest.md`. There is **no** `current.json` or other pointer file.

---

## What to write

### 1. Path (required)

Put the daily briefing at:

```text
briefings/latest.md
```

(`latest.md` lives **inside** the `briefings/` folder in the repo root — not the repository root.)

### 2. Format (required)

The file **must** start with YAML front matter that includes the calendar date in **ISO 8601** form (`YYYY-MM-DD`):

```markdown
---
date: 2026-08-05
---

Your markdown body starts here…
```

Rules:

- **`date`** must look exactly like `2026-08-05` (four digits, hyphen, two digits, hyphen, two digits). That value is what appears **alone** at the top of the web page.
- **Do not repeat that date as a big `#` heading** unless you want it duplicated in the article. Prefer starting the body with `##` sections, bold lead-ins, or paragraphs. If the first line is a single `# …` heading, the site **strips one** leading `#` line from the body to avoid a duplicate title — but the clean approach is to **omit** a top-level `#` and use `##` for sections.

### 3. Archive (optional; automatic if you use the script)

Past briefings can live under:

```text
briefings/archive/YYYY-MM-DD.md
```

Nothing in `archive/` is read by the website; it is only for your records.

If you use `./scripts/update-briefing.sh YYYY-MM-DD [file]`, it writes `latest.md` with the correct `date:` front matter, strips an optional leading `#` line from the body, and **once per calendar day** copies the **previous** `latest.md` to `archive/<old-date>.md` (using the old file’s `date:` field) if that archive file does not already exist.

---

## Publish to GitHub (required for the site to update)

Run these commands **from the repository root** (the folder that contains `index.html` and `briefings/`). Adjust the commit message as you like.

```bash
cd /path/to/briefings

git add briefings/latest.md
# If you created an archive copy:
git add briefings/archive/2026-08-05.md

git status
git commit -m "Briefing 2026-08-05"
git push origin main
```

Requirements:

- **`git` must use a remote** (usually `origin`) pointing at the GitHub repo, and credentials that are allowed to **push** to `main` (SSH key, HTTPS token, or `gh` auth).
- After the push, **GitHub Pages** redeploys in about one to two minutes. The page uses `cache: no-store` when loading `latest.md`, so a refresh should show the new text after deploy.

If `git push` fails, fix authentication or branch name (`main` vs `master`) before retrying.

---

## Quick checklist for agents

1. Write or generate markdown for that calendar day.
2. Ensure **`briefings/latest.md`** contains `date: YYYY-MM-DD` in front matter and the body you want (no duplicate top-level title if possible).
3. Optionally copy to **`briefings/archive/YYYY-MM-DD.md`** for history.
4. **`git add`** → **`git commit`** → **`git push`** to `main`.
5. Confirm the public site URL after a short wait (same repo Pages URL as configured in GitHub).

---

## Troubleshooting

| Symptom | Likely cause |
|--------|----------------|
| Site shows old content | Push did not complete, or Pages not built yet — wait and hard-refresh. |
| Error about `date` / front matter | Missing or invalid `date:` line; must match `YYYY-MM-DD`. |
| 404 on the site | Pages not enabled, wrong branch/folder, or repo not public as expected. |
