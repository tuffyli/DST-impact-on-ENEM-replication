# Scripts

This folder contains the executable R scripts for the replication package.
The intended entry point is the root-level `01_master.R`, which defines paths,
loads libraries, creates output folders, and then sources the scripts in order.

The replication package combines R and Stata scripts.
R is used for data construction and main estimation, while Stata is used
for selected graphical and bootstrap procedures.

## Execution Order

1. `02_data.R`
   Builds the analysis datasets from the raw administrative data.

2. `03_regression.R`
   Runs the main estimates, robustness checks, heterogeneity analyses, and balance
   checks, placebo exercises, and related tables and figures.

3. `04_desc_table.R`
   Produces descriptive statistics, sample-composition tables, and distribution
   figures.

4. `05_maps.R`
   Produces the maps used to describe the border, bandwidths, and exam timing
   regions.

5. `06_master.do`
   Defines paths and the execution order of the Stata do-files.
   
6. `07_cmogram.do`
   Produces the cmogram plots used to describe the discontinuity.

7. `08_bootstrap.do`
   Produces wild bootstrap inference using [Webb weights](https://onlinelibrary.wiley.com/doi/full/10.1111/caje.12661)
   to assess robustness to the clustering structure used in the main regressions.
   
## How To Run

Run the project from the repository root:

```r
source("01_master.R")
```

The scripts assume that `01_master.R` has already defined all path objects, such
as `data_path`, `processed_path`, `revision_path`, `no_age_path`,
`all_observations_path`, `outputs_path`, and the output subfolders.

After the R scripts finish, run `06_master.do`
to produce the Stata-based figures and robustness outputs.

## Notes For Reproduction

Do not hard-code user-specific drive paths in these scripts. All inputs and
outputs should be addressed through the path objects created by `01_master.R`.

If a script is run directly, it should still use the repository root as the
default path through `HV_REPROD_PATH` or `getwd()`.
