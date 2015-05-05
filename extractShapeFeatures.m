function [shapeFeatures image] = extractShapeFeatures(image)

tempImage=image;
image = rgb2hsv(image);
h = image(:, :, 1);
s = image(:, :, 2);
v = image(:, :, 3);
BW = im2bw(v,0.4);
BW = imfill(BW,'holes');

%figure;
%subplot(2,2,1);
%imshow(h);
%subplot(2,2,2);
%imshow(s);
pi=3.14;

[areas,parameter,majorAxis,minorAxis]=MeasureBlobs(BW);
BW2 = bwareaopen(BW,max(areas));
[areas,parameter,majorAxis,minorAxis]=MeasureBlobs(BW2);


mask_three_chan = repmat(BW2, [1, 1, 3]);
% Apply Mask
tempImage(~mask_three_chan) = 0;
imshow(tempImage);
image=tempImage;
circularity= (4*pi*max(areas))/(max(parameter)*max(parameter));


display(max(areas));
display(max(parameter));
display(max(majorAxis));
display(max(minorAxis));


shapeFeatures=[max(majorAxis),max(minorAxis) ,circularity];
%BW2 = bwareaopen(BW,max(areas));

%subplot(2,2,3);
%imshow(BW2);
% Create 3 channel mask
%mask_three_chan = repmat(BW2, [1, 1, 3]);

% Apply Mask
%I(~mask_three_chan) = 0;
%subplot(2,2,4);
%imshow(I);


display(areas);
display(parameter);
display(majorAxis);
display(minorAxis);


end
%----------------------------------------------------------------------------
% Measure the mean intensity and area of each blob in each color band.
function [areas,parameter,majorAxis,minorAxis] = MeasureBlobs(maskImage)
	[labeledImage numberOfBlobs] = bwlabel(maskImage, 8);     % Label each blob so we can make measurements of it
	if numberOfBlobs == 0
		% Didn't detect any yellow blobs in this image.
		
		areas = 0;
        parameter=0;
        majorAxis=0;
        minorAxis=0;
		return;
	end
	% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
	blobMeasurementsR = regionprops(labeledImage, 'area','Perimeter','MajorAxisLength','MinorAxisLength');   
	% Now assign the areas.
    
	areas = zeros(numberOfBlobs, 1);  % One row for each blob.  One column for each color.
	areas(:,1) = [blobMeasurementsR.Area]';
	
    
    parameter = zeros(numberOfBlobs,1);  % One row for each blob.  One column for each color.
	parameter(:,1) = [blobMeasurementsR.Perimeter]';

     
    majorAxis = zeros(numberOfBlobs, 1);  % One row for each blob.  One column for each color.
	majorAxis(:,1) = [blobMeasurementsR.MajorAxisLength]';

    
    minorAxis = zeros(numberOfBlobs, 1);  % One row for each blob.  One column for each color.
	minorAxis(:,1) = [blobMeasurementsR.MinorAxisLength]';

    
    

	return; % from MeasureBlobs()
end