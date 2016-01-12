directory = cd;
cd data/caltech_faces/Caltech_CropFaces

%%  load faces
files = dir('*.jpg');

for i = 1:length(files)
    training_faces{i} = imread(files(i).name);
end
cd (directory)

training_faces = training_faces';

save('training_faces', 'training_faces');
%% get HOG's on the 36x36 faces
for i = 1:length(training_faces)
    training_faces_HOG(i,:) = HOG(training_faces{i});
end

save('training_faces_HOG', 'training_faces_HOG');

%% now train non-faces

directory = cd;
cd data/train_non_face_scenes

%%  load non-faces
files = dir('*.jpg');

for i = 1:length(files)
    training_nonfaces{i} = rgb2gray(imread(files(i).name));
end
cd (directory)

training_nonfaces = training_nonfaces';

save('training_nonfaces', 'training_nonfaces');
%% get HOG's on the non-faces
%for each non-face scene, do a sliding window over the whole image and save
%each HOG of the sliding window as a non-face
for i = 1:length(training_nonfaces)
    clc
    disp(['on image ', num2str(i)]);
    
    sz = size(training_nonfaces{i});
    rows = 1:15:sz(1);
    cols = 1:15:sz(2);
    
    if rows(end) + 45 > sz(1)
        rows = rows(1:end-3);
    end
    
    if cols(end) + 45 > sz(2)
        cols = cols(1:end-3);
    end
    
    for r = 1:numel(rows)
        for c = 1:numel(cols)
        window = rgb2gray(training_nonfaces{i}(rows(r):rows(r)+35,cols(c):cols(c)+35,:));
        training_nonfaces_HOG{i}(sub2ind([numel(rows) numel(cols)],r,c),:) = HOG(window);
        end
    end
end

training_nonfaces_HOG = training_nonfaces_HOG';

training_nonfaces_HOG = cell2mat(training_nonfaces_HOG);

save('training_nonfaces_HOG', 'training_nonfaces_HOG', '-v7.3');

%% train an svm model using this data, where classify faces as 1 and non-faces as 0

load training_faces_HOG 
load training_faces_HOG_matlabs 
load training_nonfaces_HOG 
load training_nonfaces_HOG_matlabs

%% cross validate svm model on ~10000 nonface examples

cost = 0.1:0.1:2;
training_nonfaces_HOG_sampled = training_nonfaces_HOG(1:17:end,:);
feature_matrix_ours = [training_faces_HOG; training_nonfaces_HOG_sampled];

%select cost parameter
for n = 1:length(cost)
    accuracy(n) = train([ones(size(training_faces_HOG,1),1); zeros(size(training_nonfaces_HOG_sampled,1),1)], sparse(feature_matrix_ours), ['-s 0 -v 10 -q -c ', num2str(cost(n))]); 
end

%best_svm_cost = 0.8!!


%% svm model using our HOG
feature_matrix_ours = [training_faces_HOG; training_nonfaces_HOG];
svm_model_ours = train([ones(size(training_faces_HOG,1),1); zeros(size(training_nonfaces_HOG,1),1)], sparse(feature_matrix_ours), '-s 0 -q -c 0.8'); 

save('svm_model_ours', 'svm_model_ours');

% %% svm model using matlab's HOG
% feature_matrix_matlabs = double([training_faces_HOG_matlabs; training_nonfaces_HOG_matlabs]);
% svm_model_matlabs = svmtrain([ones(size(training_faces_HOG_matlabs,1),1); zeros(size(training_nonfaces_HOG_matlabs,1),1)], feature_matrix_matlabs, '-t 0 -b 1'); 
% 
% save('svm_model_matlabs', 'svm_model_matlabs');
% 
% %% train an svm model using this data PLUS MISCLASSIFIED STUFF, where classify faces as 1 and non-faces as 0
% 
% load training_faces_HOG 
% load training_faces_HOG_matlabs 
% load training_nonfaces_HOG 
% load training_nonfaces_HOG_matlabs
% %% 
% feature_matrix_ours = [training_faces_HOG; training_nonfaces_HOG];
% feature_labels = [ones(size(training_faces_HOG,1),1); zeros(size(training_nonfaces_HOG,1),1)];
% %% svm model using our HOG
% % feature_matrix_ours = [HOGface; feature_matrix_ours];
% % feature_labels = [ones(size(HOGface,1),1); feature_labels];
% % svm_model_ours = train([ones(size(HOGface,1),1); ones(size(training_faces_HOG,1),1); zeros(size(training_nonfaces_HOG,1),1)], sparse(feature_matrix_ours), '-s 0 -q -c 0.8'); 
% 
% % feature_matrix_ours = [HOGface; training_faces_HOG; training_nonfaces_HOG; detectedFaceWindowHOGs];
% % svm_model_ours = train([ones(size(HOGface,1),1); ones(size(training_faces_HOG,1),1); zeros(size(training_nonfaces_HOG,1),1); zeros(size(detectedFaceWindowHOGs,1),1)], sparse(feature_matrix_ours), '-s 0 -q -c 0.8'); 
% 
% feature_matrix_ours = [feature_matrix_ours; falseFaceWindowHOGs];
% feature_labels = [feature_labels; zeros(size(falseFaceWindowHOGs,1),1)];
% svm_model_ours = train(feature_labels, sparse(feature_matrix_ours), '-s 0 -q -c 0.8'); 
% 
% save('feature_matrix_ours', 'feature_matrix_ours');
% save('feature_labels', 'feature_labels');
% save('svm_model_ours', 'svm_model_ours');
% 
% %% svm model using matlab's HOG
% feature_matrix_matlabs = double([training_faces_HOG_matlabs; training_nonfaces_HOG_matlabs; detectedFaceWindowHOGs]);
% svm_model_matlabs = svmtrain([ones(size(training_faces_HOG_matlabs,1),1); zeros(size(training_nonfaces_HOG_matlabs,1),1); zeros(size(detectedFaceWindowHOGs,1),1)], feature_matrix_matlabs, '-t 0 -b 1'); 
% 
% save('svm_model_matlabs', 'svm_model_matlabs');