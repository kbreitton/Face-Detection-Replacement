
main_directory = cd;
cd test_results
save_directory = cd;



for i = 1:length(test_images)
    cd(main_directory)
    
    [boundingBoxes, f_probs, fHOGs, image, face_windows] = facedetect(test_images{i}, svm_model_ours);
    
    boundingBoxes_all{i} = boundingBoxes;
    f_probs_all{i} = f_probs;
    fHOGs_all{i} = fHOGs;
    face_windows_all{i} = face_windows;
    
    cd(save_directory)
    if isempty(boundingBoxes) == 0
        imwrite(image, [num2str(i), '.jpg'], 'jpg');
        images_all{i} = image;
    else
        imwrite(test_images{i}, [num2str(i), '.jpg'], 'jpg');
        images_all{i} = test_images{i};
    end
end

save('allData', 'boundingBoxes_all', 'f_probs_all', 'fHOGs_all', 'images_all', 'face_windows_all');