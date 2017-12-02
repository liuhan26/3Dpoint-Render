function [c] = DIVDIF(x,f)

% function [c] = DIVDIF(x,f)
%
% INPUT:  x   St�tzstellen (Spaltenvektor) 
%         f   Werte an den St�tzstellen (Spaltenvektor)
%
% OUTPUT: c   dividierte Differenzen (Spaltenvektor)
%
% Date:   2004-05-03
% Author: Stefan H�eber
% Email:  hueeber@ians.uni-stuttgart.de

n = length(x)-1;
c = f;
for i=1:n
	I = n:-1:i;
	c(I+1) = (c(I+1)-c(I)) ./ (x(I+1)-x(I-i+1));
end
  
  
  