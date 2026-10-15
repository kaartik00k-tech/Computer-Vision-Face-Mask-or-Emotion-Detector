# VisionGuard AI — Computer Vision Face Mask & Emotion Detector

VisionGuard AI is a MATLAB desktop project for real-time face detection with separate emotion and face-mask classification modes. The repository also includes a static project landing page (index.html) so the repository can be previewed on a static host.

## Important: desktop app vs website

The MATLAB webcam application is not a browser app. Deploying this repository to Vercel or GitHub Pages can serve the landing page, but it cannot execute MATLAB .m files or access the local webcam through MATLAB. To run the actual computer-vision app, use MATLAB with the required toolboxes. For a Windows executable, MATLAB Compiler and a compatible MATLAB Runtime are required.

## Source code

The MATLAB implementation and diagnostic/setup scripts are currently on the feature/visionguard-ai branch: https://github.com/kaartik00k-tech/Computer-Vision-Face-Mask-or-Emotion-Detector/tree/feature/visionguard-ai

- runVisionGuard.m — application launcher
- VisionGuardApp.m — desktop GUI and webcam controls
- detectFaces.m, preprocessFace.m, processFrame.m — computer-vision pipeline
- classifyEmotion.m, detectFaceMask.m — separate classifier interfaces
- trainVisionModels.m — starter training workflow
- checkVisionGuardSetup.m — checks MATLAB/toolbox/compiler/model/dataset setup
- deployVisionGuard.m — Windows standalone build helper
- testVisionPipeline.m — lightweight tests

## Run in MATLAB

1. Download the ZIP from the feature branch and extract it.
2. Open MATLAB and set the Current Folder to the extracted project folder.
3. Run:

   checkVisionGuardSetup
   runVisionGuard

4. Prepare labelled training images as described in the branch README, then run trainVisionModels to create the required model files.

Required toolboxes and webcam compatibility depend on your MATLAB release and hardware. The repository does not include verified pretrained weights. Classification will not be meaningful until compatible models are trained and evaluated on a separate test set.

## Deployment

- Static preview on Vercel: set the framework preset to Other, use the repository root as the Root Directory, leave the Build Command empty, and leave Output Directory empty/default. Redeploy after the GitHub commit is picked up.
- Working desktop application: run and validate it in MATLAB first, then use MATLAB Compiler on a supported Windows machine. Install the matching MATLAB Runtime on the target machine.
- Browser-based live webcam app: requires a separate browser-camera and inference architecture; the MATLAB desktop app cannot be deployed to Vercel as-is.

## Status and limitations

The source files have been added to GitHub, but the MATLAB application, trained models, webcam integration, and compiled executable have not been verified in this environment. Do not present model accuracy or deployment as tested until you have run those checks. Emotion labels are estimates of visible expressions, not reliable measurements of internal feelings; mask predictions are visual estimates, not proof of health or safety compliance.
