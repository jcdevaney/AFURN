function confus=confusionMat(vpath, GT)

confus = zeros(3);
for k = 1:3
    for k2 = 1:3
        % Row is prediction from HMM
        % Column is ground truth
            confus(k, k2) = confus(k, k2) + sum((vpath == k) .* (GT == k2));
    end
end