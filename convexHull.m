function [bw,controlPoints]= convexHull(img)

reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
if( ~checkToolboxes(reqToolboxes) )
 error('detectFaceParts requires: Computer Vision System Toolbox and Image Processing Toolbox. Please install these toolboxes.');
end

% bounding box found can be used later to remove everything outside it
% for now, just checking the entire image for features and getting convex
% hull
figure(1);
imshow(img);

detector = buildDetector();
% [bbox, bbimg, faces, bbfaces] = detectFaceParts(detector,img,2);
[bbox, ~, ~, ~] = detectFaceParts(detector,img,0);

maxA=bbox(1,3)*bbox(1,4);
for allFaces=2:length(bbox(:,1))
    if(bbox(allFaces,3)*bbox(allFaces,4)>maxA)
        maxA=bbox(allFaces,3)*bbox(allFaces,4);
        bbox(1,:)=bbox(allFaces,:);
    end
end

cvp=zeros(size(img));
cvp=rgb2gray(cvp);
controlPoints=ones(4,2);

%control points for eyes
cvp(bbox(1,6),bbox(1,5))=1;
controlPoints(1,:)=[bbox(1,6),bbox(1,5)];
% cvp(bbox(1,6)+bbox(1,8),bbox(1,5))=1;
% controlPoints(2,:)=[bbox(1,6)+bbox(1,8),bbox(1,5)];
cvp(bbox(1,10),bbox(1,9)+bbox(1,11))=1;
controlPoints(2,:)=[bbox(1,10),bbox(1,9)+bbox(1,11)];
% cvp(bbox(1,10)+bbox(1,12),bbox(1,9)+bbox(1,11))=1;
% controlPoints(4,:)=[bbox(1,10)+bbox(1,12),bbox(1,9)+bbox(1,11)];

%control points for nose
% cvp(bbox(1,18),bbox(1,17))=1;
% controlPoints(5,:)=[bbox(1,18),bbox(1,17)];
% cvp(bbox(1,18)+bbox(1,20),bbox(1,17))=1;
% controlPoints(6,:)=[bbox(1,18)+bbox(1,20),bbox(1,17)];
% cvp(bbox(1,18),bbox(1,17)+bbox(1,19))=1;
% controlPoints(7,:)=[bbox(1,18),bbox(1,17)+bbox(1,19)];
% cvp(bbox(1,18)+bbox(1,20),bbox(1,17)+bbox(1,19))=1;
% controlPoints(8,:)=[bbox(1,18)+bbox(1,20),bbox(1,17)+bbox(1,19)];

%control points for mouth
% cvp(bbox(1,14),bbox(1,13))=1;
% controlPoints(9,:)=[bbox(1,14),bbox(1,13)];
% cvp(bbox(1,14),bbox(1,13)+bbox(1,15))=1;
% controlPoints(10,:)=[bbox(1,14),bbox(1,13)+bbox(1,15)];
cvp(bbox(1,14)+bbox(1,16),bbox(1,13))=1;
controlPoints(3,:)=[bbox(1,14)+bbox(1,16),bbox(1,13)];
cvp(bbox(1,14)+bbox(1,16),bbox(1,13)+bbox(1,15))=1;
controlPoints(4,:)=[bbox(1,14)+bbox(1,16),bbox(1,13)+bbox(1,15)];

temp_CTR_PTS=controlPoints(:,1);
controlPoints(:,1)=controlPoints(:,2);
controlPoints(:,2)=temp_CTR_PTS;

figure(2);
imshow(cvp);
bw=bwconvhull(cvp);
figure(3);
imshow(bw);
end