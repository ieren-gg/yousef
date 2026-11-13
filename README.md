# Capstone: secure a practice web app, and watch it


> **Darsi briefs are short on purpose.** The in-app lesson shows tight numbered clicks. This README keeps the full commands, error fixes, and background for each milestone — open the matching **Milestone N** section when you need detail.

Defence only on your computer: run OWASP Juice Shop behind nginx on localhost, scan it passively with ZAP baseline and check its config with Semgrep, add five proxy defences, detect a login attack in the logs, and write an incident runbook with an EG-CERT note and an Arabic parent poster.

[العربية](README.ar.md)

## What you will be able to do

- Run real free tools from a laptop or Codespaces
- Finish five milestones, each with checks you can self-verify
- Leave with a portfolio piece: a report, demo or tool tagged v1.0
- **Darsi never runs your code** — it reads your link and check file, then an advisory review

## Install once

### Windows

1. Install Docker Desktop for Windows from https://www.docker.com/products/docker-desktop (free for personal and education use). Turn on WSL 2 when it asks.
2. Install Python 3.12 and Git: in PowerShell run `winget install Python.Python.3.12`, then `winget install Git.Git`. Install VS Code from https://code.visualstudio.com (free).
3. On GitHub, open https://github.com/darsi-org/cyber-capstone and press **Use this template** to make your own copy. Then clone your copy, not darsi-org's: `git clone https://github.com/<your-username>/cyber-capstone.git`
4. Open a new PowerShell, go into the folder with `cd cyber-capstone`, and run these lines one at a time:

   ```powershell
   docker compose up -d
   python -m venv .venv
   .venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   python check.py
   ```

   If PowerShell says running scripts is disabled on this system, you don't need to change any setting: use Command Prompt and run `.venv\Scripts\activate.bat` instead, or skip activating and start every command with `.venv\Scripts\python` (for example `.venv\Scripts\python -m pip install -r requirements.txt`, then `.venv\Scripts\python check.py`).

Everything binds to localhost only on this computer.

### Mac

1. Install Docker Desktop for Mac from https://www.docker.com/products/docker-desktop
2. Install Homebrew from https://brew.sh if you don't have it, then `brew install python@3.12 git`, and install VS Code from https://code.visualstudio.com
3. On GitHub, open https://github.com/darsi-org/cyber-capstone, press **Use this template**, then clone your copy: `git clone https://github.com/<your-username>/cyber-capstone.git`
4. In Terminal, go into the folder with `cd cyber-capstone` and run:

   ```bash
   docker compose up -d
   python3.12 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   python check.py
   ```

Everything binds to localhost only.

### Codespaces

Open your copy in GitHub Codespaces: **Code** → **Codespaces** → **Create codespace**. Docker, Python and Git are already there, and localhost means your codespace, not anyone else's computer. Colab cannot run Docker, so use Codespaces for this capstone. In its terminal, run:

```bash
docker compose up -d
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python check.py
```

A phone browser is enough to read the results.

## Start

Press **Use this template** on https://github.com/darsi-org/cyber-capstone, clone your copy, then follow milestone 1.

## Milestones

### m1: Your lab, on localhost only (3 hours)

#### Why this matters
Juice Shop is intentionally insecure. On the open internet it becomes someone else's problem — and yours legally. Localhost only.

#### Tools for this milestone
- **Docker Desktop** — runs Juice Shop and nginx. Get it: https://www.docker.com/products/docker-desktop — free for personal/education
- **OWASP Juice Shop** — a deliberately insecure practice shop. Get it: image pulled by docker compose

