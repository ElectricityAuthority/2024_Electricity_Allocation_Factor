# 2024 Electricity Allocation Factor
## Data and Model  
  
This repository contains the model (vSPD) and data (input and output) for the 2024 Electricity Allocation Factor project.

Note that this repository only contain the essential code and data to run the simulations. The input data (vSPD input gdx files) that can be downloaded from EMI are excluded. All the outputs files, that are not used for further process, are also excluded. 

The EA can provided these excluded data upon request.

Interested psrties can repeat the simulation folowing these steps:

1. Download this repository to local computer.

2. Install GAMS[https://gams.com/download/] version 42 or above and make sure that you have a GAMS licence.

3. Download all gdx files (from Pricing_20230701.gdx to Pricing_20260630.gdx) from EMI [https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/GDX] to [...\2024_Electricity_Allocation_Factor\vSPD_5.0.2\Input]

4. Run each simulation using corresponding program folder (e.g. for base case, run [...\2024_Electricity_Allocation_Factor\vSPD_5.0.2\Programs_BaseCase\runvSPD.bat] )

5. Use [...\2024_Electricity_Allocation_Factor\Caluclate_EAF_2023_2024.R] to estimate EAF. Note that this only provides the EAF for the financial year 2023/2024. You need to obtain the EAF for the previous two years and calculate the average.

If you have any request, please contact us at [emi@ea.govt.nz]


