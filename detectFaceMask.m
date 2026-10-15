function [label,confidence]=detectFaceMask(faceImage,net,threshold)
if nargin<3, threshold=.6; end
if isempty(net), error('VisionGuard:MissingMaskModel','Add validated models/maskNet.mat.'); end
try, [pred,scores]=classify(net,faceImage); catch e, error('Mask inference failed; verify model preprocessing: %s',e.message); end
classes=string(net.Layers(end).Classes); raw=string(pred); normLabel=lower(raw);
if any(normLabel==["mask","with_mask","masked"]), label='mask'; elseif any(normLabel==["no mask","no_mask","without_mask","unmasked"]), label='no mask'; else, error('Mask model labels must identify Mask and No Mask.'); end
idx=find(strcmpi(classes,raw),1); confidence=double(scores(idx)); if confidence<threshold, label='uncertain'; end
end
