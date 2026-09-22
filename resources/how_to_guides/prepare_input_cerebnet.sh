#!/usr/bin/env bash
#Organizing required input structure for CerebNet
#Creates symlinks of T1w nifti files from the bids directory

CEREBNET_VERSION="1.0"
SESSION_ID="1" #adjust with your session ID without "ses-" 

NIPOPPY_DATASET="/path/to/your/nipoppy/datasets/cohort" #adjust with your path
BIDS_DIR=${NIPOPPY_DATASET}/bids    #your dataset's bids directory 
DERIVATIVES_DIR=${NIPOPPY_DATASET}/derivatives  #your dataset's derivatives directory 
CEREBNET_INPUT_DIR=${DERIVATIVES_DIR}/cerebnet/${CEREBNET_VERSION}/ses-${SESSION_ID}/input    #your cerebnet input directory 

mkdir -p "${CEREBNET_INPUT_DIR}"

echo "Linking T1w files from:"
echo "  ${BIDS_DIR}"
echo "into:"
echo "  ${CEREBNET_INPUT_DIR}"
echo

find "${BIDS_DIR}" -type f -name "*_T1w.nii.gz" | sort | while read -r f; do
    fname=$(basename "$f")
    target="${CEREBNET_INPUT_DIR}/${fname}"

    if [[ -e "${target}" ]]; then
        existing=$(readlink -f "${target}")
        if [[ "${existing}" == "$(readlink -f "$f")" ]]; then
            echo "Already linked: ${fname}"
        else
            echo "  WARNING: ${fname} already exists and points to a different file."
            echo "  Existing: ${existing}"
            echo "  New:      ${f}"
            echo "  Skipping to avoid overwrite."
        fi
    else
        ln -s "$f" "${target}"
        echo "Linked: ${fname}"
    fi
done

echo
echo "Done."