function seq = findseq(n)

factors = factor(n);

level = cell(1,length(factors));

vector = n;

seq = n;

for i = 1:length(factors)
   
    [vector,new_elements] = veclinspace(vector,factors(i));
    
    seq = [seq arrangesequence(seq, vector(new_elements), factors(i))];
    
end

end

function [out,new_elements] = veclinspace(vector,elements)

vector = [0 vector];
out = [];

for i = 1:length(vector)-1
    temp = linspace(vector(i),vector(i+1),elements+1);
    out = [out temp(2:end)];
end

vector = vector(2:end);

new_elements = ~ismember(out, vector);
end

function seq = arrangesequence(vector, new_vector, factors)
seq = [];
for f = 1:factors-1
    for i = 1:length(vector)
        val = max(new_vector(new_vector < vector(i)));
        seq = [seq val];
        new_vector(new_vector == val) = [];
    end
end
end
