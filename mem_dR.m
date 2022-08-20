%% Membership Function for dR
function dR = mem_dR(d)
dR(5) = 0;

dR(1) = trimf(d,[0 0 0.25]);
dR(2) = trimf(d,[0 0.25 0.5]);
dR(3) = trimf(d,[0.25 0.5 0.75]);
dR(4) = trimf(d,[0.5 0.75 1]);
dR(5) = trimf(d,[0.75 1 1]);

if d >= 1
    dR = [0, 0, 0, 0, 1];
% elseif d < 0
%     dR = [0, 0, 0, 0, 0];
end

end