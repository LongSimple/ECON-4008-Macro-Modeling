function [Z,P] = tauchen(rho, sigma_e, Nz, mu, s)

% Z : grid point of shock process
% P : Transition prob. matrix
% rho : persistence of shock process
% Nz : number of grid 
% mu : mean of Z
% s : coverage

sigma = sigma_e^2/(1-rho^2);
sigma = sigma^(1/2);

z1 = mu - s*sigma;  
zNz = -z1;
w = (zNz-z1)/(Nz-1);

% construct Z vector
Z = linspace(z1,zNz,Nz);

for i = 1:Nz
    for j = 1:Nz
      Z0(i,j) = Z(j) - rho*Z(i) + w/2;
      Z1(i,j) = Z(j) - rho*Z(i) - w/2;
    end
end


% find transition prob. matrix

P = zeros(Nz,Nz);

P = normcdf(Z0, mu , sigma_e) - normcdf(Z1, mu , sigma_e);        
P(:,1) =  normcdf(Z0(:,1), mu , sigma_e);
P(:,Nz) =  1 - normcdf(Z1(:,Nz), mu , sigma_e);
end