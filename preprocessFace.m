function crop=preprocessFace(frame,box,net)
if isempty(frame) || numel(box)~=4, error('Invalid frame or face box.'); end
x=max(1,round(box(1))); y=max(1,round(box(2))); w=min(round(box(3)),size(frame,2)-x+1); h=min(round(box(4)),size(frame,1)-y+1);
if w<1 || h<1, error('Face crop outside image.'); end
crop=frame(y:y+h-1,x:x+w-1,:); if size(crop,3)==1, crop=repmat(crop,1,1,3); end
sz=[224 224]; try, layers=net.Layers; for k=1:numel(layers), if isprop(layers(k),'InputSize'), q=layers(k).InputSize; if numel(q)>=2 && all(q(1:2)>0), sz=q(1:2); break; end, end, end, catch, end
crop=imresize(crop,sz);
end
