# Runs the ZAP baseline (passive) scan against YOUR OWN lab on this computer only. Usage: powershell -ExecutionPolicy Bypass -File scripts\zap-baseline.ps1 before|after [target]
param([ValidateSet("before","after")][string]$Phase = "before", [string]$Target = "http://localhost:8080")
$ErrorActionPreference = "Stop"
if ($Target -notmatch '^https?://(localhost|127\.\d+\.\d+\.\d+|\[::1\])(:\d+)?(/.*)?$') {
  Write-Host "Refused: only this computer (localhost) may be scanned. / مرفوض: لا يُفحص إلا هذا الكمبيوتر (localhost)."
  exit 3
}
$Out = "reports/$Phase"; New-Item -ItemType Directory -Force $Out | Out-Null
Remove-Item -Force -ErrorAction SilentlyContinue "$Out/zap.json", "$Out/scan-meta.json"
$Inside = $Target -replace '://(localhost|127\.\d+\.\d+\.\d+)', '://host.docker.internal'  # Docker Desktop reaches this computer's localhost this way
docker run --rm -v "$((Resolve-Path $Out).Path):/zap/wrk:rw" ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t $Inside -J zap.json -r zap.html  # baseline = passive
# ZAP exits 1 or 2 when it finds alerts; that's a result, not an error. No zap.json means the scan didn't run.
if (-not (Test-Path "$Out/zap.json")) {
  Write-Host "ZAP didn't write a report: is the lab running (docker compose ps)? Nothing was recorded."
  exit 1
}
[IO.File]::WriteAllText((Join-Path (Get-Location) "$Out/scan-meta.json"), (@{ tool = "zap"; target = $Target; phase = $Phase } | ConvertTo-Json -Compress))
Write-Host "Saved $Out. Now run: python check.py"
