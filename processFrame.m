function r=processFrame(frame,detector,models,mode,threshold)
if nargin<5, threshold=.6; end
r=struct('boxes',detectFaces(frame,detector),'labels',{{}},'maskedCount',0,'unmaskedCount',0); r.labels=cell(size(r.boxes,1),1);
for k=1:size(r.boxes,1)
 if strcmpi(mode,'emotion'), net=models.emotionNet; elseif strcmpi(mode,'mask'), net=models.maskNet; else, error('Mode must be emotion or mask.'); end
 if isempty(net), error('Selected trained model is missing. See README model setup.'); end
 crop=preprocessFace(frame,r.boxes(k,:),net);
 if strcmpi(mode,'emotion'), [lab,conf]=classifyEmotion(crop,net,threshold); else, [lab,conf]=detectFaceMask(crop,net,threshold); if strcmp(lab,'mask'), r.maskedCount=r.maskedCount+1; end; if strcmp(lab,'no mask'), r.unmaskedCount=r.unmaskedCount+1; end; end
 r.labels{k}=sprintf('%s (%.0f%%)',upper(lab),100*conf);
end
end
