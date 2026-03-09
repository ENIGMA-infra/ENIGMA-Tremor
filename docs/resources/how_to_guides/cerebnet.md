# Welcome to the ENIGMA CerebNet guidelines!

## Overview

This protocol describes how to:

1. Prepare T1-weighted MRI scans for CerebNet segmentation  
2. Run the ENIGMA CerebNet container ([FastSurfer](https://www.sciencedirect.com/science/article/pii/S1053811920304985?via%3Dihub) + [Cerebnet](https://www.sciencedirect.com/science/article/pii/S1053811922008242?via%3Dihub))  
3. Perform quality control (QC)  
4. Prepare outputs for submission  

This workflow uses the [ENIGMA CerebNet container developed by the ENIGMA-Ataxia working group](https://hub.docker.com/r/phwegner/enigma).

---

## Prerequisites

Before starting, ensure that you have:

- [installed Nipoppy and organized your data in BIDS](./setting_up_nipoppy.md)
- [Apptainer available as container platform](../open_science_tools/container_platforms.md) 
- A valid FreeSurfer license file  
- Recommendation: 16 GB RAM and 4 CPUs available  

---

## Assumed Directory Structure

For clarity, we assume:

```
NIPOPPY_DATASET="/path/to/your/nipoppy/datasets/your_cohort"
```

Your dataset should follow:

```
${NIPOPPY_DATASET}/
├── bids/
├── derivatives/
├── containers/
└── code/
```

---

# 1. Setup the CerebNet Container
 #MAL ADJUST TO
Set up configuration
To get the Nipoppy specification files for the subsegmentation container, run:

nipoppy pipeline install --dataset <NIPOPPY_DATASET> 15877956 #ADJUST ID
Read more about this step here.

---

# 2. Prepare Input Data

The container expects all T1w NIfTI files in a single input folder:

```
derivatives/cerebnet/input/
├── sub-001_T1w.nii.gz
├── sub-002_T1w.nii.gz
└── ...
```

We recommend creating symlinks from your BIDS directory.

Download the helper script:

[prepare_input_cerebnet.sh](#LINK TO UPDATED CODE)

Place it in:

```
${NIPOPPY_DATASET}/code/
```

Make it executable:

```bash
chmod +x ${NIPOPPY_DATASET}/code/prepare_input_cerebnet.sh
```

Edit the script and adjust:

```bash
SESSION_ID="<session_id_without_prefix>"

NIPOPPY_DATASET="/path/to/your/nipoppy/datasets/your_cohort"
```

Then run the script. Symlinks of the T1w scans will be placed in `${DERIVATIVES_DIR}/cerebnet/${CEREBNET_VERSION}/ses-${SESSION_ID}/input`

---

# 3. Before Running the Pipeline

All T1w images must be visually inspected prior to segmentation.

Inspect for:

- Severe motion artefacts (e.g., ripples)
- Large lesions affecting cerebellar anatomy
- Strong deformation of the cerebellum

Retrocerebellar arachnoid cysts are common incidental findings. If large and clearly deforming cerebellar anatomy, exclude the scan from analysis.

Scans with mild artefacts may proceed but require careful QC after segmentation.

Change global config file
Open the global config file and add the path to your freesurfer license file under the freesurfer_subseg pipeline, just like you did for the fMRIPrep pipeline:

---

# 4. Run the Pipeline

`nipoppy process --pipeline cerebnet --dataset <NIPOPPY_DATASET> --session-id <session_id_without_prefix>`

The container workflow: it runs the segmentations subject by subject, at the end concatenating the volumetric output across subjects and generating the QC images in the `outputs` folder. For our Amsterdam cohort the runtime per subject is 50-80 min (with 4 CPU cores and 16GB RAM), for 35 subjects 29-47 hours. For larger cohorts this operation may take multiple days to finish. We currently do not have a parallelization code available. Parallelization of the operation is challenging, because of the automatic serial nature of the operation and subsequent grouping of data. In case you need to submit a job please set `"ARRAY_CONCURRENCY_LIMIT": "1"`, so it runs only one task (again, running multiple task simultaneously unfortunately doesn't work). 

---

# 5. Track Progression

`nipoppy track-processing --pipeline cerebnet --dataset <NIPOPPY_DATASET> --session-id <session_id_without_prefix>`

---

# 6. Generated Output

After completion, the outputs/ folder contains:

- qc_webpage/index.html → visual QC interface  
- classifier_out_bad_scans.txt → automated QC flags  
- volumes_all.csv → segmentation volumes  

---

# 7. Quality Control (QC)

## Step 1 — Web-based QC

Create a QC-adjusted file (copy of outputs/volumes_all.csv) to mark segmentation failure:

outputs/volumes_all_qc.csv

Open:

outputs/qc_webpage/index.html

Inspect all subjects, not only those flagged as problematic.

For anatomical label reference, consult the figure below from the original 
[CerebNet publication](https://www.sciencedirect.com/science/article/pii/S1053811922008242?via%3Dihub). 
This figure provides an overview of the cerebellar lobular definitions used in the segmentation.

For interactive inspection of labels, see Step 2. When loading the segmentation in Freeview, you can hover over individual voxels to display the label name and move through the axial, sagittal, and coronal planes.


<img width="704" height="145" alt="cerebnet_labels" src="https://github.com/user-attachments/assets/9a37624a-7846-4971-9957-0dc1384e8517" />


QC Checklist:

- Segmentation aligns with cerebellar anatomy  
- No major boundary leakage into the occipital cortex, brainstem, vessels and meninges  
- Lobular boundaries appear anatomically plausible    
- No gross segmentation failure  

If minor regional failure → mark that region as NA  
If global failure → mark all regions as NA  

---

## Rendering Distortion Issue

On some systems, QC images may appear distorted due to rendering issues. This does not indicate segmentation failure.

If distortion occurs, proceed to manual inspection using an image viewer (Step 2).


<img width="256" height="256" alt="3" src="https://github.com/user-attachments/assets/cec71511-d98d-4692-9642-79e169cc5f66" />


---

## Step 2 — Manual Inspection

Load the segmentation in Freeview:

```bash
freeview \
${BASE}/${COHORT}/derivatives/cerebnet/outputs/<subject>/fastsurfer/mri/orig/001.mgz \
${BASE}/${COHORT}/derivatives/cerebnet/outputs/<subject>/fastsurfer/mri/cerebellum.CerebNet.nii.gz:colormap=lut:lut=${BASE}/${COHORT}/code/FreeSurferColorLUT.txt:opacity=0.4
```

Ensure you use a [recent FreeSurferColorLUT.txt](https://github.com/Deep-MI/FastSurfer/blob/dev/FastSurferCNN/config/FreeSurferColorLUT.txt) that includes CerebNet labels.

If segmentation appears accurate → retain  
If inaccurate → exclude or set appropriate regions to NA  


<img width="1847" height="995" alt="freeview_cerebnet_qc" src="https://github.com/user-attachments/assets/73162cc4-190f-42b1-a668-623f3d20fdf7" />


---

# 8. Troubleshooting

Permission Errors  
Ensure your base directory is readable and writable.

Failed or Aborted Run  
Clean the input directory before re-running.

SLURM Jobs  
Ensure ≥16GB memory allocation.

Apptainer Cache Filling Home Directory  

```bash
apptainer cache clean
```

---

# 9. Final Submission

After QC:

Prepare:
- send_to_dzne.zip
  - Include QC snapshots if they are permitted to be shared under your local data governance regulations.  
  - If QC images cannot be shared, exclude the `qc_webpage` folder and include all other output files in the archive.
- volumes_all_qc.csv  

Submit according to:
https://enigma-infra.github.io/ENIGMA-Tremor/projects/ongoing/Cortical_Subcortical_Cerebellum_Morphology_Project/

---

# Contact

For questions regarding QC or technical issues:

Max Laansma  
m.laansma@amsterdamumc.nl
