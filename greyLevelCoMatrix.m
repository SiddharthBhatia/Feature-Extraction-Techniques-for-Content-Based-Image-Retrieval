function textureFeatures = greyLevelCoMatrix(image)

%I = rgb2gray(imread(filename));
glcm = graycomatrix(image);
stats = graycoprops(glcm);
display(stats);
textureFeatures=[stats.Contrast stats.Correlation stats.Energy stats.Homogeneity];

end
