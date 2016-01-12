source_face = face_windows_all{5}{1};
source_face = padarray(source_face, [50 50]);
[source_hull, ctrpts_source] = convexHull(source_face);


for n = 17:length(face_windows_all)
    if n ~=5 || n ~=6
        if ~isempty(face_windows_all)
            target_image = images_all{n};
            face_windows_target = face_windows_all{n};
            boundingBoxes_target = boundingBoxes_all{n};
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
            
            output_image = target_image;
            %% show the final image
            close all
            imshow(output_image);
            
            %% save the final image
            imwrite(output_image, ['face_replace_', num2str(n), '.jpg'], 'jpg');
            
        end
    end
end