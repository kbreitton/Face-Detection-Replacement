function prob_face = svmpredict_prob(model, HOG_features)

[~, ~, prob_face] = predict(ones(size(HOG_features,1),1), sparse(HOG_features), model, '-b 1 -q');

prob_face = prob_face(:,1);
end