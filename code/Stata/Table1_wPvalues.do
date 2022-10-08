// File:     Table1_wPvalues
// Project:  Patreon
// Author:   Erika Austhof
// Last Update: 10/8/2022
// Data Needed:  DemographicData.dta

// IMPORT IN STATA DATASET
use "~\data\DemographicData.dta"

//If you need to import via Excel, use this following code to ensure the variables are in the correct format for the table command. In general, this command requires numeric values, but you can use value labels to note the categories.
import excel "~\data\DemographicData.xls", sheet("Sheet1") firstrow
replace outcome="1" if outcome=="Death"
replace outcome="0" if outcome=="Recover"
destring outcome, replace
label define outcome 1 "Death" 0 "Recover"
label values outcome outcome
replace fever="1" if fever=="Yes"
replace fever="0" if fever=="No"
destring fever, replace
label define yesno 1 "Yes" 0 "No"
label values fever yesno
replace chills ="1" if chills =="Yes"
replace chills ="0" if chills =="No"
destring chills , replace
label values chills yesno
replace cough ="1" if cough =="Yes"
replace cough ="0" if cough =="No"
destring cough , replace
label values cough yesno
replace sex ="1" if sex =="Male"
replace sex ="0" if sex =="Female"
destring sex , replace
label define sex 1 "Male" 0 "Female"
label values sex sex
tab hospital
replace hospital="1" if hospital=="Central Hospital"
replace hospital="2" if hospital=="Military Hospital"
replace hospital="3" if hospital=="Port Hospital"
replace hospital="4" if hospital=="St. Mark's Maternity Hospital (SMMH)"
replace hospital="5" if hospital=="Other"
destring hospital , replace
label define hospital 1 "Central Hospital" 2 "Military Hospital" 3 "Port Hospital" 4 "St. Mark's Maternity Hospital (SMMH)" 5 "Other"
label values hospital hospital

// COMMON TABLE COMMAND
// In my Table 1 freebie, you probably have already seen how to create a table with proportions and counts. This is helpful, but an additional helpful command would be to have p-values. Here is a table for just counts and proportions, and then we will use a Stata package to add in the p-values in a new table.
table (var) (sex), statistic(mean age) statistic(sd age) statistic(fvfrequency hospital outcome fever chills cough) statistic(fvpercent hospital outcome fever chills cough) nototal
collect recode result fvfrequency=column1 fvpercent=column2 mean=column1 sd=column2
collect layout (var) (sex#result[column1 column2])
collect style cell var[hospital outcome fever chills cough]#result[column2], nformat(%6.1f) sformat("%s%%")
collect style cell var[age]#result[column1 column2], nformat(%6.1f)
collect style cell var[age]#result[column2], sformat("(%s)")
collect style header result, level(hide)
collect style row stack, nobinder spacer
collect style cell border_block, border(right, pattern(nil))
collect preview

// INSTALL THE TABLE1 PACKAGE
ssc install table1_mc

// CREATE TABLE 1
// In this example, we want a table 1 of epidemiology data, split out by sex, with associated p-values for each category. The back slash tells the command you have a new variable level (e.g. age, hopsital, etc.). After each variable you can specify how you would like the output displayed using different formats. At the end you include some additional items, here's what I recommend: onecol (gives you a header row for each variable), missing (keeps missing values included so they have their own row), nospace (drops leading spaces in the output), saving (outputs the table into Excel for you). There are so many options in this package! Check out help table1_mc for more documentation.
table1_mc, by(sex) vars(age contn %4.0f \ hospital cat %4.0f \ outcome cat %4.0f \ fever bin %4.0f \ chills bin %4.0f \ cough bin %4.0f) nospace onecol missing total(after) saving("table1.xlsx", replace)