#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-check}"

SOURCE_GUARDRAILS="$ROOT_DIR/guardrails.md"
SOURCE_INSTRUCTIONS="$ROOT_DIR/.github/copilot-instructions.project-template.md"
SOURCE_CHILD_HOOK="$ROOT_DIR/.github/hooks/pre-commit.child"

if [[ ! -f "$SOURCE_GUARDRAILS" ]]; then
    echo "Missing source guardrails: $SOURCE_GUARDRAILS" >&2
    exit 1
fi

if [[ ! -f "$SOURCE_INSTRUCTIONS" ]]; then
    echo "Missing source instructions template: $SOURCE_INSTRUCTIONS" >&2
    exit 1
fi

if [[ ! -f "$SOURCE_CHILD_HOOK" ]]; then
    echo "Missing source child hook template: $SOURCE_CHILD_HOOK" >&2
    exit 1
fi

mapfile -t REPOS < <(find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d -exec test -d "{}/.git" \; -print | sort)

if [[ ${#REPOS[@]} -eq 0 ]]; then
    echo "No child repositories found under $ROOT_DIR"
    exit 0
fi

drift=0

sync_repo() {
    local repo="$1"
    local target_dir="$repo/.github"
    mkdir -p "$target_dir"
    cp --remove-destination "$SOURCE_GUARDRAILS" "$target_dir/guardrails.md"
    cp --remove-destination "$SOURCE_INSTRUCTIONS" "$target_dir/copilot-instructions.md"
    install -m 755 "$SOURCE_CHILD_HOOK" "$repo/.git/hooks/pre-commit"
    echo "SYNCED: $repo"
}

check_repo() {
    local repo="$1"
    local target_guardrails="$repo/.github/guardrails.md"
    local target_instructions="$repo/.github/copilot-instructions.md"
    local target_hook="$repo/.git/hooks/pre-commit"
    local repo_drift=0

    if [[ ! -f "$target_guardrails" ]]; then
        echo "MISSING guardrails: $repo/.github/guardrails.md"
        repo_drift=1
    elif ! cmp -s "$SOURCE_GUARDRAILS" "$target_guardrails"; then
        echo "DRIFT guardrails: $repo/.github/guardrails.md"
        repo_drift=1
    fi

    if [[ ! -f "$target_instructions" ]]; then
        echo "MISSING instructions: $repo/.github/copilot-instructions.md"
        repo_drift=1
    elif ! cmp -s "$SOURCE_INSTRUCTIONS" "$target_instructions"; then
        echo "DRIFT instructions: $repo/.github/copilot-instructions.md"
        repo_drift=1
    fi

    if [[ ! -f "$target_hook" ]]; then
        echo "MISSING hook: $repo/.git/hooks/pre-commit"
        repo_drift=1
    elif ! cmp -s "$SOURCE_CHILD_HOOK" "$target_hook"; then
        echo "DRIFT hook: $repo/.git/hooks/pre-commit"
        repo_drift=1
    fi

    if [[ "$repo_drift" -eq 0 ]]; then
        echo "OK: $repo"
    else
        drift=1
    fi
}

case "$MODE" in
    sync)
        for repo in "${REPOS[@]}"; do
            sync_repo "$repo"
        done
        ;;
    check)
        for repo in "${REPOS[@]}"; do
            check_repo "$repo"
        done
        if [[ "$drift" -ne 0 ]]; then
            exit 2
        fi
        ;;
    *)
        echo "Usage: $0 [check|sync]" >&2
        exit 1
        ;;
esac
