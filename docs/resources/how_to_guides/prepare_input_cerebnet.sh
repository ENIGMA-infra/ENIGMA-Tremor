#!/usr/bin/env bash
#Organizing required input structure for CerebNet
#Creates symlinks of T1w nifti files from the bids directory

BASE=/path/to/your/nipoppy/datasets	#your cohort directory e.g. /data/anw/anw-work/NP/projects/data_ENIGMA_Tremor/datasets
BIDS=${BASE}/your_cohort/bids	#your cohort bids directory e.g. ${BASE}/Amsterdam/bids
DEST=${BASE}/your_cohort/derivatives/cerebnet/input 	#your cerebnet input directory e.g. ${BASE}/Amsterdam/derivatives/cerebnet/input

mkdir -p "${DEST}"

echo "Linking T1w files from:"
echo "  ${BIDS}"
echo "into:"
echo "  ${DEST}"
echo

find "${BIDS}" -type f -name "*_T1w.nii.gz" | sort | while read -r f; do
    fname=$(basename "$f")
    target="${DEST}/${fname}"

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