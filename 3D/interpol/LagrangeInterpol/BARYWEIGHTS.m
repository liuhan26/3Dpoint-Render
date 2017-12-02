function w = BARYWEIGHTS(x)

% function [w] = BARYWEIGHTS(x)
%
% INPUT:  x   St~tzstellen (Zeilenvektor)
%
% OUTPUT: w   baryzentrische Gewichte
%
% Date:   2007-10-22
% Author: Stefan H~eber
% Email:  hueeber@ians.uni-stuttgart.de

n = length(x)-1;
w(1) = 1;
for j=1:n
  w = w .* (x(1:j)-x(j+1)*ones(1,j));
	w(j+1) = prod(x(j+1)*ones(1,j)-x(1:j));
end
w = 1./w;