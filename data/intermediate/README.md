# Intermediate Data

This folder contains data objects created during the construction pipeline and
used by later scripts.

Expected subfolders:

```text
data/intermediate/
  revision/
  no_age_filter/
  all_observations/
  inpe_municipality/
  bandwidths/
```

## Main Contents

`revision/`
Stores auxiliary and geography files, including municipality distance objects
and external crosswalk/control files used by the data script.

`no_age_filter/`
Stores the main ENEM yearly score, absence, item-response, and merged files.

`all_observations/`
Stores the all-observations ENEM files for the `mock` and `older` applicant
groups used in descriptive and robustness exercises.

`inpe_municipality/`
Stores yearly municipality-level INPE weather files.

`bandwidths/`
Stores bandwidth objects used by the regression and map scripts.

These files are generated or consumed by the R pipeline and should not be edited
manually.
