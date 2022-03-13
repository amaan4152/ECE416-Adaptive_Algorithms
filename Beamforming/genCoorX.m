function [R, Rhat] = genCoorX(K, S, A, Bpower, Vpower)
    [M, ~] = size(S);
    Vvar = 10^(Vpower/10);
    Rbeta = diag(10.^(Bpower/10));
    R = S*Rbeta*S' + Vvar*eye(M);
    Rhat = 1/K * (A * A');
end