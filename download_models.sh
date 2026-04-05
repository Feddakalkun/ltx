#!/usr/bin/env bash
# download_models.sh — Download all models required by LTX-23 5in1.JSON
#
# Usage:
#   bash download_models.sh [TARGET_DIR]
#
# TARGET_DIR defaults to /workspace/models (RunPod network volume).
# Requires: huggingface_hub Python package  →  pip install huggingface_hub
#
# For gated models (Gemma 3) you must first run:
#   huggingface-cli login
# or set the HF_TOKEN environment variable.

set -euo pipefail

TARGET="${1:-/workspace/models}"
echo "==> Downloading models to $TARGET"

hf_download() {
  # hf_download <repo_id> <filename> <local_subdir>
  local repo="$1"
  local file="$2"
  local subdir="$3"
  local dest="$TARGET/$subdir/$file"

  if [ -f "$dest" ]; then
    echo "    [skip] $file (already exists)"
    return
  fi

  mkdir -p "$TARGET/$subdir"
  echo "    Downloading $file from $repo ..."
  python3 -c "
from huggingface_hub import hf_hub_download
import os, shutil
token = os.environ.get('HF_TOKEN')
path = hf_hub_download(
    repo_id='$repo',
    filename='$file',
    token=token,
)
shutil.copy(path, '$dest')
print('    Saved to $dest')
"
}

# ── LTX Video 2.3 ────────────────────────────────────────────────────────
hf_download "Lightricks/LTX-Video" "ltx-2.3-22b-dev_transformer_only_fp8_scaled.safetensors" "unet"
hf_download "Lightricks/LTX-Video" "ltx-2.3_text_projection_bf16.safetensors"                "unet"
hf_download "Lightricks/LTX-Video" "ltx-2.3-22b-distilled-lora-384.safetensors"              "loras"
hf_download "Lightricks/LTX-Video" "ltx-2.3-22b-ic-lora-union-control-ref0.5.safetensors"   "loras"
hf_download "Lightricks/LTX-Video" "LTX23_video_vae_bf16.safetensors"                        "vae"
hf_download "Lightricks/LTX-Video" "LTX23_audio_vae_bf16.safetensors"                        "vae"

# ── Flux2 Klein ──────────────────────────────────────────────────────────
hf_download "Lightricks/flux-2-klein" "flux-2-klein-9b-fp8.safetensors" "unet"
hf_download "Lightricks/flux-2-klein" "flux2-vae.safetensors"           "vae"

# ── Text encoders ─────────────────────────────────────────────────────────
# Gemma 3 12B requires accepting the licence on https://huggingface.co/Lightricks/LTX-Video
hf_download "Lightricks/LTX-Video" "gemma_3_12B_it.safetensors"    "clip"
hf_download "Lightricks/LTX-Video" "qwen_3_8b_fp8mixed.safetensors" "clip"

# ── Lotus depth estimation ────────────────────────────────────────────────
hf_download "haodongli/Lotus" "lotus-depth-g-v2-0.safetensors" "checkpoints"

# ── Standard SD VAE ───────────────────────────────────────────────────────
hf_download "stabilityai/sd-vae-ft-mse-original" "vae-ft-mse-840000-ema-pruned.safetensors" "vae"

echo ""
echo "==> All models downloaded to $TARGET"
echo "    DWPose (dw-ll_ucoco_384_bs5.torchscript.pt and yolox_l.onnx) will be"
echo "    downloaded automatically by comfyui_controlnet_aux on first use."
