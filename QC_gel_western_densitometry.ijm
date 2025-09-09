// QC gel / Western blot densitometry
// Semi-automated band quantification
// User defines rectangular ROIs around bands, macro measures intensity and subtracts local background

//  Instructions 
// 1. Open gel or blot image (16-bit recommended).
// 2. Manually draw ROIs for each band using the rectangle tool.
// 3. Add each ROI to ROI Manager (Analyze → Tools → ROI Manager).
// 4. Run this macro. It will:
//    - Duplicate each ROI
//    - Measure mean and integrated density
//    - Estimate background using a nearby region
//    - Subtract background
//    - Export tidy table

//  User options 
bgOffset = getNumber("Background offset (px up/down from each band ROI):", 20);
bgHeight = getNumber("Background ROI height (px):", 10);

// Choose output folder
outDir = getDirectory("Choose output folder");
origTitle = getTitle();

//  Prep 
n = roiManager("count");
if (n == 0) exit("No ROIs in ROI Manager. Draw band rectangles first.");

// Clear Results
run("Clear Results");
run("Set Measurements...", "mean integrated area redirect=None decimal=6 add");

//  Loop bands 
for (i = 0; i < n; i++) {
    roiManager("Select", i);
    name = roiManager("Get Name", i);
    if (name == "") name = "band_" + IJ.pad(i+1, 3);

    // Measure band
    run("Measure");
    bandMean = getResult("Mean", i);
    bandIntDen = getResult("IntDen", i);
    bandArea = getResult("Area", i);

    // Get ROI bounds
    getSelectionBounds(x, y, w, h);

    // Define background ROI just below current band
    makeRectangle(x, y+bgOffset, w, bgHeight);
    run("Measure");
    bgMean = getResult("Mean", nResults-1);
    bgIntDen = getResult("IntDen", nResults-1);
    run("Delete Row", "row=" + (nResults-1)); // remove background-only row

    // Background-corrected values
    corrMean = bandMean - bgMean;
    corrIntDen = bandIntDen - bgMean * bandArea;

    // Save tidy row
    setResult("Band_ID", i, name);
    setResult("RawMean", i, bandMean);
    setResult("RawIntDen", i, bandIntDen);
    setResult("BgMean", i, bgMean);
    setResult("CorrMean", i, corrMean);
    setResult("CorrIntDen", i, corrIntDen);
    updateResults();
}

//  Save outputs 
base = File.nameWithoutExtension;
saveAs("Results", outDir + base + "_gel_densitometry.csv");
roiManager("Save", outDir + base + "_gel_rois.zip");

print("Gel densitometry complete. Results saved.");
