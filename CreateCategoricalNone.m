function none = CreateCategoricalNone(N)
%CREATECATEGORICALNONE Summary of this function goes here

none = strings(N,1);

for n = 1:N
    none(n) = "NONE";
end

none = categorical(none);

return
end

