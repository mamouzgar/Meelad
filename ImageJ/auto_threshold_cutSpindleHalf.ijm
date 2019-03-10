// Measuring spindle half densities (MTs in GFP[#2] channel)

dir = getDirectory("Choose Dir_in Directory ");

Get_Out = getDirectory("Choose Get Out Directory ");


/////////////////////////////////////////////////////////////////////////
//Create the list of files in the folder "dir"
Filelist = getFileList(dir);
///////////////////////////////////////////////////////////////////
//Initialisation of a counter
b=1;
Lim=Filelist.length;
///////////////////////////////////////////////////////////////////////////////
//Loop inside the list

for(a=0; a<Filelist.length; a++)
{

//printing the counter

	print("Counter", b, "sur", Lim);

//get the name of the file to open

	FileIn =Filelist[a];

//create a path

	path=dir+"\\"+ FileIn;

//open the file
	
	run("Bio-Formats", "open=path color_mode=Default view=Hyperstack stack_order=XYCZT");

	name = File.name;


////////////////////////////

// set image scale parameters: scope #2 = 0.0657 um
// Check the following parameters in Set Measurements: AREA and INTEGRATED DENSITY and DISPLAY LABEL and FERET'S DIAMETER
// 

run 

// rotate image/spindle to horizontal axis 
macro "Rotate Image" {
  requires("1.33o");
  run("Select None");
  roiManager("Show None");
  nROIs = roiManager("count");
  for (row=0; row<nROIs; row++){
      x1 = getResult("FeretX", row);
	  y1 = getResult("FeretY", row);
	  x2 = getResult("X", row);
	  y2 = getResult("Y", row);
	  drawLine(x1, y1, x2, y2);
      if (x1==-1)
           exit("This macro requires a straight line selection");
      angle = (180.0/PI)*atan2(y1-y2, x2-x1);
      run("Arbitrarily...", "angle="+angle+" interpolate");
}

// setup thresholding 
macro "identify spindle" {
	im = getTitle();
	selectWindow(im);
	run("Duplicate...", "duplicate channels=2");
	run("Z Project...", "projection=[Sum Slices]");
	setAutoThreshold("Default dark no-reset");
	run("Threshold...");
	run("Analyze Particles...", "display exclude include add");
}
	
// extract spindle ROIs
macro "RoI" {
	nROIs = roiManager("count");
	for (i=0; i<nROIs; i++){
		roiManager("Select", i);
		label = name+i;
		print(label);
		roiManager("Rename", label);	
		saveAs("selection", "C:/Users/meela/Desktop/Batch processing test/Outdirectory/" + label + ".roi");
		}
}
		

		
//divides current roi into left and right half 
macro "divide roi [F2]"{ 
        run("Clear Results"); 
        roiManager("Reset"); 
        run("Add to Manager"); 
        roiManager("Select", 0); 
        getSelectionBounds(x, y, width, height) 
        getRawStatistics(totalArea); 
        minOff = 1e9; 
        for (w=1; w < width; w++){ 
                roiManager("Select", 0); 
                setKeyDown("alt"); 
                makeRectangle(x, y, w, height); 
                getRawStatistics(rightArea); 
                off = abs(2*rightArea - totalArea); 
                if (off < minOff){ 
                        minOff = off; 
                        xHalf = x + w; 
                        wHalf = w; 
                        halfArea = rightArea; 
                } 
        } 

        //Display result: 
        roiManager("Select", 0); 
        setKeyDown("alt"); 
        makeRectangle(x, y, wHalf, height); 
        run("Copy");//work around 
        run("Add to Manager"); 
        run("Measure"); 
        wait(500); 
        roiManager("Select", 0); 
        setKeyDown("alt"); 
        makeRectangle(x+wHalf, y, width - wHalf, height); 
        run("Copy");//work around 
        run("Add to Manager"); 
        run("Measure"); 
} 

// delete ROIs	
run("Select All");
roiManager("Deselect");
roiManager("Delete");
run("Close All");	


// code for measuring backgorund: idea --> convert to 8-iit, get background intesntity, then save that for each spindle roi so we can clean later
/*
run("8-bit");
setAutoThreshold("Default dark no-reset");
getThreshold(lower, upper);


percentage = 0.95;
target = (1-percentage)*getWidth()*getHeight();
nBins = 256;
getHistogram(values,counts,nBins);
sum = 0; threshold = -1;
for(i=0; i<nBins; i++){
    sum += counts[i];
    if( (sum >= target) & (threshold < 0) ){ 
    	threshold = i; 
    	}
}
setThreshold(0,threshold);


*/
////////////////////////////
b=b+1;

}

// save appended results to a csv file named output.csv 
selectWindow("Results");
saveAs("Results", "C:/Users/meela/Desktop/Batch processing test/output.csv");

exit()




