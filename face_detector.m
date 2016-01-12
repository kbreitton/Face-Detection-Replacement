function [boundingBoxes, f_probs, fHOGs] = face_detector(im, scale, start_scale, end_scale, max_scales, face_thres, svm_model_ours)

%% scale image and do edge detection
for k = start_scale:end_scale %last iteration is when you scale image down so the minimum dimension is 36
    
    im_scaled = imresize(im, scale^(k-1)); %don't scale for k=1
    sz = size(im_scaled);
    
    
    %do edge detection first and look for a face only around where edges occur
    bw = cannyEdge(im_scaled, .4 * (max_scales+1)/(k+1), .4 * (max_scales+1)/(k+1)); %change the thresholds of edge detection to be lower the larger the scale (smaller the image), where the minimum threshold is .4
    [row, col] = find(bw == 1); %i,j indices of each edge pixel
    row = row(1:2:end);
    col = col(1:2:end);
%     bw = convexHull(rgb2gray(im_scaled));
%     figure(1); imshow(bw);
%     [row, col] = find(bw == 1);
    %zero pad image
    %     im_pad = padarray(im_scaled, [35 35]);
    
    %% get HOGs around edges and predict if face
    windowHOG = cell(1,length(row));
    for n = 1:length(row) %numel(bw) %for total # pixels that are edges, get the window HOGs
        %get window centered at edge pixel
        if row(n)-17 > 0 && row(n)+18 < sz(1)&& col(n)-17 > 0 && col(n)+18 < sz(2) %make sure window centered at edge pixel is within bounds
            windowHOG{n} = rgb2gray(im_scaled(row(n)-17:row(n)+18, col(n)-17:col(n)+18,:));
        else
            windowHOG{n} = zeros(36);
        end
    end
    
    %get HOGs of each window
    HOGs_all = cellfun(@HOG, windowHOG, 'UniformOutput', false);
    HOGs_all = HOGs_all';
    windowHOG = cell2mat(HOGs_all);
    
    %face prediction probabilities for each window HOG
    prob_face = svmpredict_prob(svm_model_ours, windowHOG);
    %     prob_face = svmpredict_prob(svm_model_matlabs, windowHOG);
    
    detectedFaceWindowHOGs{k,1} = windowHOG(prob_face > face_thres,:);
    face_centers = find(prob_face > face_thres); % elements of prob_face where greater than .9 prob is a "face"
    %     [max_prob, face_centers] = max(prob_face);
    
    i = row(face_centers); %i, j centers of each face detected
    j = col(face_centers);
    boundingBoxes_scaleLevel{k,1} = [j-17,i-17,j+18,i+18]; %get box around each face center (in x,y)
    
    boundingBoxCenters_scaleLevel{k,1} = round((fliplr(boundingBoxes_scaleLevel{k,1}(:,1:2) + 17))/ (scale^(k-1))); %get where the boundingBoxes' centers (in i,j) would be at normal image size
    boundingBoxes_scaleLevel{k,1} = round(boundingBoxes_scaleLevel{k,1} / (scale^(k-1))); % scale box back to what it would be at normal image size
    
    f_probs_scaleLevel{k,1} = prob_face(prob_face > face_thres); %store face probabilities
    
end

f_probs = cell2mat(f_probs_scaleLevel);
boundingBoxes = cell2mat(boundingBoxes_scaleLevel);
boundingBoxCenters = cell2mat(boundingBoxCenters_scaleLevel);
fHOGs = cell2mat(detectedFaceWindowHOGs);


%% removing overlaps -- if the centers of some boundingBoxes are close to each other, just take the boundingBox of that group with the largest face probability
max_overlap_center_distance = 30;
count=1;
filteredFprobs=[];
filteredBoundingBoxes=[];
filteredFhogs=[];

%nested for loops to iterate through all boundingBoxes
for rCount_a=1:length(boundingBoxes(:,1))
    keepIt=1;
    for rCount_b=1:length(boundingBoxes(:,1))
        center_a = boundingBoxCenters(rCount_a,:);
        center_b = boundingBoxCenters(rCount_b,:);

        if((pdist2(center_a, center_b) < max_overlap_center_distance && f_probs(rCount_a)>=f_probs(rCount_b)) || pdist2(center_a, center_b)>=max_overlap_center_distance)
   
            keepIt=1;
        else
            keepIt=0;
            break;
        end
    end
    if(keepIt==1)
        filteredFprobs(count,:)=f_probs(rCount_a);
        filteredBoundingBoxes(count,:)=boundingBoxes(rCount_a,:);
        filteredFhogs(count,:)=fHOGs(rCount_a);
        count=count+1;
    end
end

f_probs=filteredFprobs;
boundingBoxes=filteredBoundingBoxes;
fHOGs=filteredFhogs;



end