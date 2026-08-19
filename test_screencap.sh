#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir "$TMP/bin"

cat >"$TMP/bin/adb" <<'SH'
#!/bin/bash
set -euo pipefail

if [[ "${1:-}" == "devices" ]]; then
    printf 'List of devices attached\nabc\tdevice\n'
    exit 0
fi

if [[ "${1:-}" == "-s" ]]; then
    shift 2
fi

case "${1:-} ${2:-}" in
    "shell screencap")
        printf '%s\n' "$4" >"$TEST_REMOTE"
        ;;
    "pull /sdcard/"*)
        printf '\211PNG\r\n\032\n' >"$(basename "$2")"
        ;;
    "shell rm")
        printf '%s\n' "$4" >>"$TEST_REMOTE_RM"
        ;;
esac
SH
chmod +x "$TMP/bin/adb"

cat >"$TMP/bin/osascript" <<'SH'
#!/bin/bash
exit 0
SH
chmod +x "$TMP/bin/osascript"

run_case() {
    local args="$1"
    local name="$2"

    HOME="$TMP/home" PATH="$TMP/bin:$PATH" TEST_REMOTE="$TMP/remote" TEST_REMOTE_RM="$TMP/remote_rm" \
        bash "$ROOT/screencap.sh" $args <<<"1
$name
" >/dev/null
}

mkdir -p "$TMP/home"
: >"$TMP/remote_rm"
run_case "" "delete_me"
test ! -e "$TMP/home/screen_from_phone/delete_me.png"
grep -qx '/sdcard/delete_me.png' "$TMP/remote_rm"

: >"$TMP/remote_rm"
run_case "--keep" "keep_me"
test -e "$TMP/home/screen_from_phone/keep_me.png"
test ! -s "$TMP/remote_rm"
