# Kintigh-Final-Project

# [Hawaiʻi Longline Multispecies CPUE Explorer](https://ikintigh.shinyapps.io/hawaii-longline-cpue-explorer/)  
### Final Project – OCN 682 
**Created by: Isabella Kintigh**  
**Date: November 2025**

---

## Project Description

This project develops an interactive Shiny application that visualizes how environmental drivers shape multispecies catch-per-unit-effort (CPUE) patterns in the Hawaiʻi deep set longline fishery. Using observer data paired with oceanographic variables, the app allows users to explore how CPUE varies across space, time, and environmental gradients for bigeye tuna and multiple billfish species.

The data were aggregated into 5×5° spatial bins to meet confidentiality requirements and paired with daily satellite- and model-derived environmental predictors.

---

## Purpose

**The purpose of this project is to build an interactive Shiny application that visualizes how environmental conditions shape multispecies CPUE patterns in the Hawaiʻi deep set longline fishery.**

This tool supports exploratory data analysis, hypothesis generation, spatial pattern recognition, and visual interpretation of key environmental relationships.

---

## Species Included

The app allows dynamic visualization for the following pelagic species:

- *Thunnus obesus* (Bigeye tuna)  
- *Makaira nigricans* (Blue marlin)  
- *Kajikia audax* (Striped marlin)  
- *Istiophorus platypterus* (Sailfish)  
- *Tetrapturus angustirostris* (Shortbill spearfish)  
- *Xiphias gladius* (Swordfish)

Species-specific images appear automatically upon selection.

---

## Environmental Variables

The following environmental predictors can be visualized:

- SST  
- SSS  
- SSH  
- Mixed Layer Depth  
- Chlorophyll-a  
- Ocean currents (U, V, current speed)  
- Rugosity  
- Lunar radiation  
- Variability metrics (SST SD, SSS SD, SSH SD)  
- Oxygen at 150 m and 300 m  
- Temperature at 150 m and 300 m  
- Sea level anomaly  
- Subsurface dissolved oxygen  

These variables are used in both spatial maps and environmental response plots.

---

## Application Features

The Shiny app contains **four main interactive components**:

### 1. **Spatial Environmental Map + CPUE Map**
Side-by-side maps displaying:
- environmental conditions (tile map)
- species-specific CPUE (tile map)

These update based on:
- species selection  
- year  
- month  
- chosen environmental variable  

---

### 2. **CPUE vs Environment Plot**
A functional relationship plot showing:
- CPUE vs a chosen environmental variable  
- per-species  
- with GAM smooth curves  
- using semi-transparent points

Ideal for identifying nonlinear environmental responses.

---

### 3. **Env × Env → CPUE Heatmap**
A response surface showing how CPUE varies across combinations of two environmental variables using midpoint bins.

---

### 4. **CPUE by Year × Month Heatmap**
A long-term temporal view that reveals:
- seasonality  
- interannual variability  
- possible shifts in catchability  

---

## Data Summary

- The dataset contains over **250,000 observations** spanning multiple species and years (2005–2024) from the NOAA observer program.  
- Records include set-level information: date, gear configuration, spatial coordinates, hook count, and catch.  
- All environmental variables were paired to longline sets using **daily averaged satellite- and model-derived rasters** from copernicus marine.  
- Data were aggregated into **5×5° spatial bins**, each with calculated bin centers (`lon_ctr`, `lat_ctr`).  
- Bins with fewer than **three unique permit numbers** were removed to meet confidentiality requirements.  
- CPUE was standardized as **catch per 1000 hooks** for consistency across sets.

---

## Contact 

If you have questions about this project or would like to learn more: 

**Isabella Kintigh**  
Graduate Student, Suca Lab, Biological Oceanography  
University of Hawaiʻi at Mānoa    
Email: *idavila@hawaii.edu*  

