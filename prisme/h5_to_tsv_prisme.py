import sys
import pandas as pd

sys.path.append("/home/neuromod/rs-autoregression-prediction/src")
from data.load_data import load_data, load_h5_data_path
from pathlib import Path


def label_connectome(connectome_df, labels_p, atlas):
    if atlas == "CAB-NP":
        labels_df = pd.read_csv(labels_p, delimiter=";")
        labels_df.sort_values(by=["index"], inplace=True)
        region_labels = labels_df["name"].tolist()
    elif atlas == "BA":
        labels_df = pd.read_csv(labels_p)
        labels_df.sort_values(by=["Label"], inplace=True)
        region_labels = labels_df["region"].tolist()
    else:
        raise ValueError(f"Unknown atlas: {atlas}")

    connectome_df.columns = region_labels
    connectome_df.index = region_labels
    return connectome_df


def save_connectome_to_tsv(connectome, path, output_p):
    filename = f"{Path(path).stem}.tsv"
    filepath = output_p / filename
    output_p.mkdir(parents=True, exist_ok=True)
    connectome.to_csv(filepath, sep="\t")
    print(f"Saved: {filepath}")


def process_connectomes(atlas, root_p):
    if atlas == "CAB-NP":
        h5_file = (
            root_p
            / "prisme-connectomes/CAB-NP/prisme_connectome_CABNP-0.4.1_20250110/atlas-coleanticevic_desc-simple+gsr.h5"
        )
        labels_p = root_p / "prisme/CAB-NP/CAB-NP_labels_reordered.csv"
        output_p = (
            root_p
            / "prisme-connectomes/CAB-NP/tsv_files_atlas-coleanticevic_desc-simple+gsr_20250110"
        )
    elif atlas == "BA":
        h5_file = (
            root_p
            / "prisme-connectomes/BA/prisme_connectome-0.4.1_BA_20241218/atlas-brainnetome_desc-simple+gsr.h5"
        )
        labels_p = root_p / "prisme/BA/subregion_func_network_Yeo_updated.csv"
        output_p = (
            root_p
            / "prisme-connectomes/BA/tsv_files_atlas-BA_desc-simple+gsr_20241218"
        )
    else:
        raise ValueError(f"Unknown atlas: {atlas}")

    # Load data
    dset_paths = load_h5_data_path(
        path=h5_file, data_filter="connectome", shuffle=False
    )
    data = load_data(
        path=h5_file, h5dset_path=dset_paths, standardize=False, dtype="data"
    )

    # Process each connectome
    for connectome, path in zip(data, dset_paths):
        connectome_df = pd.DataFrame(connectome)
        connectome_df = label_connectome(connectome_df, labels_p, atlas)
        save_connectome_to_tsv(connectome_df, path, output_p)

    print(f"Connectomes processed and saved to {output_p}")


if __name__ == "__main__":
    root_p = Path("/home/neuromod")
    for atlas in ["CAB-NP"]:  # ["BA", "CAB-NP"]
        process_connectomes(atlas, root_p)
