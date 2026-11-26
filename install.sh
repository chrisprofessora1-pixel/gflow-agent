#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Gflow: instalando o agente e a pasta de saída."

if ! command -v gflow >/dev/null 2>&1; then
  echo "Erro: o CLI gflow não está instalado."
  echo "Instale primeiro com: uv tool install gflow-cli"
  exit 1
fi

# Pasta de Downloads da pessoa. No Linux, respeita o XDG.
if command -v xdg-user-dir >/dev/null 2>&1; then
  DOWNLOADS="$(xdg-user-dir DOWNLOAD)"
else
  DOWNLOADS="$HOME/Downloads"
fi

if [ -z "$DOWNLOADS" ] || [ "$DOWNLOADS" = "$HOME" ]; then
  DOWNLOADS="$HOME/Downloads"
fi

OUT_DIR="$DOWNLOADS/Flow"
mkdir -p "$OUT_DIR/images" "$OUT_DIR/videos" "$OUT_DIR/audio" "$OUT_DIR/legendas" "$OUT_DIR/montagens"

# Pasta de configuração do gflow, igual à que o CLI usa.
case "$(uname -s)" in
  Darwin)
    GFLOW_HOME="$HOME/Library/Application Support/gflow-cli"
    ;;
  Linux)
    GFLOW_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/gflow-cli"
    ;;
  *)
    echo "Erro: este instalador funciona no macOS e no Linux."
    echo "No Windows, siga o passo a passo manual do README."
    exit 1
    ;;
esac

mkdir -p "$GFLOW_HOME"
ENV_FILE="$GFLOW_HOME/.env"
touch "$ENV_FILE"

TMP_FILE="$(mktemp)"
awk -v value="$OUT_DIR" '
  BEGIN { done = 0 }
  /^GFLOW_CLI_OUTPUT_DIR=/ {
    print "GFLOW_CLI_OUTPUT_DIR=\"" value "\""
    done = 1
    next
  }
  { print }
  END {
    if (!done) print "GFLOW_CLI_OUTPUT_DIR=\"" value "\""
  }
' "$ENV_FILE" > "$TMP_FILE"
mv "$TMP_FILE" "$ENV_FILE"

# Instala o agente no OpenCode. Se já existir, guarda backup.
AGENT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents"
mkdir -p "$AGENT_DIR"
AGENT_FILE="$AGENT_DIR/gflow.md"

if [ -f "$AGENT_FILE" ]; then
  BACKUP="$AGENT_FILE.bak.$(date +%Y%m%d%H%M%S)"
  cp "$AGENT_FILE" "$BACKUP"
  echo "Agente antigo guardado em: $BACKUP"
fi

cp "$REPO_DIR/opencode/agents/gflow.md" "$AGENT_FILE"

echo
echo "Pronto."
echo "Agente instalado em: $AGENT_FILE"
echo "Saída configurada em: $OUT_DIR"
echo
echo "Agora faça o login uma vez, no terminal:"
echo "  gflow auth login --browser chrome"
echo
echo "Depois abra o OpenCode e digite: gflow"
