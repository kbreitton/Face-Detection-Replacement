function [boundingBoxes, f_probs, fHOGs, image, face_windows] = facedetect(im, svm_model_ours)
%read in an RGB image and plot the detected faces, and output the boundingBoxes (4-element vector of x,y top left corner and x,y of bottom right corner), probabilities that
%faces are faces, and their HOGs

close all

scale = .7;

face_thres = .98; % threshold probability that a face is really a face

green = uint8([0 255 0]);
shapeInserter = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','CustomBorderColor',green);
max_scales = round(abs(log(min(size(rgb2gray(im))) / 36) / log(scale))) + 1; %solution to how many times you can scale down the image by each time...plus 1, since the first iteration you don't scale


%% start at a small scale then if no faces are detected, go bigger
%don't bother with large images yet (bigger than 120x120ish), so start with an appropriate scale
if numel(im(:,:,1)) > 120*120
    start_scale = round(abs(log(min(size(rgb2gray(im))) / 120) / log(scale)))+1; %'start' is the scale level with which detection starts
    if start_scale == 0
        start_scale = 1;
    end
else
    start_scale = 1;
end

%% scale image and do edge detection
[boundingBoxes, f_probs, fHOGs] = face_detector(im, scale, start_scale, max_scales, max_scales, face_thres, svm_model_ours);

%% if no faces found (and the original image is bigger than 120x120~ish, try scaling to min dimension 240, then if no face still found, scale to min dimension 360 (but if none found after that, stop)

if start_scale == 1 && isempty(boundingBoxes) == 1
    disp('No faces detected');
elseif isempty(boundingBoxes) == 1
    
    if numel(im(:,:,1)) > 240*240
        start_scale = round(abs(log(min(size(rgb2gray(im))) / 240) / log(scale)))+1; %'start' is the scale level with which detection starts
        if start_scale == 0
            start_scale = 1;
        end
    else
        start_scale = 1;
    end
    
    [boundingBoxes_next, f_probs_next, fHOGs_next] = face_detector(im, scale, start_scale, start_scale, max_scales, face_thres, svm_model_ours);
    boundingBoxes = [boundingBoxes; boundingBoxes_next]; %% concatenate old + new boundingBoxes
    f_probs = [f_probs; f_probs_next];
    fHOGs = [fHOGs; fHOGs_next];
    
    %if still no faces detected, try 360x360ish scale
    if start_scale == 1 && isempty(boundingBoxes) == 1
        disp('No faces detected');
    elseif isempty(boundingBoxes) == 1
        
        
        if numel(im(:,:,1)) > 360*360 
            start_scale = round(abs(log(min(size(rgb2gray(im))) / 360) / log(scale)))+1; %'start' is the scale level with which detection starts
            if start_scale == 0
                start_scale = 1;
            end
        else
            start_scale = 1;
        end
        
        [boundingBoxes_next, f_probs_next, fHOGs_next] = face_detector(im, scale, start_scale, start_scale, max_scales, face_thres, svm_model_ours);
        boundingBoxes = [boundingBoxes; boundingBoxes_next];
        f_probs = [f_probs; f_probs_next];
        fHOGs = [fHOGs; fHOGs_next];
        
        if isempty(boundingBoxes) == 1
            disp('No faces detected');
        end
    end
    
end

%% plot faces detected (if any) and output all the face windows

if isempty(boundingBoxes) == 0
    rects=[boundingBoxes(:,1),boundingBoxes(:,2),boundingBoxes(:,3) - boundingBoxes(:,1), boundingBoxes(:,4) - boundingBoxes(:,2)];
    J = step(shapeInserter, im, int32(rects));
    figure(1)
    imshow(J)
    image = J;
    
    %also extract the cropped windows of the actual faces
    for i=1:size(boundingBoxes,1)
        face_windows{i} = im(boundingBoxes(i,2):boundingBoxes(i,4),boundingBoxes(i,1):boundingBoxes(i,3),:);
    end
else
    image = [];
    face_windows = [];
end


end
