%Lab 6: Computer Vision
%Part 2: Training stop sign detector

load('stopSignsAndCars.mat');
positiveInstances = stopSignsAndCars(:,1:2);
imageDir = fullfile(matlabroot, 'toolbox','vision','visiondata','stopSignImages');
addpath(imageDir);

negativeFolder = fullfile(matlabroot, 'toolbox', 'vision', 'visiondata', 'nonStopSigns');

negativeImages = imageDatastore(negativeFolder);

trainCascadeObjectDetector('stopSignDetector.xml',positiveInstances, negativeFolder, 'FalseAlarmRate',0.1, 'NumCascadeStages',5);
