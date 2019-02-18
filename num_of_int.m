function num = num_of_int(diff)
num = 0;
for i = 1 : length(diff) - 1
    if (diff(i) * diff(i + 1) <= 0)
        num = num + 1;
    end
end