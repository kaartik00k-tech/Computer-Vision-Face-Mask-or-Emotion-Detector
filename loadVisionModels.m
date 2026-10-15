function models=loadVisionModels(modelDir)
if nargin<1 || isempty(modelDir), modelDir=fullfile(pwd,'models'); end
models=struct('emotionNet',[],'maskNet',[]);
f=fullfile(modelDir,'emotionNet.mat'); if isfile(f), s=load(f,'emotionNet'); if ~isfield(s,'emotionNet'), error('emotionNet.mat must contain variable emotionNet.'); end; models.emotionNet=s.emotionNet; end
f=fullfile(modelDir,'maskNet.mat'); if isfile(f), s=load(f,'maskNet'); if ~isfield(s,'maskNet'), error('maskNet.mat must contain variable maskNet.'); end; models.maskNet=s.maskNet; end
end
