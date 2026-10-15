function [label,confidence]=detectFaceMask(faceImage,net,threshold)
% DETECTFACEMASK Run a validated Mask/No Mask classifier.
if nargin<3 || isempty(threshold), threshold=.6; end
if isempty(net), error('VisionGuard:MissingMaskModel','Add trained models/maskNet.mat.'); end
try
    [pred,scores]=classify(net,faceImage);
catch e
    error('VisionGuard:MaskInferenceFailed','Mask inference failed; verify model preprocessing: %s',e.message);
end
if ~isprop(net.Layers(end),'Classes')
    error('VisionGuard:MaskLabels','Mask model must expose class labels.');
end
classes=lower(strtrim(string(net.Layers(end).Classes)));
hasMask=any(ismember(classes,["mask","with_mask","masked"]));
hasNoMask=any(ismember(classes,["no mask","no_mask","without_mask","unmasked"]));
if ~hasMask || ~hasNoMask
    error('VisionGuard:MaskLabels','Model must include both Mask and No Mask labels.');
end
raw=string(pred); normLabel=lower(strtrim(raw)); idx=find(strcmpi(classes,raw),1);
if any(normLabel==["mask","with_mask","masked"])
    label='mask';
elseif any(normLabel==["no mask","no_mask","without_mask","unmasked"])
    label='no mask';
else
    error('VisionGuard:MaskLabels','Model returned an unknown class.');
end
confidence=double(scores(idx));
if confidence<threshold, label='uncertain'; end
end
