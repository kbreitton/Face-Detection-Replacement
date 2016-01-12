tic
% clear all
clc

directory = cd;
cd data/SampleSet/easy

%%  load input images
files = dir('*.jpg');

for i = 1:length(files)
    to_classify{i} = imread(files(i).name);
end
cd (directory)

to_classify = to_classify';

% load('SVMstruct.mat');
% sv = SVMstruct.SupportVectors;
% alphaHat = SVMstruct.Alpha;
% bias = SVMstruct.Bias;
% kfun = SVMstruct.KernelFunction;
% kfunargs = SVMstruct.KernelFunctionArgs;

for i = 1:1
    [tempBoxes,tempf] = scaleRecurse_klyde(rgb2gray(to_classify{i}),1,svm_model_ours);
    boundingBoxes(i)=mat2cell(tempBoxes);
    f(i)=mat2cell(tempf);
    i
    
    green = uint8([0 255 0]);
    if(isempty(tempBoxes)==0)
        shapeInserter = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','CustomBorderColor',green);
        rects=[tempBoxes(:,2),tempBoxes(:,1),tempBoxes(:,4)-tempBoxes(:,2),tempBoxes(:,3)-tempBoxes(:,1)];
        J = step(shapeInserter, to_classify{i}, int32(rects));
    else
        J=to_classify{i};
    end
    figure(i)
    imshow(J);
end

% for i = 1:length(to_classify)
%     to_classify_HOG(i,:) = HOG(imresize(rgb2gray(to_classify{i}),[36 36]));    
% end
% 
% % ToClassifyHOG=HOG(ToClassify);
% to_classify_HOG=cell2mat(to_classify_HOG);
% 
% SampleScaleShift = bsxfun(@plus,to_classify_HOG,SVMstruct.ScaleData.shift);
% Sample = bsxfun(@times,SampleScaleShift,SVMstruct.ScaleData.scaleFactor);
% 
% is_face=svmclassify(SVMstruct,to_classify_HOG)
% f= (kfun(sv,Sample,kfunargs{:})'*alphaHat(:) + bias)*-1

toc