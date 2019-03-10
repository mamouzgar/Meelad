Python code that parses through timeseries data, extracts the pixel positions that correspond to the object in the image (ie, a spindle), sums those positions to identify the spindle width at each timepoint, and plots a regression line for spindle width vs time in compression experiments.
Results.csv is generated from ImageJ. To extract the result.csv file for each movie from ImageJ, 
draw a linescan across the object at the first timepoint and use ImageJ functions to track the spindle width at each following timepoints. 
This generates an intensity value at each pixel along the line, which also includes noise that does not correspond to spindle width.
The python code will use the pixel intensity values to detect only values that correspond to spindle structure, extract those distances,
then plot the total spindle width over time.
ImageJ macro function to perform the line scan and extract that data will be added later.

