# Welcome to the ENIGMA CerebNet guidelines!

## Prerequisites
This guide assumes that you have:

- [installed Nipoppy and organized your data in BIDS](./setting_up_nipoppy.md)
- [Apptainer available as container platform](../open_science_tools/container_platforms.md)

## Pull container
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

## Set up configuration
Next, we will need to install the fMRIPrep pipeline within Nipoppy. You can do this by simply running:

```bash
nipoppy pipeline install --dataset <dataset_root> 15427833
```

15427833 is the Zenodo ID for the Nipoppy configuration files for fmriprep 24.1.1. Read more about this step [here](./getting_ENIGMA-PD_pipeline_config_files.md).

Once the pipeline is installed, open the global config file and check whether the correct fMRIPrep version is included under `PIPELINE_VARIABLES`.
The following paths should be replaced here under the correct version of the fMRIPrep pipeline in the global config file:
- `<FREESURFER_LICENSE_FILE>` (required to run FreeSurfer; you can get a FreeSurfer licence for free at [the FreeSurfer website](https://surfer.nmr.mgh.harvard.edu/registration.html))
- `<TEMPLATEFLOW_HOME>` (see [here](./Templateflow_info.md) for more info on Templateflow)

## Run pipeline
Finally, simply run the following line of code:
```bash
nipoppy process --pipeline fmriprep --pipeline-version 24.1.1 --dataset <dataset_root>
```
This should initiate the FreeSurfer 7 segmentation of your T1-weighted images! You can also do a dry-run first by adding `--simulate` to your command. See all `nipoppy process` options [here](https://nipoppy.readthedocs.io/en/latest/cli_reference/process.html)

**Note:** the command above will run all the participants and sessions in a loop, which may be inefficient. If you're using an HPC, you may want to submit a batch job to process all participants/sessions. Nipoppy can help you do this by:
1. generating a list of "remaining" participants to be processed for your job-subission script: `nipoppy process --pipeline fmriprep --pipeline-version 24.1.1 --dataset <dataset_root> --write-list <path_to_participant_list>`
2. automatically submitting HPC jobs for you with additional configuration (more info [here](https://nipoppy.readthedocs.io/en/latest/how_to_guides/parallelization/hpc_scheduler.html))

### Track pipeline output
The `nipoppy track-processing` command can help keep track of which participants/sessions have all the expected output files for a given processing pipeline. See [here](https://nipoppy.readthedocs.io/en/latest/how_to_guides/tracking/index.html) for more information. 
```bash
nipoppy track-processing --pipeline fmriprep --dataset <dataset_root>
```
Running this command will update the `processing_status.tsv` under the `derivatives` folder.

## Extract pipeline output
For automatic extraction of the cortical thickness, cortical surface area and subcortical volume into .tsv files, you can use another [Nipoppy pipeline](./getting_ENIGMA-PD_pipeline_config_files.md), called `fs_stats`. The Zenodo ID for this pipeline is 15427856, so you can install it with the following command:
```bash
nipoppy pipeline install --dataset <dataset_root> 15427856
```
Remember to define the freesurfer license file path in your global config file under the newly installed pipeline. Then, you can simply run 
```bash
nipoppy extract --pipeline fs_stats --dataset <dataset_root>
```
to get things going. You can find the extracted data under `<dataset_root>/derivatives/freesurfer/7.3.2/idp/`.

Did you complete all FreeSurfer 7 processing and data extraction? Great job! You can now move on to the [subsegmentation](./freesurfer_subseg.md), or go straight to [quality control](./fsqc.md).
