function trainVisionModels(dataRoot, outputDir)
% TRAINVISIONMODELS Train two small CNN classifiers from labelled image folders.
% Expected folders:
% dataRoot/emotion/Happy, Sad, Neutral
% dataRoot/mask/Mask, No Mask
% Use face-cropped images that resemble the crops produced by the app.
% Requires Deep Learning Toolbox and Image Processing Toolbox.
if nargin<1 || isempty(dataRoot), dataRoot=fullfile(pwd,'dataset'); end
if nargin<2 || isempty(outputDir), outputDir=fullfile(pwd,'models'); end
if ~isfolder(outputDir), mkdir(outputDir); end
required={{'emotion',{'Happy','Sad','Neutral'}},{'mask',{'Mask','No Mask'}}};
for k=1:numel(required)
    task=required{k}{1}; classes=required{k}{2};
    taskDir=fullfile(dataRoot,task);
    if ~isfolder(taskDir), error('Missing dataset folder: %s',taskDir); end
    for j=1:numel(classes)
        if ~isfolder(fullfile(taskDir,classes{j}))
            error('Missing class folder: %s',fullfile(taskDir,classes{j}));
        end
    end
end
fprintf('Training emotion classifier...\n');
emotionNet=trainOne(fullfile(dataRoot,'emotion'),{'Happy','Sad','Neutral'});
save(fullfile(outputDir,'emotionNet.mat'),'emotionNet','-v7.3');
fprintf('Saved %s\n',fullfile(outputDir,'emotionNet.mat'));
fprintf('Training face-mask classifier...\n');
maskNet=trainOne(fullfile(dataRoot,'mask'),{'Mask','No Mask'});
save(fullfile(outputDir,'maskNet.mat'),'maskNet','-v7.3');
fprintf('Saved %s\n',fullfile(outputDir,'maskNet.mat'));
fprintf('Training complete. Evaluate both networks on a held-out test set before use.\n');
end

function net=trainOne(folder,expectedClasses)
imds=imageDatastore(folder,'IncludeSubfolders',true,'LabelSource','foldernames');
if numel(imds.Files)<20
    error('Dataset %s has fewer than 20 images. Add a properly labelled dataset before training.',folder);
end
observed=string(categories(imds.Labels));
for k=1:numel(expectedClasses)
    if ~any(strcmpi(observed,expectedClasses{k}))
        error('Dataset %s is missing class folder %s.',folder,expectedClasses{k});
    end
end
% Hold out 20%% for validation; this is a development validation split,
% not a substitute for a separate subject-disjoint final test set.
[trainDS,valDS]=splitEachLabel(imds,0.8,'randomized');
inputSize=[64 64 3];
augTrain=augmentedImageDatastore(inputSize(1:2),trainDS,'ColorPreprocessing','gray2rgb');
augVal=augmentedImageDatastore(inputSize(1:2),valDS,'ColorPreprocessing','gray2rgb');
layers=[
 imageInputLayer(inputSize,'Normalization','zerocenter','Name','input')
 convolution2dLayer(3,16,'Padding','same','Name','conv1')
 batchNormalizationLayer('Name','bn1')
 reluLayer('Name','relu1')
 maxPooling2dLayer(2,'Stride',2,'Name','pool1')
 convolution2dLayer(3,32,'Padding','same','Name','conv2')
 batchNormalizationLayer('Name','bn2')
 reluLayer('Name','relu2')
 maxPooling2dLayer(2,'Stride',2,'Name','pool2')
 convolution2dLayer(3,64,'Padding','same','Name','conv3')
 batchNormalizationLayer('Name','bn3')
 reluLayer('Name','relu3')
 globalAveragePooling2dLayer('Name','gap')
 fullyConnectedLayer(numel(expectedClasses),'Name','fc')
 softmaxLayer('Name','softmax')
 classificationLayer('Name','classOutput')];
opts=trainingOptions('adam','MaxEpochs',12,'MiniBatchSize',32, ...
 'Shuffle','every-epoch','ValidationData',augVal,'ValidationFrequency',max(1,floor(numel(trainDS.Files)/32)), ...
 'Verbose',true,'Plots','training-progress');
net=trainNetwork(augTrain,layers,opts);
pred=classify(net,augVal);
truth=valDS.Labels;
acc=mean(pred==truth);
fprintf('Validation accuracy for %s: %.1f%% (not a final unbiased test metric)\n',folder,100*acc);
end
