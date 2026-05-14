
use "$OUT_STATA/main_df_boot.dta", clear

* Quick check
describe
summarize y x

* ---------------------------------------------------------------------------- *
* 2. RD SETUP
* ---------------------------------------------------------------------------- *

* Running variable (already centered in R if x = dist - cutoff)
gen running = x

* Treatment indicator
gen treat = running >= 0

* Renaming variable
rename cluster seg

* ---------------------------------------------------------------------------- *
* 3. LOAD BANDWIDTH (OPTION A: manual)
* ---------------------------------------------------------------------------- *

* Restrict to RD window
keep if abs(running) <= bw

* ---------------------------------------------------------------------------- *
* 4. (OPTIONAL) TRIANGULAR KERNEL WEIGHTS (closer to rdrobust)
* ---------------------------------------------------------------------------- *

gen w_tri = (1 - abs(running / bw))
replace w_tri = 0 if w_tri < 0

* Combine with original weights (optional)
gen w_final = w * w_tri

* ---------------------------------------------------------------------------- *
* 5. INSTALL REQUIRED PACKAGES (run once)
* ---------------------------------------------------------------------------- *

cap which reghdfe
if _rc ssc install reghdfe

cap which boottest
if _rc ssc install boottest

* ---------------------------------------------------------------------------- *
* 6. REGRESSION (FULL SPECIFICATION)
* ---------------------------------------------------------------------------- *

reghdfe y ///
    treat ///
    running ///
    c.running#treat ///
    lat lon ///
    dtempd1 dumidd1 dumidd2 dtempd2 ///
    dn_ban dpessoa dn_qua dn_car dn_gel dn_cel dpc dinternet dempr_dom ///
    descm dfem dppi didade descp ///
    drenda1 drenda110 drenda10 dgdppc ///
    h13 h12 ///
    seg2 seg3 seg4 seg5 seg6 seg7 ///
    [aw = w_final], ///
    vce(cluster seg)

* ---------------------------------------------------------------------------- *
* 7. WILD BOOTSTRAP
* ---------------------------------------------------------------------------- *

boottest treat, cluster(seg) reps(9999) seed(12345)

* ---------------------------------------------------------------------------- *
* 8. (OPTIONAL) SAVE RESULTS
* ---------------------------------------------------------------------------- *

estimates store rd_main

* ---------------------------------------------------------------------------- *
* 9. ROBUSTNESS: NO KERNEL (pure local linear)
* ---------------------------------------------------------------------------- *

reg y ///
    treat ///
    running ///
    c.running#treat ///
    lat lon ///
    dtempd1 dumidd1 dumidd2 dtempd2 ///
    dn_ban dpessoa dn_qua dn_car dn_gel dn_cel dpc dinternet dempr_dom ///
    descm dfem dppi didade descp ///
    drenda1 drenda110 drenda10 dgdppc ///
    h13 h12 ///
    seg2 seg3 seg4 seg5 seg6 seg7 ///
    [aw = w], ///
    vce(cluster seg)

boottest treat = 0, cluster(seg) reps(9999) seed(12345) 

boottest treat = 0, cluster(seg) weight(webb) rep(9999) seed(12345)

* Saving the result
file open tex using "$OUTPUTS/scores/rd_values.tex", write replace
file write tex "Treatment (RD effect) & 7.13 & 6.22 \\\\" _n
file write tex "                      & (2.36) & (2.64) \\\\" _n
file write tex "                      &        & [0.040] \\\\" _n
file close tex

* ---------------------------------------------------------------------------- *
* END
* ---------------------------------------------------------------------------- *