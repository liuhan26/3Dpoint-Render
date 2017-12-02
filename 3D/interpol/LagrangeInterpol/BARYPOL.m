function [Pix] = BARYPOL(wj,xi,fi,x)

% function [Pix] = BARYPOL(wj,x)
%
% INPUT:  wj  baryzentrische Gewichte   
%         x   Auswertungspunkte
%
% OUTPUT: Pix Wert des Lagrangeschen 
%             Interpolationspolynom an den Stellen x
%
% Date:   2007-10-22
% Author: Stefan Hüeber
% Email:  hueeber@ians.uni-stuttgart.de

n = length(wj)-1;
numer = zeros(size(x));
denom = zeros(size(x));
exact = zeros(size(x));
for j=1:n+1
	xdiff = x - xi(j);
	temp = wj(j)./xdiff;
	numer = numer + temp*fi(j);
	denom = denom + temp;
	exact(xdiff==0) = j;
end	
Pix = numer./denom;
ind = find(exact);
Pix(ind) = fi(exact(ind));	