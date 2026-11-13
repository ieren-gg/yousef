"""Milestone 4: 40 failed logins in 60 seconds plus normal traffic, against YOUR OWN lab on localhost only."""
import json
import sys
import time
import urllib.error
import urllib.request
from urllib.parse import urlparse

TARGET = (sys.argv[1] if len(sys.argv) > 1 else "http://localhost:8080").rstrip("/")
url = urlparse(TARGET)
# Compare the host itself: a prefix test would let http://localhost.example.com through.
if url.scheme not in ("http", "https") or url.hostname not in {"localhost", "127.0.0.1", "::1"}:
    sys.exit("Refused: only your own lab on localhost. / مرفوض: مختبرك على localhost فقط.")


def post(email, pw):
    req = urllib.request.Request(TARGET + "/rest/user/login", json.dumps({"email": email, "password": pw}).encode(), {"Content-Type": "application/json"})
    try:
        urllib.request.urlopen(req, timeout=5)
    except urllib.error.HTTPError:
        pass


for i in range(40):
    post("student@example.test", f"wrong-{i}")
    if i % 8 == 0:
        urllib.request.urlopen(TARGET + "/", timeout=5)
    time.sleep(1.5)
print("Done. Now run detect.py on logs/access.log")
