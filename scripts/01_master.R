# ---------------------------------------------------------------------------- #
# Master Archive
# ---------------------------------------------------------------------------- #

# Creation date: 11/14/2023
# Created by: Bruno Komatsu

# Last modification: 02/06/2026
# Modified by: Tuffy Issa

# ---- Description: ---- #
#' Loads the libraries, defines reproducible paths and helper functions, then
#' runs the project scripts in order.

#------------------------------------------------------------------------------#
# 1. Libraries ----
#------------------------------------------------------------------------------#

library(tidyverse)
library(data.table)
library(sf)
library(haven)
library(labelled)
library(rdrobust)
library(fastDummies)
library(janitor)
library(xtable)
library(viridis)
library(readstata13)
library(stringr)
library(RColorBrewer)
library(fixest)
library(rddensity)
library(tidyr)
library(stringi)
library(readxl)
library(knitr)
library(stargazer)
library(kableExtra)
library(ggpattern)
library(scales)
library(purrr)

set.seed(12345)
# ---------------------------------------------------------------------------- #
# 2. Paths and Helpers ----
# ---------------------------------------------------------------------------- #

path_from_env <- function(env, default) {
  value <- Sys.getenv(env, unset = NA_character_)
  if (!is.na(value) && nzchar(value)) {
    return(normalizePath(value, winslash = "/", mustWork = FALSE))
  }
  normalizePath(default, winslash = "/", mustWork = FALSE)
}

first_existing_path <- function(...) {
  candidates <- unlist(list(...), use.names = FALSE)
  existing <- candidates[file.exists(candidates)]
  if (length(existing) > 0) {
    return(normalizePath(existing[[1]], winslash = "/", mustWork = FALSE))
  }
  normalizePath(candidates[[1]], winslash = "/", mustWork = FALSE)
}

path_paste <- function(root, ...) {
  file.path(root, paste0(...))
}

reprod_path <- path_from_env("HV_REPROD_PATH", getwd())
project_path <- reprod_path
paper_path <- project_path

raw_data_path <- file.path(reprod_path, "data_raw")

data_path <- file.path(reprod_path, "data")
intermediate_path <- file.path(data_path, "intermediate")
processed_path <- file.path(data_path, "processed")

revision_path <- file.path(intermediate_path, "revision")
no_age_path <- file.path(intermediate_path, "no_age_filter")
all_observations_path <- file.path(intermediate_path, "all_observations")
inpe_mun_path <- file.path(intermediate_path, "inpe_municipality")

# ENEM inputs are expected as:
# data_raw/enem/<year>/dados/<original_microdata_filename>
# data_raw/enem/parameters/itens_prova_<year>.csv
enem_path <- file.path(raw_data_path, "enem")
enem_parameters_path <- file.path(enem_path, "parameters")
inpe_raw_path <- file.path(raw_data_path, "inpe")
censo_path <- file.path(raw_data_path, "censo_escolar", "situacao_aluno")
sh_path <- file.path(raw_data_path, "shapes", "br_municipios_mapa_files")

saeb17_path <- file.path(raw_data_path, "saeb", "microdados_saeb_2017", "dados")
saeb19_path <- file.path(raw_data_path, "saeb", "microdados_saeb_2019", "dados")

enem_raw_file <- function(year, filename) {
  file.path(enem_path, as.character(year), "dados", filename)
}

source_script <- function(script_name, fallback_name = script_name) {
  candidates <- c(
    file.path(reprod_path, "scripts", script_name),
    file.path(reprod_path, script_name),
    file.path(reprod_path, fallback_name)
  )
  existing <- candidates[file.exists(candidates)]
  source(if (length(existing) > 0) existing[[1]] else candidates[[1]])
}

aggregate_path <- file.path(no_age_path, "aggregated")
bandwidth_path <- file.path(intermediate_path, "bandwidths")

outputs_path <- file.path(reprod_path, "outputs")
controls_output_path <- file.path(outputs_path, "controls")
controls_figures_path <- file.path(controls_output_path, "figures")
controls_pdf_path <- file.path(controls_figures_path, "pdf")
controls_maps_path <- file.path(controls_output_path, "maps")

scores_output_path <- file.path(outputs_path, "scores")
scores_figures_path <- file.path(scores_output_path, "figures")
scores_pdf_path <- file.path(scores_figures_path, "pdf")

migration_output_path <- file.path(outputs_path, "migration")
stata_output_path <- file.path(outputs_path, "stata")

dir.create(revision_path, recursive = TRUE, showWarnings = FALSE)
dir.create(no_age_path, recursive = TRUE, showWarnings = FALSE)
dir.create(all_observations_path, recursive = TRUE, showWarnings = FALSE)
dir.create(inpe_mun_path, recursive = TRUE, showWarnings = FALSE)
dir.create(processed_path, recursive = TRUE, showWarnings = FALSE)
dir.create(aggregate_path, recursive = TRUE, showWarnings = FALSE)
dir.create(bandwidth_path, recursive = TRUE, showWarnings = FALSE)

dir.create(controls_output_path, recursive = TRUE, showWarnings = FALSE)
dir.create(controls_figures_path, recursive = TRUE, showWarnings = FALSE)
dir.create(controls_pdf_path, recursive = TRUE, showWarnings = FALSE)
dir.create(controls_maps_path, recursive = TRUE, showWarnings = FALSE)
dir.create(scores_output_path, recursive = TRUE, showWarnings = FALSE)
dir.create(scores_figures_path, recursive = TRUE, showWarnings = FALSE)
dir.create(scores_pdf_path, recursive = TRUE, showWarnings = FALSE)
dir.create(migration_output_path, recursive = TRUE, showWarnings = FALSE)
dir.create(stata_output_path, recursive = TRUE, showWarnings = FALSE)

.path_objects <- c(
  "path_from_env", "first_existing_path", "path_paste", "source_script",
  "clear_workspace", ".path_objects",
  "reprod_path", "project_path", "paper_path", "raw_data_path",
  "data_path", "intermediate_path", "processed_path",
  "revision_path", "no_age_path", "all_observations_path",
  "inpe_mun_path", "enem_path", "enem_parameters_path", "enem_raw_file",
  "inpe_raw_path", "censo_path",
  "sh_path", "saeb17_path", "saeb19_path",
  "aggregate_path", "bandwidth_path", "outputs_path",
  "controls_output_path", "controls_figures_path", "controls_pdf_path",
  "controls_maps_path", "scores_output_path", "scores_figures_path",
  "scores_pdf_path", "migration_output_path", "stata_output_path"
)

clear_workspace <- function(extra_keep = character(), envir = parent.frame()) {
  keep <- unique(c(.path_objects, extra_keep))
  rm(list = setdiff(ls(envir = envir), keep), envir = envir)
  invisible(gc())
}

# ---------------------------------------------------------------------------- #
# 3. Scripts ----
# ---------------------------------------------------------------------------- #

source_script("02_data.R")
source_script("03_regression.R")
source_script("04_desc_table.R")
source_script("05_maps.R")
