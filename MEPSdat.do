//==============================================================================
//	MEPS DATA EXTRACTION
//==============================================================================
// Stata program to download all MEPS Household datasets
//==============================================================================
//	Written	by Suresh L. Paul, Economist - MRSTC Inc.
//	version: 07/06/2019
//==============================================================================
clear all 
capture log close 
set more off 

//------------------------------------------------------------------------------
// Program pe: Print Execute
//------------------------------------------------------------------------------
program define pe
	version 12.0
	if `"`0'"' != "" {
		display as text `"`0'"'
		`0'
		display("")
	}
end

//==============================================================================
// CREATE LOG FILE
//==============================================================================
cd "C:\MEPS\DATA" 

// STRATA FILES ... 
copy "https://meps.ahrq.gov/data_files/pufs/h36u17dat.zip" h36u17dat.zip , replace  /// download zip files
	                                        
	unzipfile h36u17dat , replace // unzip dat files 

	copy "https://meps.ahrq.gov/data_stats/download_data/pufs/h36/h36u17stu.txt" dofileh36u17stu.txt // copy the stata code from MEPS 		

		do "C:\MEPS\DATA\dofileh36u17stu.txt" // execute

local filenm h12 h20 h28 h38 h50 h60 h70 h79 h89 h97 h105 h113 h121 h129 h138 h147 h155 h163 h171 h181 h192 h201 // files from 1996 to 2017 

foreach k of local filenm { 

	di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
	di    "{p}STEP 1: COPY REMOTE ZIPPED DAT FILE AND MAKE LOCAL {p_end}"
	di    "{p}----------------------------------------------------------------------------------------------------{p_end}"

			pe copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/`k'dat.zip" `k'dat.zip , replace /// download zip files

	di    "{p}COPY FILE - DONE ...... {p_end}"

	di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
	di    "{p}STEP 2: UNZIP LOCAL FILE{p_end}" 
	di    "{p}----------------------------------------------------------------------------------------------------{p_end}"

			pe unzipfile `k'dat , replace // unzip dat files 

	di    "{p}UNZIP DONE ...... {p_end}" 

	di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
	di    "{p}STEP 3: COPY REMOTE STATA CODE {p_end}" 
	di    "{p}----------------------------------------------------------------------------------------------------{p_end}" 

			pe copy "https://meps.ahrq.gov/data_stats/download_data/pufs/`k'/`k'stu.txt" dofile`k'stu.txt 

	di    "{p}COPY CODE - DONE ...... {p_end}" 

	di    "{p}----------------------------------------------------------------------------------------------------{p_end}"
	di    "{p}STEP 4: RUN STATA CODE {p_end}" 
	di    "{p}----------------------------------------------------------------------------------------------------{p_end}" 

			pe do "C:\MEPS\DATA\dofile`k'stu.txt" 

	di    "{p}RUN DO FILE DONE ...... {p_end}" 

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

//==============================================================================
//	CLOSE OUTPUT 
//==============================================================================
