# ltx — LTX-23 5in1 ComfyUI Workflow

A ComfyUI setup for the **LTX-23 5in1** workflow: a multi-model video generation pipeline
combining LTX-Video 2.3, Flux2 Klein, Lotus depth estimation, and audio synthesis.

---

## Requirements

| Component | Minimum |
|-----------|---------|
| GPU VRAM  | 24 GB (A10G / RTX 3090 / RTX 4090) |
| System RAM | 64 GB |
| Disk space | ~90 GB (models + outputs) |
| CUDA | 12.1+ |
| Python | 3.11 |

---

## Quick Start (Docker — recommended)

### 1. Download models

See [`models.txt`](models.txt) for the full list. Place every downloaded file in the
`./models/` sub-directory **using the folder structure shown** (e.g. `./models/unet/`, `./models/vae/`).

```
models/
├── unet/
│   ├── ltx-2.3-22b-dev_transformer_only_fp8_scaled.safetensors
│   ├── ltx-2.3_text_projection_bf16.safetensors
│   └── flux-2-klein-9b-fp8.safetensors
├── vae/
│   ├── LTX23_video_vae_bf16.safetensors
│   ├── LTX23_audio_vae_bf16.safetensors
│   ├── flux2-vae.safetensors
│   └── vae-ft-mse-840000-ema-pruned.safetensors
├── clip/
│   ├── gemma_3_12B_it.safetensors
│   └── qwen_3_8b_fp8mixed.safetensors
├── loras/
│   ├── ltx-2.3-22b-distilled-lora-384.safetensors
│   └── ltx-2.3-22b-ic-lora-union-control-ref0.5.safetensors
└── checkpoints/
    └── lotus-depth-g-v2-0.safetensors
```

### 2. Build and run

```bash
docker compose up --build
```

ComfyUI will be available at **http://localhost:8188**.

### 3. Load the workflow

1. Open http://localhost:8188 in your browser.
2. Click the folder icon (Load) and select **LTX-23 5in1.JSON**,
   or find it under **Workflows → user/default**.

---

## Quick Start (bare metal / virtual environment)

### 1. Clone and set up

```bash
chmod +x install.sh
./install.sh
```

The script will:
- Clone ComfyUI into `~/ComfyUI`
- Install all 14 required custom node packages
- Copy the workflow into `~/ComfyUI/user/default/workflows/`

### 2. Download models

Follow the instructions in [`models.txt`](models.txt) and place files in the matching
sub-directories under `~/ComfyUI/models/`.

### 3. Run ComfyUI

```bash
cd ~/ComfyUI
python main.py --listen
```

Open **http://localhost:8188** and load **LTX-23 5in1.JSON**.

---

## Custom nodes installed

| Package | Repository |
|---------|----------|
| ComfyUI-LTXVideo | https://github.com/Lightricks/ComfyUI-LTXVideo |
| ComfyUI-Lotus | https://github.com/logtd/ComfyUI-Lotus |
| ComfyUI-KJNodes | https://github.com/kijai/ComfyUI-KJNodes |
| ComfyUI-VideoHelperSuite | https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite |
| comfyui_controlnet_aux | https://github.com/Fannovel16/comfyui_controlnet_aux |
| ComfyUI_essentials | https://github.com/cubiq/ComfyUI_essentials |
| ComfyUI_LayerStyle | https://github.com/chflame163/ComfyUI_LayerStyle |
| rgthree-comfy | https://github.com/rgthree/rgthree-comfy |
| ComfyUI-Easy-Use | https://github.com/yolain/ComfyUI-Easy-Use |
| ComfyUI-Custom-Scripts | https://github.com/pythongosssss/ComfyUI-Custom-Scripts |
| ComfyUI-Image-Selector | https://github.com/SLAPaper/ComfyUI-Image-Selector |
| comfyui-styles_csv_loader | https://github.com/MNeMoNiCuZ/comfyui-styles_csv_loader |
| ComfyMath | https://github.com/evanspearman/ComfyMath |
| was-node-suite-comfyui | https://github.com/WASasquatch/was-node-suite-comfyui |

---

## Files in this repository

| File | Purpose |
|------|---------|
| `LTX-23 5in1.JSON` | ComfyUI workflow |
| `install.sh` | Bare-metal setup script |
| `Dockerfile` | Container image definition |
| `docker-compose.yml` | Docker Compose service |
| `models.txt` | Model download list with paths |
