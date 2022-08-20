%% main_v3 does the defuzzification by calculating the area
clc; clear;

%% Sensor Values
d = 0.5;
delD = 0;

%% Right Wheel Rule Base
ruleBase_RightWheel = [  10, 15, 20, 25, 30;
                        15, 20, 30, 35, 30;
                        30, 30, 40, 35, 30;
                        30, 35, 30, 25, 15;
                        25, 30, 20, 15, 10  ];

%% Left Wheel Rule Base
ruleBase_LeftWheel = [ 0, 5, 10, 15, 20;
                        5, 10, 20, 25, 30;
                        15, 20, 40, 40, 40;
                        15, 25, 40, 35, 30;
                        10, 15, 30, 30, 25 ];


%% Premise
a = mem_dR(d);
b = mem_del_dR(delD);

premise = zeros(5,5);

for i = 1:5
    for j = 1:5
%         a = mem_dR(d);
%         b = mem_del_dR(d);
        premise(i,j) = min(a(i),b(j));
    end
end

%% Calculating area of the trapezoid
area = zeros(5,5);

width = 10;
for i = 1:5
    for j=1:5
        area(i,j)= width * (premise(i,j) - ( (premise(i,j))^2) / 2);
    end
end

%% Defuzzification
num_L = 0.0;
den_L = 0.0;
num_R = 0.0;
den_R = 0.0;

for i = 1:5
    for j = 1:5
        num_L = num_L + area(i,j) * ruleBase_LeftWheel(i,j);
        num_R = num_R + area(i,j) * ruleBase_RightWheel(i,j);
        den_L = den_L + area(i,j);
        den_R = den_R + area(i,j);
    end
end

wL = num_L / den_L
wR = num_R / den_R