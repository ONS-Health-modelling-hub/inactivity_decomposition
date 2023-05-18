* READ DATA
append using $aps2019  $aps2022, generate (year)

* CREATE YEAR VAR
label var year "Year"
label define label1 1"2019" 2"2022"
label values year label1

* CLEAN UP WEIGHTS
egen pw = rowtotal(PWTA22 PWTA18)
label var pw "Person Weight"

*Check that person weight created from each year's weight equals original value
sort year
by year: tabstat PWTA18 PWTA22, s(mean)

sort year
by year: tabstat pw, s(mean)

* KEEP ONLY 16 TO 64
keep if MF1664==1

* CREATE VARIABLES

*Combine work limting variables
gen LIMITAK=.
replace LIMITAK=1 if LIMITA==1 | LIMITK==1
replace LIMITAK=2 if LIMITA==2 & LIMITK==2
recode LIMITAK (.=-9)

label var LIMITAK "Health limits either the kind or amount of work can do"
label define label2 1"Yes" 2"No" -9"Missing"
label values LIMITAK label2

*Create 2022 dummy
gen dum2022=year
recode dum2022 (1=0)
recode dum2022 (2=1)
label var dum2022 "2022 dummy"
label define label5 0"2019" 1"2022"
label values dum2022 label5

*Create 2019 dummy
gen dum2019=year
recode dum2019 (2=0)
label var dum2019 "2019 dummy"
label define label13 0"2022" 1"2019"
label values dum2019 label13

*Create inactive dummy
gen duminact=.
replace duminact=0 if ILODEFR==1 | ILODEFR==2
replace duminact=1 if ILODEFR==3
label var duminact "Economically inactive dummy"
label define label6 0"Active" 1"Inactive"
label values duminact label6

*create active dummy
gen dumact=.
replace dumact=0 if duminact==1
replace dumact=1 if duminact==0
label var dumact "Economically active dummy"
label define label3 0"Inactive" 1"Active"
label values dumact label3

*Create work-limiting health problem dummy
gen dumLIMITAK=LIMITAK
recode dumLIMITAK (-9=0)
recode dumLIMITAK (2=0)
label var dumLIMITAK "Work-limiting health problem dummy"
label define label7 0"Does not have a work-limiting health problem" 1"Has a work-limiting health problem"

*Create single-year age dummies
tab AGE, gen(AGE)
rename (AGE1 AGE2 AGE3 AGE4 AGE5 AGE6 AGE7 AGE8 AGE9 AGE10 AGE11 AGE12 AGE13 AGE14 AGE15 AGE16 AGE17 AGE18 AGE19 AGE20 AGE21 AGE22 AGE23 AGE24 AGE25 AGE26 AGE27 AGE28 AGE29 AGE30 AGE31 AGE32 AGE33 AGE34 AGE35 AGE36 AGE37 AGE38 AGE39 AGE40 AGE41 AGE42 AGE43 AGE44 AGE45 AGE46 AGE47 AGE48 AGE49) (AGE_16 AGE_17 AGE_18 AGE_19 AGE_20 AGE_21 AGE_22 AGE_23 AGE_24 AGE_25 AGE_26 AGE_27 AGE_28 AGE_29 AGE_30 AGE_31 AGE_32 AGE_33 AGE_34 AGE_35 AGE_36 AGE_37 AGE_38 AGE_39 AGE_40 AGE_41 AGE_42 AGE_43 AGE_44 AGE_45 AGE_46 AGE_47 AGE_48 AGE_49 AGE_50 AGE_51 AGE_52 AGE_53 AGE_54 AGE_55 AGE_56 AGE_57 AGE_58 AGE_59 AGE_60 AGE_61 AGE_62 AGE_63 AGE_64)

*Create new age ranges
gen AAGEinact=.
replace AAGEinact=1 if AGE==16
replace AAGEinact=2 if AGE==17
replace AAGEinact=3 if AGE==18 | AGE==19
replace AAGEinact=4 if AGES==5
replace AAGEinact=5 if AGES==6
replace AAGEinact=6 if AGES==7
replace AAGEinact=7 if AGES==8
replace AAGEinact=8 if AGES==9
replace AAGEinact=9 if AGES==10
replace AAGEinact=10 if AGES==11
replace AAGEinact=11 if AGE==55 | AGE==56 | AGE==57
replace AAGEinact=12 if AGE==58 | AGE==59
replace AAGEinact=13 if AGE==60
replace AAGEinact=14 if AGE==61
replace AAGEinact=15 if AGE==62
replace AAGEinact=16 if AGE==63
replace AAGEinact=17 if AGE==64
tab AAGEinact

label var AAGEinact "Age bands for economic inactivity"
label define label8 1"16" 2"17" 3"18-19" 4"20-24" 5"25-29" 6"30-34" 7"35-39" 8"40-44" 9"45-49" 10"50-54" 11"55-57" 12"58-59" 13"60" 14"61" 15"62" 16"63" 17"64"
label values AAGEinact label8

tab AAGEinact, gen(AAGEinact)
tab AGES, gen(AGES)

