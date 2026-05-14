* ---------------------------------------------------------------------------- *
* MASTER DO-FILE
* ---------------------------------------------------------------------------- *

clear all
set more off

cd "Z:/Tuffy/Paper - HV/reprod"

global PROJECT_ROOT "`c(pwd)'"
global SCRIPTS      "$PROJECT_ROOT/scripts"
global DATA         "$PROJECT_ROOT/data"
global OUTPUTS      "$PROJECT_ROOT/outputs"
global OUT_STATA    "$OUTPUTS/stata"

display "Project root: $PROJECT_ROOT"

do "$SCRIPTS/07_cmogram.do"
do "$SCRIPTS/08_bootstrap.do"
* ---------------------------------------------------------------------------- *
* END
* ---------------------------------------------------------------------------- *