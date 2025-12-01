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
## Data Dictionary

| Column Name              | Type        | Description                                                                                   | Units / Notes |
|--------------------------|-------------|-----------------------------------------------------------------------------------------------|---------------|
| `date`                   | Date        | Date of the longline set (converted from set_begin_datetime).                                | YYYY-MM-DD    |
| `year`                   | Numeric     | Year of the longline set.                                                                    |               |
| `month`                  | Factor      | Month of the longline set (abbreviated).                                                     | Jan–Dec       |
| `set_type`               | Character   | Longline type: **DSLL** (deep-set) or **SSLL** (shallow-set).                                |               |
| `species`                | Character   | Scientific name of species caught.                                                           |               |
| `lon_bin`                | Numeric     | 5° longitudinal bin ID (0–360).                                                              | degrees       |
| `lat_bin`                | Numeric     | 5° latitudinal bin ID.                                                                       | degrees       |
| `lon_ctr`                | Numeric     | Longitude of bin center.                                                                     | degrees       |
| `lat_ctr`                | Numeric     | Latitude of bin center.                                                                      | degrees       |
| `n_perm`                 | Integer     | Number of unique permits in the bin (used for confidentiality filtering).                    | ≥3 retained   |
| `catch_count`            | Numeric     | Total number of individuals caught of the selected species for that set/bin.                 | count         |
| `num_hks_set`            | Integer     | Number of hooks deployed for that longline set.                                              | hooks         |
| `cpue`                   | Numeric     | Catch per unit effort: `(catch_count / num_hks_set) * 1000`.                                 | fish / 1000 hooks |
| `sst`                    | Numeric     | Sea surface temperature.                                                                     | °C            |
| `sss`                    | Numeric     | Sea surface salinity.                                                                        | PSU           |
| `ssh`                    | Numeric     | Sea surface height anomaly or absolute SSH depending on source.                              | meters        |
| `mld`                    | Numeric     | Mixed layer depth.                                                                           | meters        |
| `chl_cop`                | Numeric     | Chlorophyll-a concentration from Copernicus.                                                 | mg/m³         |
| `u`                      | Numeric     | Zonal (east–west) surface current component.                                                 | m/s           |
| `v`                      | Numeric     | Meridional (north–south) surface current component.                                          | m/s           |
| `rugosity`               | Numeric     | Seafloor roughness index from bathymetry.                                                    | unitless      |
| `current_speed`          | Numeric     | Total surface current magnitude: √(u² + v²).                                                 | m/s           |
| `lunar_rad`              | Numeric     | Lunar illumination at time of set (0–?? scale based on model).                              | unitless      |
| `ssh_sd`                 | Numeric     | Daily standard deviation of SSH around set location (environmental variability metric).      | meters        |
| `sss_sd`                 | Numeric     | Standard deviation of SSS.                                                                   | PSU           |
| `sst_sd`                 | Numeric     | Standard deviation of SST.                                                                   | °C            |
| `oxy300`                 | Numeric     | Dissolved oxygen at **300 m** depth.                                                         | µmol/kg       |
| `oxy150`                 | Numeric     | Dissolved oxygen at **150 m** depth.                                                         | µmol/kg       |
| `temp300`                | Numeric     | Temperature at **300 m** depth.                                                              | °C            |
| `temp150`                | Numeric     | Temperature at **150 m** depth.                                                              | °C            |
| `sla`                    | Numeric     | Sea level anomaly.                                                                           | meters        |
| `o2`                     | Numeric     | Depth-averaged or subsurface O₂ (depending on pairing script).                               | µmol/kg       |
| `hks_per_flt`            | Integer     | Hooks per float (gear configuration variable).                                               | hooks/float   |
| `fltln_len`              | Numeric     | Float line length.                                                                           | meters        |
| `brnchln_len`            | Numeric     | Branchline length.                                                                           | meters        |
| `bait_code_val`          | Character   | Type of bait used (categorical).                                                             | categorical   |
| `brnchln_mat_code_val`   | Character   | Branchline material (e.g., monofilament, wire).                                              | categorical   |
| `ldr_mat_code_val`       | Character   | Leader material (e.g., wire vs mono).                                                        | categorical   |


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

