### chunked_demux

This pipeline consists of only the demux.jl script which has been
adapted from the PORPIDpipeline to perform chunked demultiplexing based
on Index primers added after second round PCR. All other scripts and
architecture not pertaining to demultiplexing have been removed. This
was done to demultiplex the samples for the dUMI experiment performed by
Dylan Westfall. In this experiment samples were indexed with common
Index primers in batches of 3 or 4 samples per combination. This script
demultiplexes the CCS reads from the raw fastq.gz file in `raw-reads`
into fastq files for each Index primer combination and creates summary
files. The output fastq files were then used as input for the
sUMI_dUMI_comparison pipeline.

demux.jl code was adapted by Dylan Westfall to accept samples labeled
with Index primers. This primarily involved replacing the demultiplexing
code in demux_functions.jl which previously looked for Sample IDs within
cDNA primers with code Alec Pankow had written previously for an older
pipeline that could accept Indexed samples. 



## Quick start

### Dependencies (on an ubuntu machine)

- first update all apps
   - `apt update`
   - `apt upgrade`
- Snakemake
   - `apt-get install -y snakemake`
- mafft
   - `apt-get install -y mafft`
- fasttree
   - `apt-get install -y fasttree`
- python3 packages
  - `apt-get install python3-pandas`
  - `apt-get install python3-seaborn`


### Julia version 1.7

Download and unpack the latest Julia (we recommend version 1.7.1) from: 

[https://julialang.org/downloads/](https://julialang.org/downloads/)

Make sure you can enter the julia REPL from the command line, on an ubuntu machine you would do:

```bash
# move the julia system to a lib directory
mv julia-1.7.1 /usr/lib/julia-1.7.1
# make julia v1.7.1 executable from the command line
ln -s /usr/lib/julia-1.7.1/bin/julia /usr/local/bin/julia
# check that you can enter the julia REPL
julia --version
```

### cloning the PorpidPostproc repository

Now that the dependencies are setup we clone the PorpidPostproc repository

```bash
cd ~
git clone -b h705mod1 https://gitlab.com/hugh.murrell/porpidpostproc.git
```

### setting up the Julia package environment

then navigate to the `porpidpostproc` project folder and start the Julia REPL. 
Enter the package manager using `]` and then enter

```julia
activate .
instantiate
precompile
```

This will activate, install, and precompile the `julia` environment specified by the 
`Project.toml` and `Manifest.toml` files. The `precompile` command
above is not strictly needed but is useful if there are issues with installing
the `julia` packages listed in `Project.toml`

Next, add the following text to your Julia startup file (typically at `~/.julia/config/startup.jl`; 
you may need to create the directory if not present, `mkdir -p ~/.julia/config`).

```julia
using Pkg
if isfile("Project.toml") && isfile("Manifest.toml")
    Pkg.activate(".")
end
```

This will activate the local environment at Julia startup.


### Configuration

To configure the PorpidPostproc workflow, first edit the demo `config.yaml` file to reflect
your library construction. 
It should follow the same format as shown below in **example.yaml**

```yaml
Dataset1:
  Sample1:
    index_type: Index_primer
    fwd_index: Index_F01
    rev_index: Index_R01
  Sample2:
    index_type: Index_primer
    fwd_index: Index_F02
    rev_index: Index_R02
  Sample3:
    index_type: Index_primer
    fwd_index: Index_F03
    rev_index: Index_R03
```

The Index primer sequences provided will be used for demultiplexing and will be trimmed
from the final sequences. **fwd_index** and **rev_index** are the index primers used to 
tag each sample. Illumina Nextera indexes can be used as well as the Index primer set 
developed in Jim Mullins lab. Information on the Index primer set can be found in the file
Mullins_Index_Primers.csv in the docs folder. 

Raw CCS .fastq files should be placed in the `raw-reads/` subdirectory and named 
according to the the dataset name used in the `example_config.yaml` file, ie, `Dataset1.fastq`
for the example dataset.


### Preview and Execution

Preview jobs with Snakemake and run with {n} cores.

```bash
#preview jobs
snakemake -np

#run
snakemake -j{n}
```

For more info on Snakemake, see https://snakemake.readthedocs.io/en/stable/

## Conda setup

Some (without root access) may prefer to setup PorpidPostproc in a **conda** environment.

To accomplish this, first install `anaconda` locally. (the install script allows you to choose
the location for anaconda, by default `/home/user` but choose something else if
you want something accessable to a group of users)

```bash
curl –O https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh > Anaconda3-2021.05-Linux-x86_64.sh
bash Anaconda3-2021.05-Linux-x86_64.sh
```

then log out and log in again and check that you are in the `base` environment.

`conda` is very slow, so we suggest installing `mamba` in the conda `base` environment:

```bash
conda install -n base -c conda-forge mamba
```
clone the PorpidPostproc repository

```bash
cd ~  # or some other directory used for your anaconda installation
git clone -b h705mod1 https://gitlab.com/hugh.murrell/porpidpostproc.git
```

and then all the PorpidPostproc dependencies including `julia` version `1.7.1`
( as listed in the PorpidPostproc conda environment spec in `environment.yaml`),
can be installed in a `conda` environment via `mamba` using the commands:

```bash
conda config --add channels conda-forge
conda config --add channels bioconda
mamba env create --file environment.yaml
```

Note that if you did use *some other directory* than your home directory for
installing the PorpidPostproc repository then you have to inform Julia where
your packages are stored by placing the following command in your `.bashrc`
file:

```bash
# set path to .julia files
export JULIA_DEPOT_PATH="/some/other/directory/.julia"
```

to complete the setup, activate the new PorpidPostproc conda environment, 

```bash
conda activate PorpidPostproc
```

and continue with the `julia` package environment setup as outlined above in the *quick start* section.





