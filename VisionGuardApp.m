function VisionGuardApp()
% VisionGuardApp: webcam face detection with separate trained classifiers.
% Train models first using trainVisionModels.m.
fig=uifigure('Name','VisionGuard AI','Color',[0.055 0.075 0.12],'Position',[100 100 1180 740],'CloseRequestFcn',@closeApp);
uilabel(fig,'Text','VISIONGUARD AI','FontSize',24,'FontWeight','bold','FontColor',[0.88 0.94 1],'Position',[28 690 500 32]);
uilabel(fig,'Text','REAL-TIME COMPUTER VISION | LOCAL PROCESSING','FontSize',10,'FontColor',[0.35 0.72 1],'Position',[30 670 500 18]);
ax=uiaxes(fig,'Position',[28 115 790 535],'Color',[0.025 0.035 0.06],'XColor','none','YColor','none'); ax.XTick=[]; ax.YTick=[]; title(ax,'Camera preview');
p=uipanel(fig,'Title','CONTROL CENTER','Position',[840 115 310 535],'BackgroundColor',[0.075 0.10 0.16]);
uilabel(p,'Text','Detection mode','Position',[18 475 260 22]); mode=uidropdown(p,'Items',{'Emotion Detection','Face Mask Detection'},'Position',[18 445 270 30]);
uilabel(p,'Text','Confidence threshold','Position',[18 405 260 22]); threshold=uislider(p,'Limits',[0.3 0.95],'Value',0.6,'Position',[25 395 250 3]);
uibutton(p,'Text','START CAMERA','Position',[18 320 270 36],'ButtonPushedFcn',@startCamera);
uibutton(p,'Text','STOP CAMERA','Position',[18 275 130 34],'ButtonPushedFcn',@stopCamera);
uibutton(p,'Text','CAPTURE SNAPSHOT','Position',[158 275 130 34],'ButtonPushedFcn',@saveSnapshot);
uibutton(p,'Text','RESET RESULTS','Position',[18 232 270 32],'ButtonPushedFcn',@resetResults);
status=uilabel(p,'Text','STATUS: CAMERA STOPPED','Position',[18 190 275 22]); fps=uilabel(p,'Text','FPS: --','Position',[18 160 130 22]); count=uilabel(p,'Text','Faces: 0','Position',[155 160 130 22]); masked=uilabel(p,'Text','Masked: 0','Position',[18 132 130 22]); unmasked=uilabel(p,'Text','No mask: 0','Position',[155 132 130 22]); msg=uilabel(p,'Text','Train and validate classifier models before classification.','Position',[18 35 270 80],'WordWrap','on');
cam=[]; t=[]; detector=vision.CascadeObjectDetector(); models=struct('emotionNet',[],'maskNet',[]); running=false; lastFrame=[]; n=0; tick=tic;
    function startCamera(~,~)
        if running, return; end
        try
            if exist('webcam','file')~=2, error('Webcam support unavailable. Check MATLAB toolboxes and camera adaptor.'); end
            available=webcamlist; if isempty(available), error('No compatible webcam found. Check camera permissions and close other camera apps.'); end
            cam=webcam(1); models=loadVisionModels(fullfile(fileparts(mfilename('fullpath')),'models'));
            running=true; tick=tic; n=0; status.Text='STATUS: CAMERA RUNNING'; status.FontColor=[0.35 0.9 0.65];
            t=timer('ExecutionMode','fixedSpacing','Period',0.1,'BusyMode','drop','TimerFcn',@frameTick); start(t);
        catch e, msg.Text=e.message; stopCamera(); end
    end
    function frameTick(~,~)
        if ~running || isempty(cam) || ~isvalid(fig), return; end
        try
            frame=snapshot(cam); if isempty(frame), error('Camera returned an empty frame.'); end
            boxes=detectFaces(frame,detector); out=frame;
            if ~isempty(boxes), out=insertShape(out,'Rectangle',boxes,'Color','cyan','LineWidth',3); end
            count.Text=sprintf('Faces: %d',size(boxes,1));
            if isempty(boxes)
                msg.Text='No face detected. Adjust lighting or camera position.';
                masked.Text='Masked: 0'; unmasked.Text='No mask: 0';
            else
                if strcmp(mode.Value,'Emotion Detection'), whichMode='emotion'; else, whichMode='mask'; end
                if strcmp(whichMode,'emotion'), selected=models.emotionNet; else, selected=models.maskNet; end
                if isempty(selected)
                    if strcmp(whichMode,'emotion'), missing='Missing models/emotionNet.mat. Follow README training steps.'; else, missing='Missing models/maskNet.mat. Follow README training steps.'; end
                    msg.Text=missing;
                else
                    r=processFrame(frame,detector,models,whichMode,threshold.Value);
                    for j=1:numel(r.labels), b=r.boxes(j,:); out=insertText(out,[b(1) max(1,b(2)-22)],r.labels{j},'FontSize',16,'BoxColor',[0.03 0.16 0.28],'TextColor','white'); end
                    msg.Text=strjoin(r.labels,newline);
                    masked.Text=sprintf('Masked: %d',r.maskedCount); unmasked.Text=sprintf('No mask: %d',r.unmaskedCount);
                end
            end
            imshow(out,'Parent',ax); lastFrame=out;
            n=n+1; elapsed=toc(tick); if elapsed>=1, fps.Text=sprintf('FPS: %.1f',n/elapsed); n=0; tick=tic; end
        catch e, msg.Text=e.message; stopCamera(); end
    end
    function stopCamera(varargin)
        running=false;
        if ~isempty(t), try, if isvalid(t), stop(t); delete(t); end, catch, end, t=[]; end
        if ~isempty(cam), try, delete(cam); catch, end, cam=[]; end
        if isvalid(fig), status.Text='STATUS: CAMERA STOPPED'; status.FontColor=[0.95 0.72 0.28]; end
    end
    function saveSnapshot(~,~)
        if isempty(lastFrame), msg.Text='Start camera before capturing a snapshot.'; return; end
        [f,path]=uiputfile('*.png','Save snapshot','VisionGuard_snapshot.png'); if isequal(f,0), return; end
        imwrite(lastFrame,fullfile(path,f)); msg.Text=['Saved: ' fullfile(path,f)];
    end
    function resetResults(~,~)
        count.Text='Faces: 0'; masked.Text='Masked: 0'; unmasked.Text='No mask: 0'; fps.Text='FPS: --'; msg.Text='Results reset.'; lastFrame=[];
    end
    function closeApp(~,~), stopCamera(); delete(fig); end
end
