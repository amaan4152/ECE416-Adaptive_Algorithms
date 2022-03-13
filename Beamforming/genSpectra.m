function [MVDR, MUSIC] = genSpectra(theta, phi, r, R, Pn)
    M = size(r, 1);
    aoa = [cosd(phi).*sind(theta); ...
           sind(phi).*sind(theta); ...
           cosd(theta);];
    k = 2 * pi * aoa;
    s = exp(-1j * r * k) / sqrt(M);
    MVDR = 10*log10(1 / abs(s' * R^(-1) * s));
    MUSIC = 10*log10(1 / abs(s' * Pn * s));
end