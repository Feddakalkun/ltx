#!/usr/bin/env bash
# start.sh — Pod entrypoint for RunPod (also works with plain docker run)
set -euo pipefail

COMFYUI_DIR="/app/ComfyUI"
WORKFLOW_SRC="/app/workflows/LTX-23_5in1.JSON"

# RunPod mounts network volumes at /workspace by default.
# Fall back to /runpod-volume if that is what was configured.
if   [ -d "/workspace" ];      then VOLUME_DIR="/workspace"
elif [ -d "/runpod-volume" ];  then VOLUME_DIR="/runpod-volume"
else                                VOLUME_DIR=""
fi

if [ -n "$VOLUME_DIR" ]; then
  echo "==> Network volume detected at $VOLUME_DIR"

  # ── Models ──────────────────────────────────────────────────────────────
  mkdir -p "$VOLUME_DIR/models"
  if [ ! -L "$COMFYUI_DIR/models" ]; then
    rm -rf "$COMFYUI_DIR/models"
    ln -s "$VOLUME_DIR/models" "$COMFYUI_DIR/models"
    echo "    Linked $COMFYUI_DIR/models → $VOLUME_DIR/models"
  fi

  # ── Outputs ─────────────────────────────────────────────────────────────
  mkdir -p "$VOLUME_DIR/output"
  if [ ! -L "$COMFYUI_DIR/output" ]; then
    rm -rf "$COMFYUI_DIR/output"
    ln -s "$VOLUME_DIR/output" "$COMFYUI_DIR/output"
    echo "    Linked $COMFYUI_DIR/output → $VOLUME_DIR/output"
  fi

  # ── Inputs (uploaded images/videos) ─────────────────────────────────────
  mkdir -p "$VOLUME_DIR/input"
  if [ ! -L "$COMFYUI_DIR/input" ]; then
    rm -rf "$COMFYUI_DIR/input"
    ln -s "$VOLUME_DIR/input" "$COMFYUI_DIR/input"
    echo "    Linked $COMFYUI_DIR/input  → $VOLUME_DIR/input"
  fi

  # ── Run model downloader if requested ────────────────────────────────────
  if [ "${DOWNLOAD_MODELS:-0}" = "1" ]; then
    echo "==> DOWNLOAD_MODELS=1 — downloading models to $VOLUME_DIR/models"
    bash /app/download_models.sh "$VOLUME_DIR/models"
  fi
else
  echo "==> No network volume found; using container-local directories"
fi

# ── Copy workflow into user default workflows ────────────────────────────
WORKFLOW_DEST="$COMFYUI_DIR/user/default/workflows"
mkdir -p "$WORKFLOW_DEST"
if [ -f "$WORKFLOW_SRC" ] && [ ! -f "$WORKFLOW_DEST/$(basename "$WORKFLOW_SRC")" ]; then
  cp "$WORKFLOW_SRC" "$WORKFLOW_DEST/"
  echo "==> Workflow copied to $WORKFLOW_DEST"
fi

echo "==> Starting ComfyUI on 0.0.0.0:8188"
cd "$COMFYUI_DIR"
exec python main.py --listen 0.0.0.0 --port 8188
