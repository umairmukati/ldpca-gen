% Author:  David Varodayan (varodayan@stanford.edu)
% Date:    May 8, 2006

function peg2lad1( pegFile, ladFile )

tic

numCodes = 108;
period = 109;
% txSeq = [39,19,29,9,35,15,25,5,33,13,23,3,37,17,27,7,31,11,21,1,38,18,28,8,34,14,24,4,32,12,22,2,36,16,26,6,30,10,20];
% txSeq = [64, 32, 48, 16, 56, 24, 40, 8, 60, 28, 44, 12, 52, 20, 36, 4, 62, 30, 46, 14, 54, 22, 38, 6, 58, 26, 42, 10, 50, 18, 34, 2, 63, 31, 47, 15, 55, 23, 39, 7, 59, 27, 43, 11, 51, 19, 35, 3, 61, 29, 45, 13, 53, 21, 37, 5, 57, 25, 41, 9, 49, 17, 33, 1];
txSeq = [109, 54, 81, 27, 99, 45, 72, 18, 90, 36, 63, 9, 105, 51, 78, 24, 96, 42, 69, 15, 87, 33, 60, 6, 102, 48, 75, 21, 93, 39, 66, 12, 84, 30, 57, 3, 107, 53, 80, 26, 98, 44, 71, 17, 89, 35, 62, 8, 104, 50, 77, 23, 95, 41, 68, 14, 86, 32, 59, 5, 101, 47, 74, 20, 92, 38, 65, 11, 83, 29, 56, 2, 106, 52, 79, 25, 97, 43, 70, 16, 88, 34, 61, 7, 103, 49, 76, 22, 94, 40, 67, 13, 85, 31, 58, 4, 100, 46, 73, 19, 91, 37, 64, 10, 82, 28, 55, 1, 108];
% txSeq = reshape([txSeq+period/2; txSeq], 1, period);
% txSeq is the order in which samples of accumulated syndrome are transmitted

%loop until full rank H_square is generated
while 1
    fid = fopen( pegFile, 'r' );
    n = fscanf(fid, '%d', 1);
    m = fscanf(fid, '%d', 1);
    maxDegree = fscanf(fid, '%d', 1);

    expansion = n./m;

    H_square = zeros(n, n);

    for i=1:m
        oneLocations = fscanf(fid, '%d', maxDegree)';
        oneLocations = oneLocations(find(oneLocations));
        degree = length(oneLocations);
        oneLocations = oneLocations(randperm(degree));

        for j=1:expansion
            locationSubset = oneLocations( round((j-1)./expansion.*degree)+1:round(j./expansion.*degree) );
            H_square( (i-1).*expansion+j, locationSubset ) = 1;
        end
    end

    fclose(fid);

    H_square = H_square(:, randperm(n));

    % check whether H_square is full rank in GF(2)
    A = int8(H_square);
    rank = 0;
    for col=1:n
        oneRows = find(A(:,col)==1);
        if ~isempty(oneRows)
            rank = rank+1;
            for row=oneRows(length(oneRows):-1:1)'
                A(row,col:n) = xor(A(row,col:n), A(oneRows(1),col:n));
            end
        end
    end
    
    toc

    if length(unique(sum(H_square,2))) == 1 && length(unique(sum(H_square,1))) == 1
        if rank==n
            break;
        end
    end
end

clear A

fid = fopen(ladFile, 'w');

fprintf(fid, '%d ', [numCodes n sum(sum(H_square)) period]);

jc = [0 full(cumsum(sum(H_square)))];
fprintf(fid, '\n');
fprintf(fid, '%d ', jc);


for code=period-numCodes+1:period
    H = zeros(n/period*code, n);

    row = 1;
    txSubseq = mod(txSeq(1:code), period);
    for row_square=1:n
        H(row, :) = H(row, :) + H_square(row_square, :);
        row = row + ismember( mod(row_square, period), txSubseq );
    end

    fprintf(fid, '\n');
    fprintf(fid, '%d ', code);

    fprintf(fid, '\n');
    fprintf(fid, '%d ', sort(txSeq(1:code))-1);

    ir = mod(find(H)-1, n/period*code);
    fprintf(fid, '\n');
    fprintf(fid, '%d ', ir);

    code
    toc
    
    clear H
end

fclose(fid);