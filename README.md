# ltx — LTX-23 5in1 ComfyUI Workflow

A ComfyUI setup for the **LTX-23 5in1** workflow: a multi-model video generation pipeline
combining LTX-Video 2.3, Flux2 Klein, Lotus depth estimation, and audio synthesis.

---

## Hardware Requirements

| Component | Minimum |
|-----------|---------|
| GPU VRAM  | 24 GB (A10G / RTX 3090 / RTX 4090 or better) |
| System RAM | 64 GB |
| Disk / Network Volume | ~90 GB (models + outputs) |
| CUDA | 12.1+ |

---

## 🚀 RunPod (recommended)

### 1. Build and push the image to Docker Hub

```bash
# Clone this repo locally, then:
docker build -t <your-dockerhub-username>/ltx-comfyui:latest .
docker push <your-dockerhub-username>/ltx-comfyui:latest
```

### 2. Create a Network Volume

In the RunPod console go to **Storage → Network Volumes → New Volume**.

- **Size:** 100 GB minimum
- **Data center:** pick the same region you'll use for the pod
- **Name:** e.g. `ltx-models`

### 3. Create a RunPod Template

Go to **My Templates → New Template** and fill in:

| Field | Value |
|-------|-------|
| Template name | `LTX-23 5in1` |
| Container image | `<your-dockerhub-username>/ltx-comfyui:latest` |
| Container disk | 20 GB |
| Volume mount path | `/workspace` |
| Expose HTTP ports | `8188` |
| Environment variable | `DOWNLOAD_MODELS=0` (set to `1` to auto-download on first boot) |
| Environment variable | `HF_TOKEN=<your token>` (required if DOWNLOAD_MODELS=1 for gated models) |

### 4. Deploy a Pod

Go to **Pods → Deploy** and select:

- **GPU:** A40 / A100 / H100 (≥ 48 GB VRAM recommended; 24 GB minimum)
- **Template:** `LTX-23 5in1`
- **Network Volume:** `ltx-models` (mounted at `/workspace`)

Click **Deploy On-Demand**.

### 5. Download models (first time only)

Once the pod is running, open a **Terminal** tab and run:

```bash
# If HF_TOKEN is not set as an env var, export it first:
export HF_TOKEN=your_huggingface_token

bash /app/download_models.sh /workspace/models
```

This downloads all ~76 GB of models to the persistent network volume.
Subsequent pod restarts will skip already-downloaded files.

Alternatively set `DOWNLOAD_MODELS=1` in the template to download automatically on every pod start
(skips files that already exist, so subsequent boots are fast).

### 6. Open ComfyUI

Click **Connect → HTTP Service [8188]** in the RunPod pod list.
The workflow **LTX-23 5in1.JSON** is pre-loaded under *Workflows → user/default*.

---

## 🐳 Local Docker (alternative)

### 1. Download models

See [`models.txt`](models.txt) for the full list. Place every file under `./models/` using
the sub-folder shown (e.g. `./models/unet/`, `./models/vae/`).

```
models/
├── unet/     ← transformer models
├── vae/      ← VAE models
├── clip/     ← text encoders
├── loras/    ← LoRA files
└── checkpoints/ ← Lotus depth model
```

### 2. Build and run

```bash
docker compose up --build
```

ComfyUI will be available at **http://localhost:8188**.

### 3. Load the workflow

Click the folder icon → **Load** and select **LTX-23 5in1.JSON**,
or find it under *Workflows → user/default*.

---

## 💻 Bare Metal

```bash
chmod +x install.sh
./install.sh
```

Then download models per [`models.txt`](models.txt) into `~/ComfyUI/models/`, and:

```bash
cd ~/ComfyUI
python main.py --listen
```

---

## Custom nodes

| Package | Repository |
|---------|-----------|
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

## Files

| File | Purpose |
|------|---------|
| `LTX-23 5in1.JSON` | ComfyUI workflow |
| `start.sh` | Container entrypoint (handles RunPod volume + launches ComfyUI) |
| `download_models.sh` | Downloads all models to a target directory |
| `Dockerfile` | Container image (custom nodes baked in) |
| `docker-compose.yml` | Local Docker Compose setup |
| `install.sh` | Bare-metal setup script |
| `models.txt` | Annotated model list with HuggingFace URLs |
