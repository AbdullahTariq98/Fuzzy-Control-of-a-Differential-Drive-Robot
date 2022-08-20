function [wL, wR] = defuzzify(premise, ruleBase_LeftWheel, ruleBase_RightWheel)

num_L = 0.0;
den_L = 0.0;
num_R = 0.0;
den_R = 0.0;

for i = 1:5
    for j = 1:5
        num_L = num_L + premise(i,j) * ruleBase_LeftWheel(i,j);
        num_R = num_R + premise(i,j) * ruleBase_RightWheel(i,j);
        den_L = den_L + premise(i,j);
        den_R = den_R + premise(i,j);
    end
end

wL = num_L / den_L;
wR = num_R / den_R;

end