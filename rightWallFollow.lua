-- Lua code for uploading to the differential drive robot in CoppeliaSim or V-REP

-- Fuzzy controller for following a wall on the right of a differential drive mobile robot

-- Triangular Membership Function
function trimf(x, a, b, c)

    if x <= a then
        activation = 0
    elseif (x >= a) and (x <= b) then
        activation = (x - a) / (b - a)
    elseif (x >= b) and (x <= c) then
        activation = (c - x) / (c - b)
    elseif x >= c then
        activation = 0
    end

    return activation

end

-- Membership Function for dR
function mem_dR(d)
    dR = {}

    dR[1] = trimf(d, 0, 0, 0.25)
    dR[2] = trimf(d, 0, 0.25, 0.5)
    dR[3] = trimf(d, 0.25, 0.5, 0.75)
    dR[4] = trimf(d, 0.5, 0.75, 1)
    dR[5] = trimf(d, 0.75, 1, 1)

    if d >= 1 then
        dR = { 0, 0, 0, 0, 1 }
    end

    return dR

end

-- Membership Function for del_dR
function mem_del_dR(d)
    del_dR = {}

    del_dR[1] = trimf(d, -0.5, -0.5, -0.25)
    del_dR[2] = trimf(d, -0.5, -0.25, 0)
    del_dR[3] = trimf(d, -0.25, 0, 0.25)
    del_dR[4] = trimf(d, 0, 0.25, 0.5)
    del_dR[5] = trimf(d, 0.25, 0.5, 0.5)

    if d >= 0.5 then
        del_dR = { 0, 0, 0, 0, 1 }
    elseif d <= -0.5 then
        del_dR = { 1, 0, 0, 0, 0 };
    end

    return del_dR

end

function sysCall_threadmain()

    sensor = {}

    leftAndRightMotorHandles = { sim.getObjectHandle('KJunior_motorLeft'), sim.getObjectHandle('KJunior_motorRight') }

    for i = 1, 12 do
        sensor[i] = sim.getObjectHandle('Proximity_sensor' .. i)
    end

    sim.setJointTargetVelocity(leftAndRightMotorHandles[1], 20)
    sim.setJointTargetVelocity(leftAndRightMotorHandles[2], 20)

    -- Right Wheel Rule Base
    local ruleBase_RightWheel = { { 10, 15, 20, 25, 30 },
        { 15, 20, 30, 35, 30 },
        { 30, 30, 40, 35, 30 },
        { 30, 35, 30, 25, 15 },
        { 25, 30, 20, 15, 10 } }

    -- Left Wheel Rule Base
    local ruleBase_LeftWheel = { { 0, 5, 10, 15, 20 },
        { 5, 10, 20, 25, 30 },
        { 15, 20, 40, 40, 40 },
        { 15, 25, 40, 35, 30 },
        { 10, 15, 30, 30, 25 } }

    d = 0.5
    delD = 0

    sensorDetection = {}
    sensorDistance = { 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5 }

    while sim.getSimulationState() ~= sim.simulation_advancing_abouttostop do

        for i = 2, 4 do
            result, distance = sim.readProximitySensor(sensor[i])
            if (result > 0) then
                sensorDistance[i] = distance
            end
        end

        print("Sensor 2: ", sensorDistance[2], "\tSensor 3: ", sensorDistance[3], "\t\tSensor 4: ", sensorDistance[4])

        d = sensorDistance[3]

        print('d = ', d, '\tdel_d = ', delD)

        delD = sensorDistance[2] - sensorDistance[4]

        -- Premise
        a = mem_dR(d);
        b = mem_del_dR(delD);

        premise = {}

        for i = 1, 5 do
            premise[i] = {}
            for j = 1, 5 do
                premise[i][j] = math.min(a[i], b[j])
            end
        end

        -- Calculating area
        area = {}

        width = 10;
        for i = 1, 5 do
            area[i] = {}
            for j = 1, 5 do
                area[i][j] = width * (premise[i][j] - ((premise[i][j]) ^ 2) / 2);
            end
        end

        -- Defuzzification
        num_L = 0.0;
        den_L = 0.0;
        num_R = 0.0;
        den_R = 0.0;

        for i = 1, 5 do
            for j = 1, 5 do
                num_L = num_L + area[i][j] * ruleBase_LeftWheel[i][j];
                num_R = num_R + area[i][j] * ruleBase_RightWheel[i][j];
                den_L = den_L + area[i][j];
                den_R = den_R + area[i][j];
            end
        end

        wL = num_L / den_L
        wR = num_R / den_R


        -- Printing Velocities
        print("\nwL = ", wL, "\twR = ", wR)

        sim.setJointTargetVelocity(leftAndRightMotorHandles[1], wL)
        sim.setJointTargetVelocity(leftAndRightMotorHandles[2], wR)

        sim.switchThread()

    end
end
