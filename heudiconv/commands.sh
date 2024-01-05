# generate a heuristic file
docker run --rm -it `
-v ~\Documents\Jack Manning Professional\amberbrain:/data:ro `
-v ~\Documents\Jack Manning Professional\amberbrain\BIDS:/output `
nipy/heudiconv `
-d /data/DICOM/*.dcm `
-f convertall `
-c none `
-o /output

# run with edited heuristic file
docker run --rm -it \
-v ~/Documents\Jack Manning Professional\amberbrain:/data:ro \
-v ~/Documents\Jack Manning Professional\amberbrain\BIDS:/output \
nipy/heudiconv:latest \
-d /data/DICOM/*.dcm \


# amber brain
docker run --rm -it `
-v "C:\Users\jackpmanning\OneDrive - Texas A&M University\Documents\Jack Manning Professional\amberbrain\DICOM:/data:ro" `
-v "C:\Users\jackpmanning\OneDrive - Texas A&M University\Documents\Jack Manning Professional\amberbrain\BIDS:/output" `
nipy/heudiconv `
-d /data/DICOM/*.dcm `
-f convertall `
-c none `
-o /output


# amber's brain
C:\Users\jackpmanning\OneDrive - Texas A&M University\Documents\Jack Manning Professional\amberbrain
# amber's brain
docker run --rm -it `
-v "C:\Users\jackpmanning\OneDrive - Texas A&M University\Documents\Jack Manning Professional\amberbrain\DICOM:/data:ro" `
-v "C:\Users\jackpmanning\OneDrive - Texas A&M University\Documents\Jack Manning Professional\amberbrain\BIDS:/output" `
nipy/heudiconv:latest `
-d /data/*.dcm `
-f convertall `
-c none `
-o /output






# Resiliency S206 brain
docker run --rm -it `
-v "C:\Users\jackpmanning\OneDrive - Texas A&M University\Documents\Projects\Resiliency R3 Study\Data\MRI:/data:ro" `
-v "C:\Users\jackpmanning\OneDrive - Texas A&M University\Documents\Projects\Resiliency R3 Study\Data\MRI\BIDS:/output" `
nipy/heudiconv:latest `
-d "/data/{subject}/{session}/DICOM/*.dcm" `
-s S206
-ss ses-01
-f convertall `
-c none `
-o /output

C:\Users\jackpmanning\OneDrive - Texas A&M University\Documents\Projects\Resiliency R3 Study\Data\MRI

C:\Users\jackpmanning\Documents\Resiliency R3 Study\Data\MRI




# https://heudiconv.readthedocs.io/en/latest/tutorials.html
# Resiliency S206 brain - creatre heuristic file
docker run --rm -it -v \Users\jackpmanning\Documents\Resiliency R3 Study\Data\MRI:/data:ro nipy/heudiconv -d "/data/DICOM/{subject}/{session}/DICOM/*/DICOM/*.dcm" -f convertall -s S206 -ss ses-01 -c none









