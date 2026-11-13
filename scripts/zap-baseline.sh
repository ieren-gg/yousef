#!/usr/bin/env bash
# Runs the ZAP baseline (passive) scan against YOUR OWN lab on this computer only. Usage: bash scripts/zap-baseline.sh before|after [target]
set -euo pipefail
PHASE="${1:-before}"
TARGET="${2:-http://localhost:8080}"
case "$PHASE" in before|after) ;; *) echo "Phase must be before or after / المرحلة before أو after"; exit 2;; esac
if ! [[ "$TARGET" =~ ^https?://(localhost|127\.[0-9]+\.[0-9]+\.[0-9]+|\[::1\])(:[0-9]+)?(/.*)?$ ]]; then
  echo "Refused: only this computer (localhost) may be scanned. / مرفوض: لا يُفحص إلا هذا الكمبيوتر (localhost)."
  exit 3
fi
OUT="reports/$PHASE"; mkdir -p "$OUT"
rm -f "$OUT/zap.json" "$OUT/scan-meta.json"
INSIDE="$TARGET"; NET="--network=host"
if [ "$(uname -s)" = "Darwin" ]; then  # Docker Desktop on a Mac reaches this computer's localhost as host.docker.internal
  INSIDE=$(printf '%s' "$TARGET" | sed -E 's#://(localhost|127\.[0-9]+\.[0-9]+\.[0-9]+)#://host.docker.internal#'); NET=""
fi
# ZAP exits 1 or 2 when it finds alerts; that's a result, not an error. No zap.json means the scan didn't run.
# ${NET:+"$NET"} adds nothing when NET is empty (an empty array would stop the Mac's bash 3.2 under set -u).
docker run --rm ${NET:+"$NET"} -v "$PWD/$OUT:/zap/wrk:rw" ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t "$INSIDE" -J zap.json -r zap.html || true  # baseline = passive
if [ ! -f "$OUT/zap.json" ]; then
  echo "ZAP didn't write a report: is the lab running (docker compose ps)? Nothing was recorded."
  exit 1
fi
printf '{"tool":"zap","target":"%s","phase":"%s"}\n' "$TARGET" "$PHASE" > "$OUT/scan-meta.json"
echo "Saved $OUT. Now run: python check.py"
