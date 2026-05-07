# Reproduction Package

This repository contains the data-construction and analysis code for a study of
daylight saving time (DST) and student achievement in Brazil. The paper estimates
the causal effect of DST exposure by exploiting a geographic discontinuity in the
mandatory adoption of DST across municipalities and the nationwide abolition of
the policy in 2019. The empirical design is a geographic
difference-in-discontinuities design: it compares municipalities on either side
of the DST border before and after abolition, separating the effect of DST from
time-invariant sorting across locations and from other persistent geographic
differences.

The main outcome data come from Brazil's high-stakes national secondary-school
exam, ENEM, for the years 2013-2019. The package also constructs municipality
geography, weather controls, school census measures, and SAEB-based outcomes.
The SAEB analysis provides a comparable lower-stakes assessment setting.

## Repository Structure

All paths are defined relative to the reproduction folder. When running the
package, either start R from the repository root or set `HV_REPROD_PATH` to this
folder.

```text
reprod/
  01_master.R
  02_data.R
  03_regression.R
  04_desc_table.R
  05_maps.R
  data_raw/
  data/
    intermediate/
      revision/
      no_age_filter/
      all_observations/
      inpe_municipality/
      bandwidths/
    processed/
  outputs/
    controls/
    scores/
    migration/
    stata/
```

The `data_raw/` folder stores downloaded source files. The `data/` folder stores
intermediate and processed files created by the scripts. Tables, figures, maps,
and Stata exports are written to `outputs/`.

## Data Sources

The package uses public administrative data from the following sources. Raw files
are not redistributed here because the original archives are large and should be
downloaded directly from their official providers.

