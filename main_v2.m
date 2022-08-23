%% main_v2 uses fucntions for calculating the premise and defuzzification
clc; clear;

%% Sensor Values
d = 0.885;
delD = -0.245;

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
premise = Premise(d, delD);

%% Defuzzification
[wL, wR] = defuzzify(premise, ruleBase_LeftWheel, ruleBase_RightWheel);
