%% Membership Function for del_dR
function del_dR = mem_del_dR(del_d)
del_dR(5) = 0;

del_dR(1) = trimf(del_d,[-0.5 -0.5 -0.25]);
del_dR(2) = trimf(del_d,[-0.5 -0.25 0]);
del_dR(3) = trimf(del_d,[-0.25 0 0.25]);
del_dR(4) = trimf(del_d,[0 0.25 0.5]);
del_dR(5) = trimf(del_d,[0.25 0.5 0.5]);

if del_d >= 0.5
    del_dR = [0, 0, 0, 0, 1];
elseif del_d <= -0.5
    del_dR = [1, 0, 0, 0, 0];
end

end