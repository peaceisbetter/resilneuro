# created by Jack Manning on 2/28/2024
# Purpose: create timing files for task-based scans during the Sternberg task
# for the resiliency project. The timing files need to be in FSL's 3-column format:
# onset, duration, parametric modulation

rm(list=ls())

# ---- Set paths ----
base_path <- "E:/TAMU/ResiliencyR3"
codes <- file.path(base_path, "Codes")
condpath <- file.path(base_path, "Data/Cond")

# BIDS folder
bids_path <- file.path(base_path, "Data/bids_new")

# ---- Get subjects ----
dirs <- list.dirs(path = bids_path, full.names = TRUE, recursive = FALSE)
dirs <- dirs[!grepl("\\.heudiconv", dirs)]  # remove non-subject folders
subs <- basename(dirs)  # simple way to get subject names

# ---- Loop through subjects ----
for (p in seq_along(dirs)) {
  currsub <- subs[p]
  cat("Processing subject:", currsub, "\n")
  
  # Make output directory if it doesn't exist
  out_dir <- file.path(condpath, currsub)
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
  
  # List event files
  event_files <- list.files(path = file.path(dirs[p], "ses-yeartwo/func"),
                            pattern = "STERN.*events",
                            full.names = TRUE)
  
  if (length(event_files) == 0) {
    warning("No event files found for ", currsub)
    next
  }
  
  # ---- Loop through event files ----
  for (event_file in event_files) {
    file_data <- read.delim(event_file, sep = "\t", stringsAsFactors = FALSE)
    file_data$trial_type <- as.character(file_data$trial_type)
    
    cat("  Processing file:", basename(event_file), "\n")
    
    # ---- Create parametric modulation ----
    # rest = 0, low/medium/high = 1
    file_data$strength <- ifelse(file_data$trial_type == "rest", 0, 1)
    
    # ---- Write single-row files for each trial ----
    for (k in seq_len(nrow(file_data))) {
      row <- file_data[k, ]
      trial_file <- file.path(out_dir,
                              paste0("block-", k, "_trial-", row$trial_type, "_", basename(event_file)))
      write.table(row[c("onset", "duration", "strength")],
                  file = trial_file,
                  sep = "\t",
                  row.names = FALSE,
                  col.names = FALSE)
    }
    
    # ---- Write full file with all trials ----
    write.table(file_data[, c("onset", "duration", "strength")],
                file = file.path(out_dir, basename(event_file)),
                sep = "\t",
                row.names = FALSE,
                col.names = FALSE)
  }
}


