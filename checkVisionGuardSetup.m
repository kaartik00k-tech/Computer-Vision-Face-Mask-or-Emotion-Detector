function checkVisionGuardSetup()
% CHECKVISIONGUARDSETUP Diagnose the local MATLAB setup for VisionGuard AI.
% Run this from the extracted project folder:
%   checkVisionGuardSetup
%
% This script reports local MATLAB details. It does not build the EXE.

fprintf('\n========================================\n');
fprintf(' VisionGuard AI - Setup Diagnostics\n');
fprintf('========================================\n');

root = fileparts(mfilename('fullpath'));
fprintf('\nProject folder: %s\n', root);
fprintf('VisionGuardApp.m exists: %d (2 means yes, 0 means no)\n', ...
    exist(fullfile(root, 'VisionGuardApp.m'), 'file'));

fprintf('\n--- MATLAB version ---\n');
fprintf('%s\n', version);

fprintf('\n--- Installed products ---\n');
try
    ver
catch ME
    fprintf('Could not list products: %s\n', ME.message);
end

fprintf('\n--- MATLAB Compiler license test ---\n');
try
    compilerLicense = license('test', 'Compiler');
    fprintf('license(''test'',''Compiler'') = %d\n', compilerLicense);
catch ME
    fprintf('Compiler license check failed: %s\n', ME.message);
end

fprintf('\n--- Windows standalone build function ---\n');
try
    buildFunction = which('compiler.build.standaloneWindowsApplication', '-all');
    if isempty(buildFunction)
        fprintf('Not found in this MATLAB installation/path.\n');
    else
        disp(buildFunction);
    end
catch ME
    fprintf('Could not check build function: %s\n', ME.message);
end

fprintf('\n--- Model files ---\n');
fprintf('models/emotionNet.mat exists: %d\n', ...
    exist(fullfile(root, 'models', 'emotionNet.mat'), 'file'));
fprintf('models/maskNet.mat exists: %d\n', ...
    exist(fullfile(root, 'models', 'maskNet.mat'), 'file'));

fprintf('\n--- Dataset folders ---\n');
folders = { ...
    fullfile(root, 'dataset', 'emotion', 'Happy'), ...
    fullfile(root, 'dataset', 'emotion', 'Sad'), ...
    fullfile(root, 'dataset', 'emotion', 'Neutral'), ...
    fullfile(root, 'dataset', 'mask', 'Mask'), ...
    fullfile(root, 'dataset', 'mask', 'No Mask')};
labels = {'emotion/Happy','emotion/Sad','emotion/Neutral','mask/Mask','mask/No Mask'};
for k = 1:numel(folders)
    if isfolder(folders{k})
        files = [dir(fullfile(folders{k}, '*.jpg')); ...
                 dir(fullfile(folders{k}, '*.jpeg')); ...
                 dir(fullfile(folders{k}, '*.png')); ...
                 dir(fullfile(folders{k}, '*.bmp'))];
        fprintf('%s: folder exists, %d image(s)\n', labels{k}, numel(files));
    else
        fprintf('%s: folder missing\n', labels{k});
    end
end

fprintf('\nDiagnostics complete. Copy the Command Window output into your ChatGPT conversation.\n');
fprintf('No files were built or changed on this computer by this diagnostic.\n\n');
end
