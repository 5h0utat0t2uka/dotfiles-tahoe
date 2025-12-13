#!/usr/bin/env bash
# ~/.config/tmux/bin/pane-git-branch.sh

dir="$1"

# pane のカレントディレクトリへ
cd "$dir" 2>/dev/null || exit 0

# Git リポジトリでなければ何も出さない
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# ブランチ名を取得
branch=$(git branch --show-current 2>/dev/null)

# detached HEAD などでブランチ名が取れない場合はショートハッシュ
if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
  branch=$(git rev-parse --short HEAD 2>/dev/null || echo "")
fi

# それでも取れないなら何も出さない
[ -z "$branch" ] && exit 0

# 大文字化
upper_branch=$(printf '%s' "$branch" | tr '[:lower:]' '[:upper:]')

# tmux スタイル込みで出力（色は後で tmux 側で解釈される）
printf '#[fg=$nord9]%s#[default]' "$upper_branch "
