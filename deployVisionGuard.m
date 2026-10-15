function deployVisionGuard()
% DEPLOYVISIONGUARD Build VisionGuard AI as a Windows GUI executable.
% Requires Windows, MATLAB Compiler, and validated model files.
if ~ispc
    error('Build the Windows .exe on a Windows computer.');
end
if exist('compiler.build.standaloneWindowsApplication','file')~=2
    error(['MATLAB Compiler Windows application builder is unavailable. ' ...
        'Install/activate MATLAB Compiler or use the Standalone Application Compiler app.']);
end
root=fileparts(mfilename('fullpath'));
appFile=fullfile(root,'VisionGuardApp.m');
modelDir=fullfile(root,'models');
modelFiles={fullfile(modelDir,'emotionNet.mat'),fullfile(modelDir,'maskNet.mat')};
for k=1:numel(modelFiles)
    if ~isfile(modelFiles{k})
        error('Missing trained model: %s. Run trainVisionModels first.',modelFiles{k});
    end
end
sourceFiles={ ...
 fullfile(root,'loadVisionModels.m'), ...
 fullfile(root,'detectFaces.m'), ...
 fullfile(root,'preprocessFace.m'), ...
 fullfile(root,'classifyEmotion.m'), ...
 fullfile(root,'detectFaceMask.m'), ...
 fullfile(root,'processFrame.m')};
for k=1:numel(sourceFiles)
    if ~isfile(sourceFiles{k}), error('Missing source file: %s',sourceFiles{k}); end
end
% Add the models folder as a folder so the compiled app keeps the models/ path.
additional=[sourceFiles,{modelDir}];
outDir=fullfile(root,'dist','VisionGuardAI');
if ~isfolder(fileparts(outDir)), mkdir(fileparts(outDir)); end
opts=compiler.build.StandaloneApplicationOptions(appFile, ...
    'ExecutableName','VisionGuardAI','OutputDir',outDir, ...
    'AdditionalFiles',additional,'AutoDetectDataFiles','on','Verbose','on');
results=compiler.build.standaloneWindowsApplication(opts);
disp(results);
fprintf('\nBuild finished. Inspect the generated files listed above.\n');
fprintf('The target computer needs a compatible MATLAB Runtime installation.\n');
end
