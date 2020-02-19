% Author:  David Varodayan (varodayan@stanford.edu)
% Date:    May 9, 2006

addpath('./ldpca');
addpath('./ladder_files');

n = 396;                            % blocklength
ladderFile = '6336_regDeg3.lad';     % regular degree 3 codes
pCrossover = 0.11;                  % BSC crossover probability for virtual correlation channel

% Data to send
X = double(rand(1, n)>0.5);

% Generating accumulated syndrome for data X using ladderFile
accumSyndrome = encodeBitsMatlab(X, ladderFile);

% Generating side information assuming Binary Symmetric Correlation Channel
sideinfo_BSC = mod(X + double( rand(1, n)<pCrossover ), 2);


pCond = (1-pCrossover).*(1-sideinfo_BSC) + pCrossover.*sideinfo_BSC; % P(source=0|sideinfo)
LLR_intrinsic = log( pCond./(1-pCond) ); % log( P(source=0|sideinfo)/P(source=1|sideinfo) )

[decoded, rate, numErrors] = decodeBitsMatlab( LLR_intrinsic, accumSyndrome, X, ladderFile );