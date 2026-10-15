# VisionGuard AI — MATLAB Face Mask & Emotion Detector

This is a MATLAB desktop computer-vision project for live face detection with separate emotion and face-mask classification modes.

## Important status
The repository initially contained only a LICENSE file. Model weights, a working app, and tests were not present. The project must not claim real emotion or mask predictions until compatible trained models are supplied and validated.

## Requirements
- MATLAB
- Computer Vision Toolbox
- Deep Learning Toolbox
- Supported webcam interface/adaptor; webcam availability varies by OS and MATLAB release
- MATLAB Compiler only if packaging a standalone desktop app

## Model requirements
Emotion model must be trained or validated for Happy, Sad, and Neutral. Mask model must be trained or validated for Mask and No Mask. A generic image classifier or face detector is not a substitute. Keep the two models separate. Store compatible MAT files under models/emotionNet.mat and models/maskNet.mat, with variables named emotionNet and maskNet respectively. Ensure preprocessing and class labels match the model's training configuration.

## Development and verification checklist
1. Inspect MATLAB release and installed products with ver.
2. Confirm camera support and enumerate cameras using webcamlist where supported.
3. Implement the live camera loop and face detection.
4. Integrate separately trained classifiers and confidence-based uncertainty handling.
5. Test missing models, invalid frames, multiple faces, and camera cleanup.
6. Run on the target machine with a real webcam.
7. Package only after confirming MATLAB Compiler/toolbox compatibility; install matching MATLAB Runtime on target machines.

No model weights, hardware test results, or successful deployment are claimed by this initial documentation. Emotion predictions are estimates of visible expression, not measurements of internal emotional state. Mask predictions are visual classifications, not proof of health or safety compliance. Camera frames should remain local unless a user explicitly chooses otherwise.
