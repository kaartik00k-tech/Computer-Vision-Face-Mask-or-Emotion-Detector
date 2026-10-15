function [label,confidence]=classifyEmotion(faceImage,net,threshold)
% CLASSIFYEMOTION Run a validated Happy/Sad/Neutral classifier.
if nargin<3 || isempty(threshold), threshold=.6; end
if isempty(net), error('VisionGuard:MissingEmotionModel','Add trained models/emotionNet.mat.'); end
try
    [pred,scores]=classify(net,faceImage);
catch e
    error('VisionGuard:EmotionInferenceFailed','Emotion inference failed; verify model preprocessing: %s',e.message);
end
if ~isprop(net.Layers(end),'Classes')
    error('VisionGuard:EmotionLabels','Emotion model must expose class labels.');
end
classes=lower(strtrim(string(net.Layers(end).Classes)));
needed=["happy","sad","neutral"];
if ~all(ismember(needed,classes))
    error('VisionGuard:EmotionLabels','Model must include all three labels: Happy, Sad, Neutral.');
end
raw=string(pred); idx=find(strcmpi(classes,raw),1);
if isempty(idx), error('VisionGuard:EmotionLabels','Model returned an unknown class.'); end
confidence=double(scores(idx)); label=char(lower(raw));
if confidence<threshold, label='uncertain'; end
end
