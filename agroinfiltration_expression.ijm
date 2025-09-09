// Agroinfiltration efficiency & expression yields
// Segments fluorescent infiltration spots on a leaf image
// Measures area, mean intensity, integrated density per spot
// Outputs per-spot table + total expression yield

// User options 
minSize   = getNumber("Minimum spot size (px^2):", 200);
blurSigma = getNumber("Gaussian blur sigma (0 = none):", 2);
threshMethod = getString("Threshold method (Yen, Otsu, Moments):", "Yen");

// Choose output folder
outDir = getDirectory("Choose output folder");

// Prep image 
origTitle = getTitle();
run("Duplicate...", "title=work");

// Optional blur
if (blurSigma > 0) {
    selectWindow("work");
    run("Gaussian Blur...", "sigma=" + blurSigma);
}

// Threshold & mask 
setAutoThreshold(threshMethod + " dark");
setOption("BlackBackground", false);
run("Convert to Mask");

// Clean up
run("Options...", "iterations=2 count=1 black do=Open");
run("Fill Holes");
run("Make Binary");

// Analyze spots 
run("Set Measurements...", "area mean min centroid perimeter shape integrated redirect=work decimal=3 add");
run("Analyze Particles...", "size=" + minSize + "-Infinity show=Nothing display exclude add clear");

n = roiManager("count");
if (n == 0) exit("No spots detected. Try different thresholding.");

// Total expression 
run("Clear Results");
sumArea = 0;
sumIntDen = 0;
for (i = 0; i < n; i++) {
    roiManager("Select", i);
    run("Measure");
    area = getResult("Area", i);
    intDen = getResult("IntDen", i);
    sumArea += area;
    sumIntDen += intDen;
}

// Append summary row
setResult("Spot_ID", n, "TOTAL");
setResult("Area", n, sumArea);
setResult("IntDen", n, sumIntDen);
updateResults();

// Save outputs 
base = File.nameWithoutExtension;
saveAs("Results", outDir + base + "_agro_spots.csv");
roiManager("Save", outDir + base + "_agro_spots_rois.zip");

// Optional overlay
roiManager("Show All with labels");
saveAs("PNG", outDir + base + "_agro_overlay.png");

// Summary text
summaryPath = outDir + base + "_agro_summary.txt";
File.saveString("", summaryPath);
File.append("Image: " + origTitle, summaryPath);
File.append("Detected spots: " + n, summaryPath);
File.append("Total expression (IntDen): " + sumIntDen, summaryPath);

print("Agroinfiltration analysis complete.");
