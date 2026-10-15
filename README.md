# VisionGuard AI — MATLAB Face Mask & Emotion Detector

A MATLAB desktop application for live webcam face detection, emotion classification (Happy/Sad/Neutral), and face-mask classification (Mask/No Mask). Frames are processed locally. This repository includes source code and a basic CNN training workflow; it does **not** include pretrained weights or guarantee classification accuracy.

## Requirements
- MATLAB with Computer Vision Toolbox and Deep Learning Toolbox
- Image Processing Toolbox for image resizing/preprocessing and training workflow
- Supported webcam interface/adaptor (camera support varies by OS/release)
- MATLAB Compiler only if building a standalone desktop app

## 1. Download and open
Clone/download this repository. In MATLAB, set the current folder to the repository root and run:

```matlab
addpath(genpath(pwd))
runVisionGuard
```

The live face detector can run without classifier weights. If a selected model is missing, the UI tells you which file is needed instead of inventing predictions.

## 2. Prepare training images
Place appropriately licensed and correctly labelled images in the following folder layout. Prefer face-cropped images that resemble the webcam face crops used by the app.

```text
dataset/
  emotion/
    Happy/
    Sad/
    Neutral/
  mask/
    Mask/
    No Mask/
```

Use diverse examples, ensure each class has enough images, and keep a separate subject-disjoint test set. Do not commit private or sensitive images. Check dataset license, consent, and permitted use. The included small CNN is a starter baseline, not a production-quality model; performance is not guaranteed.

## 3. Train both models
Run from MATLAB:

```matlab
trainVisionModels
```

Or provide custom folders:

```matlab
trainVisionModels('C:/path/to/dataset','C:/path/to/output/models')
```

The script saves `models/emotionNet.mat` with variable `emotionNet` and `models/maskNet.mat` with variable `maskNet`. Evaluate on a separate held-out test set before relying on predictions. The script's internal validation split is only a development check, not final evaluation. Keep preprocessing and labels consistent with training.

## 4. Run the app
Run:

```matlab
runVisionGuard
```

Select Emotion Detection or Face Mask Detection, choose a confidence threshold, then click **Start Camera**. Use Stop Camera to release the device and Capture Snapshot to save a still image. If MATLAB cannot find the webcam, verify camera permissions, adaptor installation, and that another application is not using it.

## 5. Test
Run the lightweight helper tests:

```matlab
results = runtests('testVisionPipeline.m');
table(results)
```

These tests do not measure model accuracy and do not replace live webcam testing. This project has not been executed on all supported MATLAB releases or camera hardware; verify locally before deployment.

## 6. Build a standalone desktop application
After both trained model files exist and the app works in MATLAB, run:

```matlab
deployVisionGuard
```

This invokes the MATLAB Compiler standalone application builder if supported by your installed release. You need an appropriate MATLAB Compiler license. Confirm toolbox deployment support, package model files, install the matching MATLAB Runtime on target machines, and test the packaged app with the target webcam. Build APIs and toolbox redistribution rights can vary by MATLAB release and license.

This is a **MATLAB desktop project**, not a static website. Vercel/Netlify cannot run MATLAB desktop code as a browser app. Browser or mobile deployment requires a separate web/mobile camera and inference architecture.

## Limitations and responsible use
- Emotion labels estimate visible facial expression and do not reliably reveal a person's internal emotional state.
- Mask predictions are visual estimates, not medical advice or proof of workplace safety compliance.
- Lighting, pose, occlusion, camera quality, and training data bias can reduce performance.
- Do not use unvalidated predictions for consequential decisions. Camera frames are not uploaded; snapshots are saved only when explicitly requested.
