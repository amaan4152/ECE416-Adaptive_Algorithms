function lms(r, AOA, Bpower, Vpower, N, g, mu)
    % L = 1, g = 1 for MVDR beamformer
    [M, ~] = size(AOA);
    L = 1;
    g = 1;
    
    [A, C] = genData(N, AOA, r, Bpower, Vpower);
    [R, ~] = genCoorX(N, C, A, Bpower, Vpower);
    
    [U, ~, ~] = svd(A);
    Ul = U(:, 1:L);
    Ps = Ul * Ul';
    Pn = eye(size(Ps)) - Ps;
    
    aoa = num2cell(nonzeros(g' .* AOA));
    [theta, phi] = aoa{:};
    [MVDR_0, ~] = genSpectra(theta, phi, r, R, Pn);
    
    wq = C * (C' * C)^(-1) * g;
    Ca = null(C');
    wa = zeros(M - L, 1); 
    for i = 2:N
        
    end
end