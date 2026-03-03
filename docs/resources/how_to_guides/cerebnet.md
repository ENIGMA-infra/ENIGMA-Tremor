# Welcome to the ENIGMA CerebNet guidelines!

## Prerequisites
This guide assumes that you have:

- [installed Nipoppy and organized your data in BIDS](./setting_up_nipoppy.md)
- [Apptainer available as container platform](../open_science_tools/container_platforms.md)

## Setup
We will apply the cerebellum segmentation functionalities for [FastSurfer](https://www.sciencedirect.com/science/article/pii/S1053811920304985?via%3Dihub) and [Cerebnet](https://www.sciencedirect.com/science/article/pii/S1053811922008242?via%3Dihub) segmentation, a pipeline that has been developed by the ENIGMA-Ataxia working group. The original workflow can be found [here](https://hub.docker.com/r/phwegner/enigma). You can pull the CerebNet container in the following way:

1. Create a cerebnet folder in the nipoppy container directory and enter:
```bash
cd /path/to/your/nipoppy/datasets/your_cohort/containers
mkdir cerebnet
cd cerebnet
```
2. Pull the CerebNet container with Docker or Apptainer/Singularity. Make sure your system meets the requirements of FastSUrfer/Freesurfer. We recommend at least 16GB of RAM and 4 CPUs. FastSurfer will use a GPU when available. 
```bash
docker pull phwegner/enigma:latest
```
or 
```bash
singularity pull docker://phwegner/enigma:latest
```

3. The application expects the all T1w nifti files in the same input folder:
base_folder
```bash
|----input  
|        |----sub-001_T1w.nii.gz
|        |----sub-002_T1w.nii.gz
|        |----...
|
```
Therefore we will create symlinks of the existing nifti files in the BIDS-folder to meet the input structure. Store [this script](https://github.com/ENIGMA-infra/ENIGMA-Tremor/blob/main/docs/resources/how_to_guides/prepare_input_cerebnet.sh) in your ```bash datasets/your_cohort/code folder ``` and make it executable by running ```bash chmod +x datasets/your_cohort/code folder/prepare_input_cerebnet.sh```. In addition, you have to adjust the following lines in the prepare_input_cerebnet.sh script to point to your directories:
```bash
BASE=/path/to/your/nipoppy/datasets	#your cohort directory e.g. /home/datasets
BIDS=${BASE}/your_cohort/bids	#your cohort bids directory e.g. ${BASE}/Amsterdam/bids
DEST=${BASE}/your_cohort/derivatives/cerebnet/input 	#your cerebnet input directory e.g. ${BASE}/Amsterdam/derivatives/cerebnet/input
```

## Before you run the pipeline
Prior to segmentation using this container, images should be checked for artefacts and quality. Artefacts or lesions that influence brain anatomy, and images with visible motion artefact (e.g., ripples in the T1w image) should be noted, although not necessarily immediately excluded unless severe. These images will require close visual QC after segmentation.

Note that retrocerebellar arachnoid cysts are a common incidental finding in the general population. Although these are (unlikely) to be pathogenic, when large they will compress the cerebellum and result in non-representative volume estimates. Currently, we don’t have specific advice about how large is too large, but if there is clear deformation of the structure of the cerebellum, then these images should be excluded.

## Run the pipeline
Next, we will run the pipeline using Docker or Apptainer/Singularity, depending on your system:

Docker
```bash
docker run -it --rm --user $(id -u):$(id -g) -v <YOUR_SUBJECTS_BASE_DIR>:/subjects_indir -v <YOUR_FS_LICENSE>:/license.txt phwegner/enigma
```
Example for Docker:
```bash
docker run -it --rm --user $(id -u):$(id -g) -v /home/datasets/Amsterdam/derivatives/cerebnet:/subjects_indir -v /home/software/freesurfer/license.txt:/license.txt phwegner/enigma
```

Singularity
```bash
singularity run -B <YOUR_SUBJECTS_BASE_DIR>:/subjects_indir -B <YOUR_FS_LICENSE>:/license.txt --pwd /fastsurfer <YOUR_CEREBNET_CONTAINER_DIR>/enigma_latest.sif
```
Example for Singularity:
```bash
singularity run -B /home/datasets/Amsterdam/derivatives/cerebnet:/subjects_indir -B /home/software/freesurfer/license.txt:/license.txt --pwd /fastsurfer /home/datasets/Amsterdam/containers/cerebnet/enigma_latest.sif
```

If you get an error of the form: 'permission denied bash entrypoint.sh', replace the run command with: 
```bash
singularity exec -B <YOUR_SUBJECTS_BASE_DIR>:/subjects_indir -B <YOUR_FS_LICENSE>:/license.txt --pwd /fastsurfer <YOUR_CEREBNET_CONTAINER_DIR>/enigma_latest.sif /app/scripts/main.sh
```

## Generated output and quality control
After running the container, the ‘outputs’ folder will contain a QC website (called ‘index.html’, in the ‘qc_webpage’ folder) and a file that flags potentially problematic scans (‘classifier_out_bad_scans.txt’). 

1. Open the html file using a web browser, and examine each image segmentation to confirm alignment with the anatomical image. For label reference, below image from the original [Cerebnet article](https://www.sciencedirect.com/science/article/pii/S1053811922008242?via%3Dihub) can be used, and the segmentation can be loaded in an image viewer (see step 2). All images should be examined, not just those identified as bad scans. Extra scrutiny should be given to the bad scans and those flagged upon first visual inspection for motion or other artifacts.

<img width="704" height="145" alt="cerebnet_labels" src="https://github.com/user-attachments/assets/9a37624a-7846-4971-9957-0dc1384e8517" />


On some systems, QC images may appear distorted (see example below). This does not indicate a segmentation failure but rather seems to be a rendering issue. Unfortunately, we have not yet identified the underlying cause. If you encounter this problem, please proceed to the next step to evaluate the segmentations.

<img width="256" height="256" alt="3" src="https://github.com/user-attachments/assets/cec71511-d98d-4692-9642-79e169cc5f66" />

2. If in doubt, the segmentations should be loaded in an image viewer (e.g., freeview, FSLeyes, etc) and examined more closely. If the segmentations look accurate, the scan can be retained; otherwise, the scan should be marked for exclusion from subsequent analysis. Please create a copy of outputs/volumes_all.csv as outputs/volumes_all_qc.csv and enter "NA" for specific labels that failed or "NA" for all labels when the complete segmentation failed.

Example using freeview: run the following for the subject (adjust paths accordingly). The most recent FreeSurferColorLUT.txt lookup table file that has all cerebellum labels can be downloaded [here](https://github.com/Deep-MI/FastSurfer/blob/dev/FastSurferCNN/config/FreeSurferColorLUT.txt) and then saved in the code folder (on the same level as prepare_input_cerebnet.sh).
```bash
freeview \
<base_dir>/fastsurfer/<subject_folder>/mri/orig/001.mgz \
<subject_folder>/fastsurfer/<subject_folder>/mri/cerebellum.CerebNet.nii.gz:colormap=lut:lut=</home/datasets/your_cohort/code/>FreeSurferColorLUT.txt:opacity=0.4
```

<img width="1847" height="995" alt="freeview_cerebnet_qc" src="https://github.com/user-attachments/assets/73162cc4-190f-42b1-a668-623f3d20fdf7" />

3. If you're still unsure about the QC process and determining inclusion/exclusion, please reach out!

## Troubleshooting
For any issues and questions, please contact Max Laansma (m.laansma@amsterdamumc.nl)

### Known issues
If you get any permission error, make sure your base_folder is readable and writable by your user.

If you abort a run or it fails, clean the input directory. That means ensuring that your base_folder only holds the input directory and no other subfolders or intermediates generated by prior runs.

If you run the pipeline as a SLURM job, make sure that your job has enough memory allocated we recommend at least 16GB.

## Finish
You made it! The final step is to share the send_to_dzne.zip and the volumes_all_qc.csv with the central repository. Please refer to step 4 on the [project webpage](https://enigma-infra.github.io/ENIGMA-Tremor/projects/ongoing/Cortical_Subcortical_Cerebellum_Morphology_Project/) for instructions.
