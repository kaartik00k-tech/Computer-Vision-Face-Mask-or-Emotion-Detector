# Computer Vision Face Mask or Emotion Detector (MATLAB Starter)

This repository now includes a small MATLAB starter project for exploring face-mask and emotion detection workflows in MATLAB. It is intentionally simple and designed to work as a starting point for building a more advanced detector or integrating with a pretrained model.

## What is included

- `face_mask_emotion_detector.m` — loads images from a `data/` folder, detects faces, estimates whether the face appears to be wearing a mask, and gives a rough emotion label.
- `check_matlab_environment.m` — checks whether the required MATLAB toolboxes are installed and whether MATLAB Compiler is available.
- `data/.gitkeep` — placeholder folder for sample images.

## Requirements

- MATLAB R2022a or newer
- Image Processing Toolbox
- Computer Vision Toolbox
- Optional: Deep Learning Toolbox if you later upgrade this demo to use a pretrained CNN
- Optional: MATLAB Compiler / Compiler SDK if you want to package a standalone app or executable

## How to run

1. Open MATLAB in the repository folder.
2. Add images to `data/` (for example `.jpg`, `.png`, or `.bmp`).
3. Run:

```matlab
run('face_mask_emotion_detector.m')
```

4. The script will:
   - detect faces using `vision.CascadeObjectDetector`
   - compute a simple mask/no-mask heuristic from the lower face region
   - estimate a coarse emotion label based on relative face-region contrast
   - print results to the command window

## Check MATLAB and Compiler availability

```matlab
run('check_matlab_environment.m')
```

This script reports:
- which required toolboxes are installed
- whether MATLAB Compiler is present in the installed product list
- whether `mcc` is available on the system PATH

## Notes

This is a starter implementation, not a production-ready medical or security model. It is useful as a MATLAB educational/demo pipeline and as a base for adding a stronger CNN or a trained custom classifier later.

## Example folder layout

```text
Computer-Vision-Face-Mask-or-Emotion-Detector/
├── README.md
├── check_matlab_environment.m
├── face_mask_emotion_detector.m
├── data/
│   ├── .gitkeep
│   └── your_test_images_here.jpg
└── LICENSE
```
