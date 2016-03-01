function mask = MSC2mask(MSC, imXmax, imYmax)
% MSC2MASK Use a Morse-Smale complex structure to construct a binary mask
% image.
% 
% USAGE: mask = MSC2mask( MSC, imXmax, imYmax )
%             = MSC2mask( MSC )
%
% INPUT: MSC - Morse-Smale complex parsed from PARSENDSKL
%               (NB: MSC coordinates are XY-inverted)
%        imXmax, imYmax - dimension of mask, if not provided, will use MSC
%                coordinates
%
% OUTPUT: mask - binary image mask

X = {MSC.Filaments.X}; Y = {MSC.Filaments.Y};
X = [X{:}]; Y = [Y{:}];

X = round(X); Y = round(Y);

% Use coordinates as max dimensions
if nargin < 2,
    imXmax = max(Y); imYmax = max(X);
end

% Make sure no indices are off-dimension
X( X > imYmax ) = imYmax; Y( Y > imXmax ) = imXmax;
X( X < 1 ) = 1; Y( Y < 1 ) = 1;

% Construct binary mask
mask = false(imXmax, imYmax);
for i = 1:numel(X)
    mask( imXmax - Y(i) +1, X(i) ) = true;
end

end