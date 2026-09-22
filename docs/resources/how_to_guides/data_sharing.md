# Data Sharing for ENIGMA-Tremor “Cortical/Subcortical/Cerebellum Morphology” project

## Important things to consider
Once you have completed all the [project steps](https://enigma-infra.github.io/ENIGMA-Tremor/projects/ongoing/Cortical_Subcortical_Cerebellum_Morphology_Project/), your derived data is ready to be shared with USC, where it will be accessible to the ENIGMA-Tremor core team. All data will remain on the USC server. Before transferring, please take the following steps:

- **Review the .tsv, .csv and Excel files to confirm completeness**. Verify that all participants are included, there are no missing or unexpected values, and that quality assessment scores have been assigned to each ROI and participant.
- Determine whether you are authorized to share the **quality control .png files**. These images, together with your quality assessment scores, will be used to train automated machine learning models for ENIGMA's quality checking pipelines, with the goal of reducing the need for manual review in the future.

## Data to be shared

The following data will be shared with USC as part of this project:

### MRI Outcomes (nipoppy workflow)

FreeSurfer output (5 spreadsheets)

From: `<dataset_root>/derivatives/freesurfer/7.3.2/idp/fs_stats-0.2.1/`

- Surface area: `fs7.3.2-aparc-area.tsv`

- Thickness: `fs7.3.2-aparc-thickness.tsv`

- Curvature: `fs7.3.2-aparc-meancurv.tsv`

- Subcortical volume: `fs7.3.2-aseg-volume.tsv`


From: `<dataset_root>/derivatives/freesurfer_subseg/1.0/idp/fs_subseg_stats-0.2/`

- Subsegmentations: `subsegmentation_volumes.tsv`


CerebNet output (1 spreadsheet; 4 text files)

From: `<dataset_root>/derivatives/cerebnet/1.0/ses-1/outputs/`

- Volume: `volumes_all.csv`

- `classifier_out.txt`

- `classifier_out_bad_scans.txt`

- `outliers_{all}.txt`

- `outliers_{any}.txt`


Quality control output (3 spreadsheet, optionally .png files)

- Cortical quality assessment scores

- Subcortical quality assessment scores

- Cerebellum quality assessment scores

- Quality control .png files (if authorized)

  - FreeSurfer cortical & subcortical: from `<dataset_root>/derivatives/fsqc/2.1.4/output/ses-1/` the `screenshots` and `surfaces` folders, and the `fsqc-results.html` file:

    -  `screenshots/`

    -  `surfaces/`

    -  `fsqc-results.html`

  - Cerebellum: the complete `qc_webpage` folder `<dataset_root>/derivatives/cerebnet/1.0/ses-1/outputs/qc_webpage/`

### Clinical and Demographic Data
- 1 [spreadsheet](https://docs.google.com/spreadsheets/d/1e21lov4f4-Ga6_AzvAvR38kRVTY2FfpS/edit?usp=sharing&ouid=106661288570625862890&rtpof=true&sd=true) containing clinical and demographic variables for all participants

## Data sharing protocol

### Using personalized upload credentials

Important: This upload method uses a shared account, with with an updated one-time password for each site data upload. After upload the site data will be transfered to the ENIGMA-Tremor central repository, only accessible by the ENIGMA-Tremor core team. To receive the username and your unique one-time password, please email Max Laansma at m.laansma@amsterdamumc.nl.

#### Option 1: Upload via graphical interface, for example Filezilla or WinSCP (drag-and-drop)
Open your preferred tool and connect using the following details:

- Host: (request via m.laansma@amsterdamumc.nl)

- Username: (request via m.laansma@amsterdamumc.nl)

- Password: (request via m.laansma@amsterdamumc.nl)

- Port: (request via m.laansma@amsterdamumc.nl)

Once connected, you should be in `/ftp/enigma_tremor/`. Find the folder prepared for your site (e.g. AMS) and drag and drop your files into it.

#### Option 2: Upload via command line
Open a terminal and log on to the USC server (request log-in details via m.laansma@amsterdamumc.nl)

This places you in `/ftp/enigma_tremor/`. Navigate to the folder prepared for your site, for example:
`cd AMS`

Upload a single file: `put AMS.tsv`
Upload a folder: `put -r AMS`

**Note:**
When logging in, you might get an error that looks like this:
```
Unable to negotiate with 10.2.2.175 port 22: no matching host key type found.
Their offer: ssh-rsa,ssh-dss
```
If that is the case, on your local machine, navigate to:
`cd /etc/ssh/`

Then use a text editor like vim to amend the ssh_config file (you may need to use sudo and add in your machine password):
`sudo vim ssh_config`

Add these two lines at the bottom of the config when in insert mode (press "i")                                                                  
```
HostkeyAlgorithms +ssh-rsa  
PubkeyAcceptedAlgorithms +ssh-rsa 
```
Save the config file using by pressing esc, then typing :wq! (include the colon). Try again once that is saved.
