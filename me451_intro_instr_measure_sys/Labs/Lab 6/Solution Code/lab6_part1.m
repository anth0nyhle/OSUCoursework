%Lab 6 Computer Vision

%Part 1: Detecting faces using Viola Jones Algorithm

%reads in photo from file change for new file names
image = imread('3.jpg');

%creates detection function using the default 'FrontalFaceCART' to detect
%forward facing, upright faces
faceDetector = vision.CascadeObjectDetector;

%Access function and to set up a box around the face
bbox = faceDetector(image);

%Draws a box around the detected face
imageFaces = insertObjectAnnotation(image, 'rectangle', bbox, 'Face');

%Displays image with faces boxed
figure,imshow(imageFaces)