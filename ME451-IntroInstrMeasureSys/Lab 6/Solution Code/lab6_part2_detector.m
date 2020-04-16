%Lab 6 Part 2: Using trained detector to find stop signs

signDetector = vision.CascadeObjectDetector('stopSignDetector.xml');

image = imread('7.jpg');

bbox = step(signDetector,image);

detectedImage = insertObjectAnnotation(image,'rectangle',bbox,'stop sign');

figure,imshow(detectedImage);