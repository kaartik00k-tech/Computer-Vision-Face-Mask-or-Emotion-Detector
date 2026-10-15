function runVisionGuard()
% RUNVISIONGUARD Launch VisionGuard after adding the project to the path.
root=fileparts(mfilename('fullpath'));
addpath(genpath(root));
VisionGuardApp();
end
