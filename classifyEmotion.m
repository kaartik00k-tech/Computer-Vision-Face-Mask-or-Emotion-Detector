function [label,confidence]=classifyEmotion(faceImage,net,threshold)
if nargin<3, threshold=.6; end
if isempty(net), error('VisionGuard:MissingEmotionModel','Add validated models/emotionNet.mat.'); end
try, [pred,scores]=classify(net,faceImage); catch e, error('Emotion inference failed; verify model preprocessing: %s',e.message); end
classes=string(net.Layers(end).Classes); raw=string(pred); idx=find(strcmpi(classes,raw),1);
if isempty(idx) || ~any(lower(raw)==["happy","sad","neutral"]), error('Emotion model labels must include Happy, Sad, and Neutral.'); end
confidence=double(scores(idx)); label=char(lower(raw)); if confidence<threshold, label='uncertain'; end
end
