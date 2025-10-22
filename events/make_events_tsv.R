# This script is used to read in files from a bids compliant directory and
# create events.tsv files from psychopy data 

# clear the workspace
rm(list=ls())

# create directory variables
par_dir <- "E:/TAMU/ResiliencyR3/Data/sternberg/year-two"
sub_dir <- "E:/TAMU/ResiliencyR3/Data/bids_new/sub-"

# setwd into parent dir
setwd(par_dir)


# create a vector with all of the subject ids
subject_folders <- list.dirs(getwd(), full.names = FALSE, recursive = FALSE)

# Remove ".heudiconv" from the list
# subject_folders[!grepl("\\.heudiconv", subject_folders)]

#_______________________________________________________________________________
# For loop will start here
for (j in seq_along(subject_folders)) {
  
  # setwd into folder
  setwd(subject_folders[j])
  message("We are in directory: ", getwd())
  
  # pull subject number from current subject folder as a char
  subid <- gsub(".+?(\\d{3})$", "\\1", subject_folders[j])
  
  # find the subject_id_sternberg.txt file (it is not the file that is just called 'sternberg.txt')
  files <- list.files(getwd(), full.names = FALSE)
  pattern <- paste0(subid, ".*sternberg.txt")
  sternfile <- grep(pattern, files, value = TRUE, ignore.case = TRUE)
  message("Sternfile is: ", sternfile)
  
  # robust read: convert "[]" and empty strings to NA, allow ragged rows, trim whitespace
  stern <- read.delim(sternfile,
                      sep = "\t",
                      header = TRUE,
                      skip = 1,
                      na.strings = c("[]", "", "NA"),
                      fill = TRUE,
                      strip.white = TRUE,
                      comment.char = "")
  
  # ---------- Remove rows where the ONLY non-empty column is block.duration ----------
  if ("block.duration" %in% names(stern)) {
    other_cols <- setdiff(names(stern), "block.duration")
    rows_only_blockdur <- apply(stern[, other_cols, drop = FALSE], 1,
                                function(r) all(is.na(r) | r == ""))
    # drop those rows
    if (any(rows_only_blockdur)) {
      message("Dropping ", sum(rows_only_blockdur), " block-duration-only rows.")
      stern <- stern[!rows_only_blockdur, , drop = FALSE]
    }
    # optional: drop the column now if you don't want it later
    stern <- stern[, !names(stern) %in% "block.duration", drop = FALSE]
  }
  
  # ensure letterset is character
  stern$letterset <- as.character(stern$letterset)
  
  # label load
  stern$chload <- nchar(stern$letterset)
  stern$load <- NA_character_
  stern$load[stern$chload == 1]  <- "low"
  stern$load[stern$chload == 9]  <- "medium"
  stern$load[stern$chload == 13] <- "high"
  
  # Replace any remaining NA loads with "unknown" (optional)
  stern$load[is.na(stern$load)] <- "unknown"
  
  # ---------- Build trial vector: one entry per block change ----------
  trial <- character(0)
  blocklast <- NA  # keep track of last non-NA block value
  
  # iterate rows; skip rows where block is NA
  for (i in seq_len(nrow(stern))) {
    block <- stern$block[i]
    
    # if block is NA, skip this row (prevents comparing NA in 'if')
    if (is.na(block) || block == "") next
    
    # when block changes (including first valid block), append its load
    if (is.na(blocklast) || block != blocklast) {
      trial <- c(trial, stern$load[i])
      blocklast <- block
    }
  }
  
  message("Detected trial loads: ", paste(trial, collapse = ", "))
  
  # check we have at least 9 trials (3 runs x 3 blocks) - adjust as needed
  if (length(trial) < 9) {
    warning("Expected at least 9 block-start loads in 'trial' but found ", length(trial),
            ". Check the stern file structure for missing block markers.")
    # You can choose to next to skip subject or try to continue
    # next
  }
  
  # ---------- Make events tibbles/data.frames for three runs ----------
  # If trial has >9, take first 9; if <9 pad with "unknown"
  if (length(trial) < 9) trial <- c(trial, rep("unknown", 9 - length(trial)))
  trial9 <- trial[1:9]
  
  events_t1 <- data.frame(
    onset = c(0, 42, 62, 104, 124, 166),
    duration = c(42, 20, 42, 20, 42, 20),
    trial_type = c(trial9[1], "rest", trial9[2], "rest", trial9[3], "rest"),
    stringsAsFactors = FALSE
  )
  
  events_t2 <- data.frame(
    onset = c(0, 42, 62, 104, 124, 166),
    duration = c(42, 20, 42, 20, 42, 20),
    trial_type = c(trial9[4], "rest", trial9[5], "rest", trial9[6], "rest"),
    stringsAsFactors = FALSE
  )
  
  events_t3 <- data.frame(
    onset = c(0, 42, 62, 104, 124, 166),
    duration = c(42, 20, 42, 20, 42, 20),
    trial_type = c(trial9[7], "rest", trial9[8], "rest", trial9[9], "rest"),
    stringsAsFactors = FALSE
  )
  
  # ---------- Write events files to BIDS func directory ----------
  funcdir <- file.path(paste0(sub_dir, subid, "/ses-yeartwo/func"))
  if (!dir.exists(funcdir)) {
    warning("func directory not found: ", funcdir)
    # optionally next to skip writing for this subject
    # next
  } else {
    # setwd to the funcdir
    setwd(funcdir)
    
    task_events_filename_run1 <- paste0("sub-", subid, "_task-STERN_dir-AP_run-1_events.tsv")
    write.table(events_t1, file = task_events_filename_run1, sep = "\t", row.names = FALSE, quote = FALSE)
    message("File written to: ", file.path(funcdir, task_events_filename_run1))
    
    task_events_filename_run2 <- paste0("sub-", subid, "_task-STERN_dir-AP_run-2_events.tsv")
    write.table(events_t2, file = task_events_filename_run2, sep = "\t", row.names = FALSE, quote = FALSE)
    message("File written to: ", file.path(funcdir, task_events_filename_run2))
    
    task_events_filename_run3 <- paste0("sub-", subid, "_task-STERN_dir-AP_run-3_events.tsv")
    write.table(events_t3, file = task_events_filename_run3, sep = "\t", row.names = FALSE, quote = FALSE)
    message("File written to: ", file.path(funcdir, task_events_filename_run3))
    
    # restore working dir to parent (par_dir from your original script)
    setwd(par_dir)
  }
} # end subject loop
