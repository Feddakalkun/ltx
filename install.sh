#!/usr/bin/env bash
# install.sh — Set up ComfyUI with all custom nodes required by LTX-23 5in1.JSON
set -euo pipefail

COMFYUI_DIR="${COMFYUI_DIR:-$HOME/ComfyUI}"
CUSTOM_NODES_DIR="$COMFYUI_DIR/custom_nodes"
WORKFLOW_FILE="LTX-23 5in1.JSON"

echo "==> Installing ComfyUI to $COMFYUI_DIR"
if [ ! -d "$COMFYUI_DIR" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFYUI_DIR"
else
  echo "    ComfyUI directory already exists, pulling latest..."
  git -C "$COMFYUI_DIR" pull
fi

echo "==> Installing ComfyUI Python dependencies"
pip install -r "$COMFYUI_DIR/requirements.txt"

mkdir -p "$CUSTOM_NODES_DIR"
cd "$CUSTOM_NODES_DIR"

install_node() {
  local name="$1"
  local url="$2"
  if [ ! -d "$name" ]; then
    echo "==> Cloning $name"
    git clone "$url" "$name"
  else
    echo "    $name already present, pulling latest..."
    git -C "$name" pull
  fi
  if [ -f "$name/requirements.txt" ]; then
    pip install -r "$name/requirements.txt"
  fi
}

# Core workflow dependencies
install_node "ComfyUI-LTXVideo"            "https://github.com/Lightricks/ComfyUI-LTXVideo.git"
install_node "ComfyUI-Lotus"               "https://github.com/logtd/ComfyUI-Lotus.git"
install_node "comfyui-kjnodes"             "https://github.com/kijai/ComfyUI-KJNodes.git"
install_node "comfyui-videohelpersuite"    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git"
install_node "comfyui_controlnet_aux"      "https://github.com/Fannovel16/comfyui_controlnet_aux.git"
install_node "comfyui_essentials"          "https://github.com/cubiq/ComfyUI_essentials.git"
install_node "comfyui_layerstyle"          "https://github.com/chflame163/ComfyUI_LayerStyle.git"
install_node "rgthree-comfy"               "https://github.com/rgthree/rgthree-comfy.git"
install_node "comfyui-easy-use"            "https://github.com/yolain/ComfyUI-Easy-Use.git"
install_node "comfyui-custom-scripts"      "https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git"
install_node "comfyui-image-selector"      "https://github.com/SLAPaper/ComfyUI-Image-Selector.git"
install_node "comfyui-styles_csv_loader"   "https://github.com/MNeMoNiCuZ/comfyui-styles_csv_loader.git"
install_node "comfymath"                   "https://github.com/evanspearman/ComfyMath.git"
install_node "was-node-suite-comfyui"      "https://github.com/WASasquatch/was-node-suite-comfyui.git"

echo ""
echo "==> Copying workflow into ComfyUI"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
mkdir -p "$COMFYUI_DIR/user/default/workflows"
cp "$SCRIPT_DIR/$WORKFLOW_FILE" "$COMFYUI_DIR/user/default/workflows/"

echo ""
echo "==> Done! Next steps:"
echo "    1. Download the required models — see models.txt"
echo "    2. Start ComfyUI:  cd $COMFYUI_DIR && python main.py --listen"
echo "    3. Open http://localhost:8188 and load the workflow 'LTX-23 5in1.JSON'"
