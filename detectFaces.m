function boxes=detectFaces(frame,detector)
if isempty(frame), error('VisionGuard:InvalidFrame','Input frame is empty.'); end
if nargin<2 || isempty(detector), detector=vision.CascadeObjectDetector(); end
if size(frame,3)==3, frame=rgb2gray(frame); end
boxes=step(detector,frame);
end
