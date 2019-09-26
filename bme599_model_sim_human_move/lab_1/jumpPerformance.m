function jumpPerformance(bodyKinematicsFilename, forceReporterFilename)
% Purpose:  This function reads a Body Kinematics position file containing
%           the center of mass position and a Force Reporter file
%           containing joint limiter forces (i.e., ligament forces)
%
% Input:    bodyKinematicsFilename is the name of the Body Kinematics
%           position file ('character array') 
%
%           forceReporterFilename is the name of the Force Reporter file
%           ('character array') 
%
% Output:   command window output of jump performance with the following 
%           format:
%
%				ligament penalty = 
%				jump height = 
%				overall performance = 

% Read Body Kinematics position and Force Reporter files
kinematics = read_motionFile(bodyKinematicsFilename);
forces = read_motionFile(forceReporterFilename);

% Compute the jump height for the center of mass above the standing height
% of 0.9633 m

% Define time and center of mass label columns
kinematicTimeCol = find(strcmp(kinematics.labels, 'time'));
comYCol = find(strcmp(kinematics.labels, 'center_of_mass_Y'));

% Define time and center of mass data arrays
kinematicTime = kinematics.data(:, kinematicTimeCol);
comY = kinematics.data(:, comYCol);

% Compute the center of mass height above the standing height
height = comY - 0.9633;

% Determine the maximum height
[maxHeightValue, maxHeightInd] = max(height);

% Define the time and height values at the maximum
jumpTime = kinematicTime(maxHeightInd);
jumpHeight = maxHeightValue;

% Compute the ligament penalty function as the weighted integral for the
% sum of squared joint limiter torques (see Anderson and Pandy, 1999)

% Define the time and joint limiter columns
forceTimeCol = find(strcmp(forces.labels, 'time'));
lumbarCol = find(strcmp(forces.labels, 'LumbarExtensionLimit'));
rightKneeCol = find(strcmp(forces.labels, 'KneeLimit_r'));
leftKneeCol = find(strcmp(forces.labels, 'KneeLimit_l'));

% Define the time
forceTime = forces.data(:, forceTimeCol);

% Define joint limiter data arrays for the to reach the maximum height
cropInd = find(forceTime<jumpTime);
forceTime = forceTime(cropInd);
lumbarLimitTorque = forces.data(cropInd, lumbarCol);
rightKneeLimitTorque = forces.data(cropInd, rightKneeCol);
leftKneeLimitTorque = forces.data(cropInd, leftKneeCol);

% Compute the weighted integral for the sum of squared joint limiter 
% torques
weight = 0.001;
sumSquaredLimitTorques = lumbarLimitTorque.^2 + rightKneeLimitTorque.^2 + leftKneeLimitTorque.^2;
numIntegral = trapz(forceTime, sumSquaredLimitTorques);

% Define the ligament penalty
ligamentPenalty = weight*numIntegral;

% Compute the overall performance of jump height minus the ligament penalty
overallPerformance = jumpHeight - ligamentPenalty;

% Display the performance results
disp(['ligament penalty = ' num2str(ligamentPenalty)])
disp(['jump height = ' num2str(jumpHeight)])
disp(['overall performance = ' num2str(overallPerformance)])

% End of jumpPerformance.m