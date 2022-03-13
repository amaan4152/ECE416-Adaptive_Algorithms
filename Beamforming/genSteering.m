function S = genSteering(AOA, r)
    %
    % Requirements:
    %   - AOA = vector of AOAs
    %   - r = vector of sensor positions in terms of d/lambda
    %   - dims(AOA) = (L, 2)
    %   - dims(r) = (M, 3)
    %
    M = size(r, 1);
    L = size(AOA, 1);
    S = zeros(M, L);
    for i = 1:L
        theta = AOA(i, 1);
        phi = AOA(i, 2);
        
        % Angle of Arrival vector
        a = [cosd(phi).*sind(theta); ...
             sind(phi).*sind(theta); ...
             cosd(theta);];
        k = 2 * pi * a; 
        S(:, i) = exp(-1j * r * k)/sqrt(M);
    end
end
