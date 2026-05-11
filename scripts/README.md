# Scripts

This folder contains the executable R scripts for the reproduction package.
The intended entry point is the root-level `01_master.R`, which defines paths,
loads libraries, creates output folders, and then sources the scripts in order.

## Expected Order

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

5. `06_cmogram.do`
   Produces the cmogram plots used to describe the discontinuity.

6. `07_bootstrap`
   Produces the wild bootstrap test with [Webb]{https://onlinelibrary.wiley.com/doi/full/10.1111/caje.12661} weights for robustness testing
   the clusters utilized in the main regression.
   
## How To Run

Run the project from the repository root:

```r
source("01_master.R")
```

The scripts assume that `01_master.R` has already defined all path objects, such
as `data_path`, `processed_path`, `revision_path`, `no_age_path`,
`all_observations_path`, `outputs_path`, and the output subfolders.

## Notes For Reproduction

Do not hard-code user-specific drive paths in these scripts. All inputs and
outputs should be addressed through the path objects created by `01_master.R`.

If a script is run directly, it should still use the repository root as the
default path through `HV_REPROD_PATH` or `getwd()`.
