# Welcome to the ENIGMA-infra FreeSurfer 7 guidelines!

## Prerequisites
This guide assumes that you have:

- [installed Nipoppy and organized your data in BIDS](./setting_up_nipoppy.md)
- [Apptainer available as container platform](../open_science_tools/container_platforms.md)

## Pull container
We will apply the FreeSurfer functionalities that are included in the fMRIPrep pipeline. You can pull the fMRIPrep container in the following way:

```bash
apptainer build fmriprep_24.1.1.sif \
                    docker://nipreps/fmriprep:24.1.1
```

Make sure that you store the container in the containers folder that is [referenced in your global config file](../open_science_tools/container_platforms.md#storing-container-images).

For more information on fMRIPrep, see the [fMRIPrep documentation](https://fmriprep.org/en/stable/).

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
