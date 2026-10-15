function deployVisionGuard()
% DEPLOYVISIONGUARD Build a standalone desktop app with MATLAB Compiler.
% Run this in a MATLAB installation with MATLAB Compiler licensed.
% First place trained models at models/emotionNet.mat and models/maskNet.mat.
if exist('compiler.build.standaloneApplication','file')~=2
    error('MATLAB Compiler standaloneApplication builder is unavailable in this MATLAB release.');
end
root=fileparts(mfilename('fullpath'));
appFile=fullfile(root,'VisionGuardApp.m');
modelDir=fullfile(root,'models');
required={fullfile(modelDir,'emotionNet.mat'),fullfile(modelDir,'maskNet.mat')};
for k=1:numel(required)
    if ~isfile(required{k})
        error('Missing trained model file: %s. Train models first.',required{k});
    end
end
additional={fullfile(root,'loadVisionModels.m'),fullfile(root,'detectFaces.m'), ...
 fullfile(root,'preprocessFace.m'),fullfile(root,'classifyEmotion.m'), ...
 fullfile(root,'detectFaceMask.m'),fullfile(root,'processFrame.m'),modelDir};
try
    result=compiler.build.standaloneApplication(appFile,'AdditionalFiles',additional, ...
        'OutputDir',fullfile(root,'dist'));
    disp(result);
catch ME
    error('Build failed. Check MATLAB Compiler version/toolbox deployment support. Details: %s',ME.message);
end
end
