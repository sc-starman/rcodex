#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
script="$repo_root/rcodex"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

mkdir -p "$workdir/bin" "$workdir/home/.rcodex/p1" "$workdir/home/.rcodex/p2"
cat > "$workdir/bin/codex" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$CODEX_HOME" >> "$RCODEX_TEST_LOG"
exit 0
EOF
chmod +x "$workdir/bin/codex"

cat > "$workdir/home/.rcodex/p1/auth.json" <<'EOF'
{}
EOF
cat > "$workdir/home/.rcodex/p1/.rate_limit_cache" <<EOF
fetched_at=$(date +%s)
primary_used=10
primary_resets_at=0
secondary_used=10
secondary_resets_at=0
EOF

cat > "$workdir/home/.rcodex/p2/auth.json" <<'EOF'
{}
EOF
cat > "$workdir/home/.rcodex/p2/.rate_limit_cache" <<EOF
fetched_at=$(date +%s)
primary_used=20
primary_resets_at=0
secondary_used=20
secondary_resets_at=0
EOF

export HOME="$workdir/home"
export PATH="$workdir/bin:$PATH"
export RCODEX_TEST_LOG="$workdir/codex.log"

$script best >/dev/null 2>&1
best_one="$(tail -n 1 "$RCODEX_TEST_LOG" | xargs basename)"
[ "$best_one" = "p1" ] || { echo "expected p1, got $best_one" >&2; exit 1; }

$script disable p1
$script best >/dev/null 2>&1
best_one="$(tail -n 1 "$RCODEX_TEST_LOG" | xargs basename)"
[ "$best_one" = "p2" ] || { echo "expected p2 after disabling p1, got $best_one" >&2; exit 1; }

if $script p1 >/dev/null 2>&1; then
    echo "disabled profile should not launch" >&2
    exit 1
fi

$script enable p1
$script best >/dev/null 2>&1
best_one="$(tail -n 1 "$RCODEX_TEST_LOG" | xargs basename)"
[ "$best_one" = "p1" ] || { echo "expected p1 after re-enabling, got $best_one" >&2; exit 1; }

echo "profile disable tests passed"