*Create condensed main health condition variable (other if missing but work-limiting condition selected)
gen HEALTHCON=.
replace HEALTHCON=0 if missing(HEALTH) | missing(HEALTH20)
replace HEALTHCON=4 if dumLIMITAK == 1 & (missing(HEALTH) | missing(HEALTH20))
replace HEALTHCON=1 if HEALTH==1 | HEALTH20==1
replace HEALTHCON=1 if HEALTH==2 | HEALTH20==2
replace HEALTHCON=1 if HEALTH==3 | HEALTH20==3
replace HEALTHCON=4 if HEALTH==4 | HEALTH20==4
replace HEALTHCON=4 if HEALTH==5 | HEALTH20==5
replace HEALTHCON=4 if HEALTH==6 | HEALTH20==6
replace HEALTHCON=4 if HEALTH==7 | HEALTH20==7
replace HEALTHCON=2 if HEALTH==8 | HEALTH20==8
replace HEALTHCON=2 if HEALTH==9 | HEALTH20==9
replace HEALTHCON=2 if HEALTH==10 | HEALTH20==10
replace HEALTHCON=2 if HEALTH==11 | HEALTH20==11
replace HEALTHCON=3 if HEALTH==12 | HEALTH20==12
replace HEALTHCON=4 if HEALTH==13 | HEALTH20==13
replace HEALTHCON=4 if HEALTH==14 | HEALTH20==14
replace HEALTHCON=3 if HEALTH==15 | HEALTH20==15
replace HEALTHCON=4 if HEALTH==16 | HEALTH20==16
replace HEALTHCON=4 if HEALTH==17 | HEALTH20==17
replace HEALTHCON=4 if HEALTH20==18
label var HEALTHCON "Health condition (4 bands)"
label define label11 0"Does not apply" 1"Musculoskeletal" 2"Cardiovascular & Digestive" 3"Mental health" 4"Progressive illnesses and other problems/conditions"
label values HEALTHCON label11

*Combine health condition groups with work limiting status
gen LIMITAKHEALTHCON=dumLIMITAK*HEALTHCON
label var LIMITAKHEALTHCON "Work-limiting health condition (4 bands)"
label define label12 0"No work-limiting health condition" 1"Musculoskeletal" 2"Cardiovascular & Digestive" 3"Mental health" 4"Progressive illnesses and other problems/conditions"
label values LIMITAKHEALTHCON label12

*Create condensed main health condition variable (other if missing but long term health condition selected)
gen HEALTHCON2=.
replace HEALTHCON2=0 if missing(HEALTH) | missing(HEALTH20)
replace HEALTHCON2=4 if LNGLST == 1 & (missing(HEALTH) | missing(HEALTH20))
replace HEALTHCON2=1 if HEALTH==1 | HEALTH20==1
replace HEALTHCON2=1 if HEALTH==2 | HEALTH20==2
replace HEALTHCON2=1 if HEALTH==3 | HEALTH20==3
replace HEALTHCON2=4 if HEALTH==4 | HEALTH20==4
replace HEALTHCON2=4 if HEALTH==5 | HEALTH20==5
replace HEALTHCON2=4 if HEALTH==6 | HEALTH20==6
replace HEALTHCON2=4 if HEALTH==7 | HEALTH20==7
replace HEALTHCON2=2 if HEALTH==8 | HEALTH20==8
replace HEALTHCON2=2 if HEALTH==9 | HEALTH20==9
replace HEALTHCON2=2 if HEALTH==10 | HEALTH20==10
replace HEALTHCON2=2 if HEALTH==11 | HEALTH20==11
replace HEALTHCON2=3 if HEALTH==12 | HEALTH20==12
replace HEALTHCON2=4 if HEALTH==13 | HEALTH20==13
replace HEALTHCON2=4 if HEALTH==14 | HEALTH20==14
replace HEALTHCON2=3 if HEALTH==15 | HEALTH20==15
replace HEALTHCON2=4 if HEALTH==16 | HEALTH20==16
replace HEALTHCON2=4 if HEALTH==17 | HEALTH20==17
replace HEALTHCON2=4 if HEALTH20==18
label var HEALTHCON2 "Health condition (4 bands)"
label define label14 0"Does not apply" 1"Musculoskeletal" 2"Cardiovascular & Digestive" 3"Mental health" 4"Progressive illnesses and other problems/conditions"
label values HEALTHCON2 label14

* DECOMPOSITION MODELS

*With work-limiting health conditions
mvdcmp dum2019: logit dumact ib6.AAGEinact i.LIMITAKHEALTHCON [pweight=pw]

*With all health conditions, not just work limiting
mvdcmp dum2019: logit dumact ib6.AAGEinact i.HEALTHCON2 [pweight=pw]

* UNDERLYING LOGIT MODELS

*With work-limiting health conditions
*2022
logit dumact ib6.AAGEinact i.LIMITAKHEALTHCON if dum2019==0 [pweight=pw], 

*2019
logit dumactib6.AAGEinact i.LIMITAKHEALTHCON if dum2019==1 [pweight=pw]

*With all health conditions, not just work limiting
*2022
logit dumact ib6.AAGEinact i.HEALTHCON2 if dum2019==0 [pweight=pw]

*With all health conditions, not just work limiting
*2019
logit dumact ib6.AAGEinact i.HEALTHCON2 if dum2019==1 [pweight=pw]
