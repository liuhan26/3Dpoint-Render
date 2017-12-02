function [F] = SPALTEN_AITKEN_NEVILLE(x,f,y)

% function [F] = SPALTEN_AITKEN_NEVILLE(x,f,y)
%
% INPUT:  x   St�tzstellen (Spaltenvektor) 
%         f   Werte an den St�tzstellen (Spaltenvektor)
%         y   Auswertungspunkt
%
% OUTPUT: F   dividierte Differenzen der letzten Schr�gzeile
%             (Spaltenvektor) mit F(1) = P(y)
%
% Date:   2004-05-04
% Author: Stefan H�eber
% Email:  hueeber@ians.uni-stuttgart.de

n = length(x)-1;
y = y*ones(n+1,1);

for i=1:n
	I = 1:n-i+1;
	f(I)=f(I+1)+((y(I+i)-x(I+i))./(x(I+i)-x(I))).*(f(I+1)-f(I));
end
F = f;