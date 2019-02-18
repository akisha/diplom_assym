function num = noi(diff)
sign_diff = sign(diff);
num = length(find(~sign_diff));
sign_diff = sign_diff(1 : end - 1) + sign_diff(2 : end);
num = num + length(find(~sign_diff));