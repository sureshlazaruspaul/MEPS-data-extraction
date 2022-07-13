//==============================================================================
//	Medical Expenditure Panel Survey (MEPS)
//  Agency for Healthcare Research and Quality
//  Household Full Year Consolidated Data File
//------------------------------------------------------------------------------
// Usage: Use this file to download Full-Year Consolidated Data files 
//        between 1996 to 2019.
//------------------------------------------------------------------------------
//	Written	by,
//      Suresh L. Paul
//      Sr. Data Scientist
//      Algorithm Basics LLC.
//------------------------------------------------------------------------------
//	version: v1.0.1
//  date: 10/15/2021
//==============================================================================

clear all 
capture log close 
set more off 

//------------------------------------------------------------------------------
// user programs: Print Execute
//------------------------------------------------------------------------------

program define pe
	version 12.0
	if `"`0'"' != "" {
		display as text `"`0'"'
		`0'
		display("")
	}
end


cd "C:\MEPS\DATA" 



// download STRATA FILES ... 

copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h036/h36u19dat.zip" h36u19dat.zip , replace  /// download zip files

	unzipfile h36u19dat , replace // unzip dat files 

	copy "https://meps.ahrq.gov/data_stats/download_data/pufs/h036/h36u19stu.txt" dofileh36u19stu.txt // copy the stata code from MEPS 		

		do "C:\MEPS\DATA\dofileh36u19stu.txt" // execute



// download MEPS HOUSEHOLD FILES ... 

local filenm 12 20 28 38 50 60 70 79 89 97 105 113 121 129 138 147 155 163 171 181 192 201 209 216 // files from 1996 to 2019 

foreach k of local filenm { 

	if ( `k' < 216 ){

		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
		di    "{p}STEP 1: COPY REMOTE ZIPPED DAT FILE AND MAKE LOCAL {p_end}"
		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"

			pe copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h`k'dat.zip" h`k'dat.zip , replace /// download zip files

		di    "{p}COPY FILE - DONE ...... {p_end}"



		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
		di    "{p}STEP 2: UNZIP LOCAL FILE{p_end}" 
		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"

			pe unzipfile h`k'dat , replace // unzip dat files 

		di    "{p}UNZIP DONE ...... {p_end}" 



		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
		di    "{p}STEP 3: COPY REMOTE STATA CODE {p_end}" 
		di    "{p}----------------------------------------------------------------------------------------------------{p_end}" 

			pe copy "https://meps.ahrq.gov/data_stats/download_data/pufs/h`k'/h`k'stu.txt" dofileh`k'stu.txt 

		di    "{p}COPY CODE - DONE ...... {p_end}" 



		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
		di    "{p}STEP 4: RUN STATA CODE {p_end}" 
		di    "{p}----------------------------------------------------------------------------------------------------{p_end}" 

			pe do "C:\MEPS\DATA\dofileh`k'stu.txt" 

		di    "{p}RUN DO FILE DONE ...... {p_end}" 

	} 
	
	else {


		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
		di    "{p}STEP 1: COPY REMOTE ZIPPED DAT FILE AND MAKE LOCAL {p_end}"
		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"

			pe copy "https://www.meps.ahrq.gov/mepsweb/data_files/pufs/h`k'/h`k'dta.zip" h`k'dta.zip , replace /// download zip files

		di    "{p}COPY FILE - DONE ...... {p_end}"

		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
		di    "{p}STEP 2: UNZIP LOCAL FILE{p_end}" 
		di    "{p}----------------------------------------------------------------------------------------------------{p_end}"

			pe unzipfile h`k'dta , replace // unzip dat files 

		di    "{p}UNZIP DONE ...... {p_end}" 

	}

	di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
	di    "{p}STEP 5: House-cleaning - erase files{p_end}" 
	di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
	local list1 : dir . files "*.DAT" 
	local list2 : dir . files "*.zip" 
	local list3 : dir . files "*.txt" 
	forval i = 1/3 {
		foreach f of local list`i' {
			erase "`f'" 
		}  
	} 
	di _n "{p}erase DONE ...... {p_end}" 
} 
