Python code that parses through timeseries data and plots a regression line for spindle width vs time in compression experiments.
Results.csv is generated from ImageJ. To extract the result.csv file for each movie from ImageJ, 
draw a linescan across the object at the first timepoint and track the spindle width at each following timepoints. 
This generates an intensity value at each pixel along the line, which also includes noise that does not correspond to spindle width.
The python code will use the pixel intensity values to detect only values that correspond to spindle structure, extract those distances,
then plot the total spindle width over time.

