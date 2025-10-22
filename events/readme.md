# Events Subdirectory – Resiliency Project

This subdirectory contains scripts to process **PsychoPy output files** and generate **event timing files** for use in **FSL**. These files are required for modeling task-based fMRI data.

---

## Purpose

- Convert raw PsychoPy output into properly formatted event files for FSL.
- Output files follow **FSL’s 3-column format**:
  1. **Onset** – start time of each event (in seconds)  
  2. **Duration** – length of each event (in seconds)  
  3. **Parametric modulation** – numeric value representing task condition  

---

## Scripts

There are two main R scripts (note: the file names are not ideal):

1. **`make_events_tsv.R`**  
   - Reads PsychoPy output files.  
   - Prepares initial event tables with trial types, onsets, and durations.

2. **`make_events_tsv_FSL.R`**  
   - Converts the output of `make_events_tsv.R` to FSL-compatible files.  
   - Adds the **parametric modulation** column.  
   - Creates both subject-level and trial-level event files for FSL.

---

## Recommended Workflow

1. Run `make_events_tsv.R` to generate the initial event tables.  
2. Run `make_events_tsv_FSL.R` to convert these tables to FSL-compatible timing files.

---

## Notes

- Ensure that PsychoPy output files are located in the correct directory before running the scripts.  
- Output files will be saved in the `Cond` folder within the project directory.  
- Scripts require **R >= 4.0** and standard packages (e.g., `read.delim` for reading tab-delimited files).