| Source | Years Used | Role in the Analysis | Official Link |
| --- | ---: | --- | --- |
| ENEM microdata | 2013-2019 | Main high-stakes exam outcomes, student characteristics, municipality of residence, municipality of test, school type, and item responses. | [INEP ENEM microdata](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/enem) |
| ENEM item parameters | 2009-2019 | Item-level parameters used to construct difficulty- and discrimination-based performance measures. These files are distributed within the ENEM microdata archives. | [INEP ENEM microdata](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/enem) |
| INPE SISAM | 2013-2019 | Daily municipality-level weather and atmospheric controls. | [INPE SISAM data server](https://dataserver-coids.inpe.br/queimadas/queimadas/sisam/) |
| School Census | 2018-2019 | School enrollment and student-flow measures used to characterize schooling environments. | [INEP School Census microdata](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/censo-escolar) |
| SAEB | 2017 and 2019 | Lower-stakes comparison outcomes by municipality and grade. | [INEP SAEB microdata](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/saeb) |
| IBGE municipal shapefile | version used in the analysis | Municipality boundaries used to construct DST-border geometry and distance-to-border measures. | [IBGE Malha Municipal](https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html) |

## Required Raw-Data Layout

Place the raw files under `data_raw/` using the following structure. The scripts
expect the original file names shown below.

```text
data_raw/
  enem/
    parameters/
      itens_prova_2009.csv
      ...
      itens_prova_2019.csv
    2013/dados/MICRODADOS_ENEM_2013.dta
    2014/dados/MICRODADOS_ENEM_2014.dta
    2015/dados/MICRODADOS_ENEM_2015.dta
    2016/dados/microdados_enem_2016.csv
    2017/dados/MICRODADOS_ENEM_2017.csv
    2018/dados/MICRODADOS_ENEM_2018.csv
    2019/dados/MICRODADOS_ENEM_2019.csv
  inpe/
    dados_sisam-2013/task_9045.dados_sisam.2013.csv
    ...
    dados_sisam-2019/task_9045.dados_sisam.2019.csv
  censo_escolar/
    situacao_aluno/
      ts_censo_basico_situacao_2018.dta
      ts_censo_basico_situacao_2019.dta
  saeb/
    microdados_saeb_2017/dados/
      ts_aluno_5ef.dta
      ts_aluno_9ef.dta
      ts_aluno_3em_esc.dta
    microdados_saeb_2019/dados/
      ts_aluno_5ef.dta
      ts_aluno_9ef.dta
      ts_aluno_34em.dta
  shapes/
    br_municipios_mapa_files/
```

The data script also expects the following auxiliary files in
`data/intermediate/revision/`:

```text
data/intermediate/revision/
  pib.RDS
  inpe/DTB_BRASIL_MUNICIPIO.xls
```

These files are used as municipality-level controls and crosswalk inputs in the
final analytic database.

## Code Workflow

Run the package from `01_master.R`. The master file loads packages, defines the
reproducible path structure, creates output directories, and sources the scripts
in order.

The table below uses the standardized script names expected in the final
package.

| Script | Purpose | Main Outputs |
| --- | --- | --- |
| `01_master.R` | Defines libraries, paths, folder creation, path helpers, and script order. | Creates `data/` and `outputs/` subfolders. |
| `02_data.R` | Builds all analysis datasets from raw administrative data. | `base_final.RDS`, ENEM yearly files, INPE municipality files, SAEB aggregate file, school census file. |
| `03_regression.R` | Estimates the main geographic difference-in-discontinuities specifications, robustness checks, heterogeneity, placebo analyses, and balance tests. | LaTeX tables, figures, bandwidth files, and a Stata export. |
| `04_desc_table.R` | Produces descriptive statistics and distributional summaries. | Descriptive tables and score-distribution figures. |
| `05_maps.R` | Produces maps of the DST border, municipality distance, analysis bandwidths, and exam start-time regions. | Map figures. |

The intended execution command is:

```r
source("01_master.R")
```

If running from a different working directory, set:

```r
Sys.setenv(HV_REPROD_PATH = "path/to/reprod")
source(file.path(Sys.getenv("HV_REPROD_PATH"), "01_master.R"))
```

## Data Construction

The data pipeline first constructs the geographic discontinuity. IBGE municipal
boundaries are read as spatial objects, municipalities are classified by DST
status, and the border between DST and non-DST regions is recovered from the
municipal polygons. The script then computes municipality centroids, distances
to the DST border, and border-segment indicators. These variables define the
geographic running variable and local comparison groups used in the empirical
design.

The ENEM pipeline harmonizes raw exam files across years. Variable names,
student characteristics, municipality identifiers, school-sector measures,
absence indicators, and score outcomes are standardized into a common schema.
The script constructs the main no-age-filter panel for 2013-2019 and separate
2018-2019 all-observation samples for non-standard applicant groups. Item
responses are joined to ENEM item parameters to create subject-level measures
and item-difficulty/discrimination measures.

The INPE pipeline imports SISAM files from 2013-2019, maps observations to
municipalities, and aggregates weather and atmospheric measures to the
municipality level. These controls are later merged into the ENEM analysis file
by municipality and year.

The SAEB pipeline builds municipality-by-grade achievement aggregates for 2017
and 2019. These data are used to test whether comparable effects appear in a
lower-stakes assessment, which helps interpret whether the ENEM results reflect
test-day performance in a high-stakes setting.

The School Census pipeline imports 2018 and 2019 student-flow files and creates
schooling-environment measures used in descriptive and robustness exercises.

The final construction step merges ENEM, geography, weather, census, and
municipality-level controls into `data/processed/base_final.RDS`. This is the
main analysis file used by the regression script.

## Main Generated Data Files

The most important generated files are:

```text
data/intermediate/revision/mun_hv.RDS
data/intermediate/revision/line.RDS
data/intermediate/no_age_filter/enem_notas_<year>_v4.RDS
data/intermediate/no_age_filter/enem_abs_<year>_v4.RDS
data/intermediate/no_age_filter/enem_ace_<year>_v4.RDS
data/intermediate/no_age_filter/base_nota_<year>.RDS
data/intermediate/no_age_filter/base_abs_<year>.RDS
data/intermediate/all_observations/base_nota_<year>_<type>.RDS
data/intermediate/inpe_municipality/inpe_mun_<year>.rds
data/processed/saeb_total.RDS
data/processed/census_students.RDS
data/processed/base_final.RDS
```

Here `<year>` refers to the relevant exam or weather year and `<type>` refers to
the applicant-type samples constructed in the all-observations pipeline.

## Analysis Outputs

Regression and descriptive scripts write results under `outputs/`:

```text
outputs/controls/
outputs/controls/figures/
outputs/controls/figures/pdf/
outputs/controls/maps/
outputs/scores/
outputs/scores/figures/
outputs/scores/figures/pdf/
outputs/migration/
outputs/stata/
```

The regression script produces the main LaTeX tables for the paper, including
the principal DST estimates, subject-specific results, school-type estimates,
race and sex heterogeneity, parental-education heterogeneity, migration checks,
border-segment checks, bandwidth tests, balance figures, SAEB placebo estimates,
and sample-comparison tables. It also exports selected inputs for external Stata
figures.

## Identification Logic in the Code

The core design compares changes around the DST border before and after the
2019 abolition of DST. During DST years, municipalities on the DST side of the
border were exposed to the policy while nearby municipalities on the other side
were not. In 2019, the national abolition removed this exposure. The code
therefore combines:

1. local geographic comparisons near the DST border;
2. before-after variation induced by the abolition of DST;
3. controls for distance-to-border polynomials and municipality/test-year
   covariates;
4. robustness checks over alternative samples, bandwidths, segments, outcomes,
   and comparison assessments.

This structure is designed to isolate the effect of DST exposure on student
achievement while absorbing persistent differences across locations and common
year shocks.

## Software

The package is written in R. The master script loads the required libraries,
including `tidyverse`, `data.table`, `sf`, `haven`, `rdrobust`, `fixest`,
`rddensity`, `readxl`, `stargazer`, `xtable`, `kableExtra`, `ggpattern`,
`scales`, and supporting string/data-cleaning packages.

Because the raw administrative files are large, runtime and memory requirements
depend on the local machine. Running the full data pipeline should be treated as
a long job rather than an interactive command.

## Reproducibility Notes

The scripts use relative paths rooted in the reproduction folder. The package is
therefore portable as long as the raw data are placed in the required
`data_raw/` layout and the run begins from the repository root or with
`HV_REPROD_PATH` set correctly.

The code creates generated-data and output folders automatically. It does not
download raw administrative data; researchers must download those files from the
official links above.

All generated analysis files should be treated as reproducible outputs. If a
generated file is stale or was produced under a different raw-data layout, delete
the corresponding file under `data/` or `outputs/` and rerun `01_master.R`.
