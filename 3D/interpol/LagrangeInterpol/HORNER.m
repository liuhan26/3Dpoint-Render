function [p] = HORNER(c,x,y)

% function [p] = HORNER(c,x,y)
%
% INPUT:  c   dividierte Differenzen (Spaltenvektor)
%         x   Stützstellen (Spaltenvektor)
%         y   Auswerungspunkte (Spaltenvektor)
%
% OUTPUT: p   Werte des Interpolationspolynoms 
%             an den Auswertungspunkten y
%
% Date:   2004-05-03
% Author: Stefan Hüeber
% Email:  hueeber@ians.uni-stuttgart.de

n = length(x)-1;
p = c(n+1)*ones(size(y));
for k = n-1:-1:0
	p = c(k+1) + (y-x(k+1)).*p;
end

  