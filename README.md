# Molecular Farming Analysis

Open-source analysis workflows for **molecular farming** experiments.  
This repository provides reproducible tools to quantify infiltration efficiency, expression yields, purification balance, QC gels/westerns, and more.

## Repository structure

molecular-farming-analysis/
├─ agroinfiltration_expression/ # Fiji macros for infiltration spot segmentation & yield quantification
├─ gel_western_densitometry/ # Fiji macros for SDS-PAGE / Western blot band quantification
├─ elisa_plate_analysis/ # Scripts for ELISA curve fitting & concentration interpolation (R/Python)
├─ purification_mass_balance/ # Templates for process yields & recovery tracking
├─ lcms_quant/ # LC–MS quantification templates
├─ vector_design/ # Plasmid maps & design notes
├─ sample_data/ # Small test images & plate reader files
├─ LICENSE
├─ CITATION.cff
└─ README.md # (this file)

##  Workflows included

### Fiji (ImageJ macros)
- **Agroinfiltration efficiency & expression yields**  
  Segment infiltration spots from fluorescence images, measure area and integrated density, and compute total yield.  

- **QC gels / Western blot densitometry**  
  Quantify SDS-PAGE or Western blot band intensities with background correction and per-band statistics.  

### R scripts
- **ELISA plate analysis**  
  Import plate reader CSV, fit standard curve (4PL/linear), interpolate concentrations, and export tidy tables.  

- **Purification mass balance**  
  Track protein yields across each purification step, calculate recovery %, and export reports.  

- **LC–MS quantification**  
  Template workflows for parsing instrument exports, peak integration, and normalization against internal standards.  

### Documentation
- **Vector design**  
  Store annotated plasmid maps (`.gb`, `.dna`, `.fasta`) and cloning templates.  


##Sample data
Example input files are included in [`sample_data/`](sample_data/) for quick testing:
- Demo TIFF images for agroinfiltration analysis  
- Example gel/Western blot images  
- Sample ELISA plate reader export (CSV)  
- Mock purification balance table  

## Quick start

- **Fiji macros**:  
  Open Fiji → `Plugins → Macros → Run…` → select `.ijm` file.  
- **ELISA & mass balance scripts**:  
  Run R scripts with `Rscript elisa_plate_analysis/elisa.R`  

## Citation

If you use these workflows in research, please cite this repository.  
 See [`CITATION.cff`](CITATION.cff)


## License

Open source under the [MIT](LICENSE) (or BSD-3-Clause) license.  
Free to use, modify, and distribute with attribution.