#### Do this
1. Set up your copy as in **Install once** (your copy, not darsi-org's), so `docker compose up -d` has started the lab.
2. Check: docker compose ps and open http://localhost:8080. Confirm ports in docker-compose.yml are 127.0.0.1:…
3. Write SCOPE.md: only your lab on localhost; no school or public site. Run python check.py --milestone m1.

#### You know you're done when
- Ports bound to 127.0.0.1
- SCOPE.md names localhost
- m1 passes

#### If something goes wrong
- **Docker Desktop won't start on Windows** → Enable WSL 2 and virtualisation in BIOS; restart
- **Port already in use** → Stop the other container or change the host port, still on 127.0.0.1
- **0.0.0.0 in compose by mistake** → Change every ports line back to 127.0.0.1:HOST:CONTAINER

#### What you should understand
You can stand up an insecure practice target that only your computer can reach, with a written scope.

**Hand in:** docker-compose.yml with localhost ports, SCOPE.md, and darsi-check.json that passes m1.

### m2: Passive scans: ZAP baseline and Semgrep (3 hours)

#### Why this matters
Start by looking without attacking. Baseline mode reads responses; it does not break in.

#### Tools for this milestone
- **OWASP ZAP** — passive baseline scanner. Get it: the Docker image that scripts/zap-baseline.* runs
- **Semgrep** — static rules on your nginx config and scripts. Get it: the semgrep/semgrep Docker image (Actions also runs it from ci.yml)

#### Do this
1. Run `powershell -ExecutionPolicy Bypass -File scripts\zap-baseline.ps1 before` (Windows; it changes no setting) or `bash scripts/zap-baseline.sh before` (Mac, Codespaces).
2. Run Semgrep on nginx/ and scripts/ (the same line works in PowerShell and in a Mac or Codespaces terminal): `docker run --rm -v "${PWD}:/src" semgrep/semgrep semgrep scan --config auto nginx scripts`. Make FINDINGS.md: alert, risk, where, what it means for a real school site.
3. Run python check.py --milestone m2.

#### You know you're done when
- reports/before/scan-meta.json is localhost zap
- FINDINGS.md exists
- m2 passes

#### If something goes wrong
- **Script refused the target** → Only http://localhost:8080 (or 127.0.0.1) is allowed
- **ZAP container can't reach the app on Windows or Mac** → The scripts rewrite localhost to host.docker.internal for Docker Desktop; check `docker compose ps` shows the proxy running
- **ZAP didn't write a report** → The lab isn't running: `docker compose up -d`, then scan again
- **Too many Low alerts** → Rank by High/Medium first; Low can wait

#### What you should understand
You can run a passive web scan only on your lab and explain findings in plain words.

**Hand in:** reports/before/, FINDINGS.md, and darsi-check.json that passes m2.

### m3: Five fixes in front of the app (4 hours)

#### Why this matters
You cannot change Juice Shop's code, like many schools cannot change old software. A proxy is a real defence layer.

#### Tools for this milestone
- **nginx** — adds headers, rate limits, size limits. Get it: config in nginx/default.conf

#### Do this
1. In nginx/default.conf add: security headers (CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy), secure cookie flags, rate limit on /rest/user/login, server_tokens off, body size limit.
2. Restart: docker compose restart proxy. Rescan into reports/after/ with the same script and `after` in place of `before`.
3. Compare High/Medium alerts before and after. Run python check.py --milestone m3.

#### You know you're done when
- nginx has the five defences
- after scan is localhost
- m3 passes

#### If something goes wrong
- **Config test fails** → `docker compose run --rm proxy nginx -t` and read the error line (run, not exec: a proxy with a broken config has stopped, so there is nothing to exec into)
- **App broken after headers** → Relax CSP carefully; start with default-src 'self'
- **Alert count did not drop** → Confirm you rescanned the proxy port 8080, not 3000 directly

#### What you should understand
You can harden old software from in front and prove it with the same scan.

**Hand in:** nginx config, reports/after/, before/after table, and darsi-check.json that passes m3.

### m4: Detect a login attack in the logs (4 hours)

#### Why this matters
Defenders watch as well as block. A noisy rule that fires on every typo will be ignored.

#### Tools for this milestone
- **scripts/simulate-logins.py** — 40 failed logins on localhost only. Get it: in the starter
- **detect.py** — alerts when one address fails >10 times in a minute. Get it: you write it

#### Do this
1. Run: python scripts/simulate-logins.py  (refuses non-localhost).
2. Write detect.py to read nginx access logs and alert on >10 failures/minute from one address. Save alert under alerts/.
3. Optional if you have ≥8 GB RAM: send logs to single-node Wazuh. Show no alert on normal traffic. Run python check.py --milestone m4.

#### You know you're done when
- detect.py exists
- alerts/ has a file
- m4 passes

#### If something goes wrong
- **simulate-logins refused** → Pass only http://localhost:8080
- **No access log** → Mount ./logs and set access_log in nginx; generate traffic
- **Alert fires on one typo** → Raise the threshold and use a one-minute window

#### What you should understand
You can write a detection rule that fires on attacks and stays quiet on normal use.

**Hand in:** detect.py, alert output, and darsi-check.json that passes m4.

### m5: Incident runbook and a drill (3 hours)

#### Why this matters
Plans fail without practice. A parent poster in Arabic turns technical work into community defence.

#### Tools for this milestone
- **Your national CERT** — who to call for serious incidents. Get it: in Egypt, EG-CERT at https://www.egcert.eg (Egypt's national CSIRT); elsewhere, look up your country's national CERT or CSIRT

#### Do this
1. Write RUNBOOK.md: who is called, first five steps (contain, keep evidence, inform, fix, review), when to report to your national CERT (Egypt: EG-CERT).
2. Run a 15-minute tabletop drill with two people using your alert; note what to improve.
3. Add a one-page Arabic phishing poster for parents under docs/. Tag v1.0. Run python check.py --milestone m5.

#### You know you're done when
- RUNBOOK names your national CERT (Egypt: EG-CERT)
- docs/ has a poster
- m5 passes

#### If something goes wrong
- **Drill found nothing** → Ask: who has the backup phone number? Where are the logs kept?
- **Poster too technical** → Three signs of a fake school message + what to do; no jargon

#### What you should understand
You can write an incident plan people can practise, and a parent page they can read.

**Hand in:** RUNBOOK.md, drill notes, poster, green Actions, v1.0, darsi-check.json that passes m5, and your explanation.

## The check

Run `python check.py` or `python check.py --milestone m2`. It only reads files, writes `darsi-check.json`, and prints English and Arabic. It uploads nothing.

## Review on Darsi

Send your repository link and `darsi-check.json` with each milestone on Darsi. Darsi reads your latest Actions run and release from GitHub's public API, adds an advisory AI review, then your teacher or the Darsi team reviews it. **Darsi never runs your code.**

## Rules

Defence only. The only target is your own Juice Shop lab on this computer (localhost). Every port is bound to 127.0.0.1, the scan and login scripts refuse other targets, and check.py records every scan's target. Never point these tools at a school, a website or a network you don't own.

## Licence

MIT — see [LICENSE](LICENSE).
