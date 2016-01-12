function hist = spread(dir, mag)
%given a pixel's gradient direction and magnitude, return its individual histogram of
%gradients

%split a pixel's magnitude between the two closest orientation bins to it,
%unless it hits exactly on a bin 
%     hist = zeros(1,9);

    response = abs(dir - [20 60 100 140 180 220 260 300 340]);
    response(response == 0) = realmin;
    response(response > 40) = 0;
    response(response > 0) = 40 - response(response > 0);
    response = response ./ 40;

    hist = response .* mag;
%         values = (1 - sorted(1:2) / sum(sorted(1:2))) * mag;
%         hist(response == sorted(1)) = values(1);
%         hist(response == sorted(2)) = values(2);
end

