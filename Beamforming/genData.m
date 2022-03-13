function [A, S] = genData(N, AOA, r, Bpower, Vpower)
    M = size(r, 1);
    L = size(AOA, 1);
   
    % matrix of steering vectors for N snapshots
    S = genSteering(AOA, r);
    B = sqrt(diag(10.^(Bpower/10))) * randn(L, N);
    V = sqrt((10^(Vpower/10))) * randn(M, N);
    % source signals ~ 0-mean white guassian
    B = zeros(L, N);
    for i = 1:L
        Cb = 10.^(Bpower(i)/10) * eye(N, N);
        Cbsqr = (chol(Cb))';
        B(i, :) = Cbsqr/sqrt(2) * (randn(N, 1) + 1j*randn(N, 1));
    end
    
    % 0-mean guassian white noise
    Cv = 10.^(Vpower/10) * eye(M, M);
    Cvsqr = (chol(Cv))';
    V = Cvsqr/sqrt(2) * (randn(M, N) + 1j*randn(M, N));
    
    A = S*B + V;
end
