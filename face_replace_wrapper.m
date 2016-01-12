function output_image = face_replace_wrapper(source_image,target_image)

% source_image = padarray(source_image, [50 50]);
% target_image = padarray(target_image, [50 50]);

load svm_model_ours

%% detect face of source image (should contain only one face)
[boundingBoxes_source, ~, ~, ~, face_windows_source] = facedetect(source_image, svm_model_ours);

%% detect face(s) of target image
[boundingBoxes_target, ~, ~, ~, face_windows_target] = facedetect(target_image, svm_model_ours);

%% face-replace the source face with all target faces
if ~isempty(face_windows_source) && ~isempty(face_windows_source)
    
    source_face = padarray(face_windows_source{1}, [50 50]);
    [source_hull, ctrpts_source] = convexHull(source_face);
    
    for i = 1:length(face_windows_target) %for all target face windows
        target_face = padarray(face_windows_target{i},[50 50]); %get target face
        [target_hull, ctrpts_target] = convexHull(target_face); %get convex hull of face
        replaced_face_window{i} = morph_replace(source_face, target_face, ctrpts_source, ctrpts_target, target_hull); %get window with morphed face
        replaced_face_window{i} = replaced_face_window{i}(51:end-50,51:end-50,:);
    end
    
    %% swap back in the morphed faces in the target image
    for i = 1:length(face_windows_target)
        target_image(boundingBoxes_target(i,2):boundingBoxes_target(i,4), boundingBoxes_target(i,1):boundingBoxes_target(i,3),:) = replaced_face_window{i};
    end

    %% show the final image
    close all
    imshow(output_image);
    
else
    output_image = [];
    disp('No faces detected in one and/or the other image')
end
end
