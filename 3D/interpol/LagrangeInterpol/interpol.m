clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% method = 1: Aitken-Neville
%          2: Dividierte Differenzen und Horner-Schema
%          3: Baryzentrische Darstellung nach
%             Berrut und Trefethen
method = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funktion
fun = inline('1.0./(1.0+25.0*x.^2)');
% Interpolationsordnung
n = 100;
% Anzahl St�tzstellen f�r Fehlerberechnung
nplot = 1e+04;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Auswertungspunkte und Funktionswerte
x = linspace(-1,1,nplot)';
fx = feval(fun,x);

% Tschebyscheff St�tzstellen 
xi = cos(((2*(0:n)+1)./(2*n+2))*pi);
% Funktionswerte an St�tzstellen
fi = fun(xi);

tic
switch method
 case 1
	% Aitken-Neville
	for i=1:nplot
		F = SPALTEN_AITKEN_NEVILLE(xi',fi',x(i));
		Pix(i) = F(1);
	end
 case 2
	% Dividierte Differenzen
	c = DIVDIF(xi',fi');
	% Interpolationspolynom mit Horner-Schema
	Pix = HORNER(c,xi',x');
 case 3
	% Baryzentrische Gewichte
	wj = BARYWEIGHTS(xi);
	% Interpolationspolynom
	Pix = BARYPOL(wj,xi,fi,x);	
end
time = toc;

switch method
 case 1
	display(['  Aitken-Neville:                      time = ',num2str(time)]);
 case 2
	display(['  Dividierte Differenzen und Horner:   time = ',num2str(time)]);
 case 3
	display(['  Baryzentrische Darstellung:          time = ',num2str(time)]);
end

figure(1);
hold on; box on;
plot(x,Pix,'r-','LineWidth',3);
plot(x,fx,'b--','LineWidth',2);
plot(xi,fi,'ro','LineWidth',3,'MarkerFaceColor','r');
%legend(['\pi_{',num2str(n),'}(x)'],'f(x)',3);
set(gca,'Fontsize',16);
switch method
 case 1
	title('Aitken-Neville');
 case 2
	title('Div. Diff. und Horner');
 case 3
	title('Baryzentrische Darstellung');
end
