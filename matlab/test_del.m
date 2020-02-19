n = 6336;
period = 66;

load('matlab.mat')
H = zeros(n/period, n);
row = 1;

for row_square=1:n
    while any(and(H(row, :), H_square(row_square, :)))
        temp = H_square(row_square, :);
        H_square(row_square, :) = H_square(period*row + 1, :);
        H_square(period*row + 1:end - 1, :) = H_square(period*row + 2:end, :);
        H_square(end, :) = temp;
    end
    H(row, :) = mod(H(row, :) + H_square(row_square, :),2);
    row = row + (mod(row_square, period) == 0);
end

A = int8(H_square);
rank = 0;
for col=1:n
    oneRows = find(A(:,col)==1);
    if length(oneRows)>0
        rank = rank+1;
        for row=oneRows(length(oneRows):-1:1)'
            A(row,col:n) = xor(A(row,col:n), A(oneRows(1),col:n));
        end
    end
end

print('rank = %d',rank);