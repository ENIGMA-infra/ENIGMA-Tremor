# Welcome to the ENIGMA-Tremor Cortical/Subcortical/Cerebellum Morphology Project guidelines!

This page is created to guide collaborating ENIGMA-Tremor sites through this project's processing steps. The outcomes include cortical thickness, cortical surface area, volume of subcortical regions and their subfields, and volume of cerebellum subdivisions. All steps and code required are combined into the guidelines presented here. NOTE: the cerebellum volume extraction protocol is being finalized and will be added soon. If you have any questions, concerns, or issues, please contact the ENIGMA-Tremor core team at m.laansma@amsterdamumc.nl. 

## Expression of interest to participate with your site data
Please fill out the [EOI form](https://forms.gle/fDZg9uQQqfxPVURX6) to express your interest to participate in the project and we will reach out to you.

## Leaderboard
To help motivate and monitor each site's progress, we maintain a leaderboard that outlines all the steps detailed in these guidelines. If you are in charge of data processing at your site, please request access and regularly update your progress on the current steps on the [ENIGMA-Tremor Leaderboard](https://docs.google.com/spreadsheets/d/1eYlLcxH7ET17Nr1wskm55SLVEqAoaBod_r1zIid9FSk/edit?usp=sharing).

## Overview
The figure shows the expected outcomes and corresponding processing steps - most of which can be performed using the Nipoppy framework and helper Python package. We strongly recommend adoption of Nipoppy tools to simplify coordination and ensure reproducibility of this end-to-end process across all sites. 

![enigma-nipoppy-rollout-plan-enigma-tremor-fs7-fastsurfer_cerebnet-overview](https://github.com/user-attachments/assets/918aab71-769b-4bd4-981f-d5c49b317081)

The steps are numbered and correspond to the sections below. The links direct you to the dedicated central ENIGMA-infra pages, which provide detailed instructions.

## 1) Setting up Nipoppy: [Link to instructions]()
Nipoppy is a lightweight framework for standardized data organization and processing of neuroimaging-clinical datasets. Its goal is to help users adopt the [FAIR principles](https://www.go-fair.org/fair-principles/) and improve the reproducibility of studies. 

The ongoing collaboration between the ENIGMA-PD team and Nipoppy team has streamlined data curation, processing, and analysis workflows, which significantly simplifies tracking of data availability, addition of new pipelines and upgrading of existing pipelines. The ENIGMA-Tremor and Nipoppy team is available to support and guide users through the process of implementing the framework, ensuring a smooth transition. To join the Nipoppy support community, we recommend joining their [Discord channel](https://discord.gg/dQGYADCCMB). Here you can ask questions and find answers while working with Nipoppy. 

For more information, see the [Nipoppy documentation](https://nipoppy.readthedocs.io/en/stable/index.html).

## 2a) Running FreeSurfer 7: [Link to instructions]()
When you reach this point, the hardest part is behind you and we can finally come to the real stuff. We will run FreeSurfer 7 through fMRIPrep using Nipoppy. See [here](https://nipoppy.readthedocs.io/en/latest/how_to_guides/user_guide/processing.html) for additional information about running processing pipelines with Nipoppy.

**Part 1: Cortical and subcortical segmentations**
We will apply the FreeSurfer functionalities that are included in the fMRIPrep pipeline. We assume here that you have Apptainer installed as your container platform (see [here](../resources/Container_platforms.md) for more info and how to get it).

**Part 2: Subsegmentations**
The subsegmentations pipeline is now ready to be run! Since you’ve all just been through fMRIPrep in Nipoppy, this next step will feel familiar as running this pipeline follows a very similar workflow.

*About the pipeline:*
This pipeline uses existing FreeSurfer 7 functionalities to extract subnuclei volumes from subcortical regions like the *thalamus*, *hippocampus*, *brainstem*, *hypothalamus*, *amygdala*, and *hippocampus*. It requires completed FreeSurfer output (`recon-all`) and integrates the subsegmentation outputs directly into the existing `/mri` and `/stats` directories. Additionally, the pipeline will perform [Sequence Adaptive Multimodal SEGmentation (SAMSEG)](https://surfer.nmr.mgh.harvard.edu/fswiki/Samseg) on T1w images in order to calculate a superior intracranial volume.

## 2b) Quality Assessment: [Link to instructions]()
**part 1: Running the FS-QC toolbox**

Congratulations, you made it to the quality assessment! For this purpose, we will use FreeSurfer Quality Control (FS-QC) toolbox. The [FS-QC toolbox](https://github.com/Deep-MI/fsqc) takes existing FreeSurfer (or FastSurfer) output and computes a set of quality control metrics. These will be reported in a summary table and/or .html page with screenshots to allow for visual inspection of the segmentations.

**part 2: Performing a visual quality assessment**

Quality checking is essential to make sure the output that you have produced is accurate and reliable. Even small errors or artifacts in images can lead to big mistakes in analysis and interpretation, so careful checks help us to verify whether we can savely include a certain region of interest or participant in our analysis. For the FreeSurfer output, we will follow standardized ENIGMA instructions on how to decide on the quality of the cortical and subcortical segmentations. 
**At this stage, visual quality assessment of the subsegmentations (e.g., thalamic or hippocampal nuclei) is not required, as there are no established protocols yet and the process would be highly time-consuming; statistical checks (e.g., outlier detection) can be used instead. This may be followed up at a later stage, once there is a project that specifically focuses on these outcomes and the necessary anatomical expertise is available to develop a dedicated quality control manual.**

You can find the updated ENIGMA-PD QC instructions for visual inspection [here](../resources/ENIGMA-PD_visual_QC_instructions.md).

## 3) Running the cerebellum segmentations using CerebNet
The protocol is being finalized and will be added soon!

![under-construction-sign-warning-sign-under-construction-yellow-triangle-sign-with-crossed-hammer-and-wrench-icon-inside-caution-at-the-construction-site-workers-machinery-and-other-obstacles-vector](https://github.com/user-attachments/assets/53a9e950-a9a8-4038-bd2c-8cec82df7844){ width="80" }

## 4) Data sharing
After completing all of the above steps, you're ready to share your derived data with the ENIGMA-Tremor core team. Please:

- Review the .tsv and Excel spreadsheets for completeness, ensuring all participants are included, there are no missing or unexpected data points, and quality assessment scores have been assigned to each ROI and participant.
- Confirm whether you are authorized to share the quality check .png files. These will be used, along with your quality assessment scores, to help train automated machine learning models for ENIGMA's quality checking pipelines, to eliminate the need for manual checking in the future.

Once these checks are complete, email m.laansma@amsterdamumc.nl to receive instructions for uploading the .csv files and, if applicable, the QA .png files, via SFTP to our central storage on the LONI server hosted by USC.
