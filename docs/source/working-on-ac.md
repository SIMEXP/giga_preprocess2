# Working on Aliance Canada

Here we described a general workflow when working on Alliance Canada lab space.

General principels:

1. Working in progress data: `~/scratch`
2. Scripts: `~/project/rrg-pbellec/${USER}/giga_preprocess2/<datasetname>`
3. Archive: `/lustre03/nearline/6035398/giga_preprocessing_2/`

## Data processing script

We would like to have all the procedures documented and replicable.
Therefore, please document any changes.
If you cannot implement it in a script, describe it in a markdown file!

1. Clone this repository to lab space

```bash
cd ~/project/rrg-pbellec/${USER}
git clone --recurse-submodules git@github.com:SIMEXP/giga_preprocess2.git
```

2. Create a branch with the name of the dataset you are working on. We use `ds000030` as an example:

```bash
cd ~/project/rrg-pbellec/${USER}/giga_preprocess2
git checkout -b ds000030
```

3. Create a directory to store scripts for this dataset.

```bash
mkdir ds000030
```

After that, add and commit your files, push to the remote repository like usual!

4. Create a Pull Request on the remote repository.

This way Hao-Ting can help you to trouble shoot more easily.
Once the dataset is preprocessed, we can merge it into the main branch :tada:!


## Download data

Create a script for source data downloading.
The data should be stored in your personal `~/scratch`.
Please make sure there are enough space.
You can use command `quota` to see if number of file and/or space is within limit.

## Preprocessing data

The data should be stored in your personal `~/scratch`.
After it's done, archive and store to `/lustre03/nearline/6035398/giga_preprocessing_2/`.
You will need to ask Hao-Ting for access.
Once the data is archived, you can savely delete the sourcedata.
