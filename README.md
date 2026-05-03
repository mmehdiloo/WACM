# WACM
# Empirical illustration: US banking data (1986)

This repository contains the GAMS code and data required to reproduce the empirical illustration in our paper:
M. Mehdiloo & K. Kerstens (2026). Weak Axiom of Cost Minimization and Cost Functions on Technologies with Various Convexity Assumptions.


## Data source

We utilize a secondary data set of US banking data initially used in Aly, Grabowski, Pasurka, and Rangan (1990).  
There are **322 observations** for the year 1986, with:

- 3 inputs  
- 5 outputs  
- 3 input prices  

For further details and descriptive statistics, see Table 1 in Aly et al. (1990).

## Repository contents

| File | Description |
|------|-------------|
| `main.gms` | Main GAMS code for estimation |
| `data.csv` | Input–output data (322 observations) |
| `prices.csv` | Input price data |
| `results.gdx` | Output file (generated when run) |

## Requirements

- **GAMS** (version 24.0 or higher)  
- Any GAMS license that supports LP/NLP (e.g., CPLEX, CONOPT, IPOPT)  

## How to run

1. Open GAMS IDE  
2. Load `main.gms`  
3. Run the model (press `F9`)  
4. Results will appear in the listing file and be saved to `results.gdx`

## Expected outputs

The code reproduces:
- Main tables and figures in the empirical illustration section  
- Efficiency scores and summary statistics consistent with \citet{Aly1990}

## Reproducibility note

All file paths in `main.gms` are relative. To run on your own machine:

- Download or clone this entire repository  
- Keep all files in the same folder  
- Do not change the working directory inside GAMS

## Citation

If you use this code or data, please cite:

- Our paper (insert your citation here)  
- \citet{Aly1990} for the original data

## Contact

[Your Name] – [your email]  
[Optional: corresponding author’s institutional link]
