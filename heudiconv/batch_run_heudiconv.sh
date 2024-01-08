#!/bin/bash

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=batch_heudiconv         #Set the job name to "batch_heudiconv"
#SBATCH --time=48:00:00                    #Set the wall clock limit to 48hr
#SBATCH --nodes=1                          #Request 1 node
#SBATCH --ntasks-per-node=16               #Request 16 tasks/cores per node
#SBATCH --mem=200G                         #Request 200GB per node. Max on Grace is 360
#SBATCH --output=batch_hediconv.%j         #Send stdout/err to "batch_heudiconv.[jobID]" 

##OPTIONAL JOB SPECIFICATIONS
#SBATCH --mail-type=ALL                    #Send email on all job events
#SBATCH --mail-user=jackpmanning@tamu.edu    #Send all emails to email_address 

# Create an object to store the file path to the dicom files on the scratch directory
dicom=$SCRATCH/resr3/dicom

# Create an object to store the file path to the heudiconv singularity file
heudiconv=$SCRATCH/software/heudiconv_latest.sif

# Loop through all subject folders
for subject in "$dicom"/*; do
    # Check if it's a directory
    if [ -d "$subject" ]; then
        echo "Processing subject folder: $subject"

        ithsubject=$(basename "$subject")
        dicom_path="/parent/dicom/$ithsubject"

        echo "ithsubject: $ithsubject"

        # Run the heudiconv singularity container to convert the data from dcm to nii and put it into bids format
        # singularity run -B $SCRATCH/resr3:/parent ${heudiconv} --files basename "${subject}" -o /parent/bids -s basename "${subject}" -c dcm2niix -b -f /parent/codes/myheuristic.py
        singularity run -B $SCRATCH/resr3:/parent ${heudiconv} --files "$dicom_path" -o /parent/bids -s "$ithsubject" -c dcm2niix -b -f /parent/codes/myheuristic.py

        echo "Done processing $subject"
    fi
done

echo "Script completed."
