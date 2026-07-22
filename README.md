# Reproducibility package for Voronoi-cell volume PDFs

This repository contains the MATLAB scripts and numerical data required to reproduce the numerical probability-density-function (PDF) results for normalized Poisson--Voronoi cell areas and volumes. The plotting scripts compare the empirical PDFs with the reference and proposed analytical models.

## Software requirements

- **MATLAB R2025a** (tested version).
- **Optimization Toolbox** is required only to re-estimate the fitted parameters with the quasi-Newton `fminunc` routine in `solve_abc.m`. The simulation and plotting scripts otherwise use standard MATLAB functions, including `delaunayTriangulation`, `voronoiDiagram`, `voronoin`, and `convhull`.

## Repository contents

- `main.m`, `main_MX.m`, and `main_v2.m`: reproduce the 2-D and 3-D PDF comparison figures from the supplied data.
- `get_area_volume.m`: controls the optional regeneration of the empirical samples.
- `areas.m` and `volumes.m`: generate one realization of the Poisson--Voronoi area and volume samples, respectively.
- `P1.m`, `P2.m`, and `P3.m`: evaluate the analytical PDF models.
- `valid_areas.mat`: 40,002,672 supplied empirical 2-D cell-area samples used by the plotting scripts.
- `valid_volumes.mat`: 32,005,269 supplied empirical 3-D cell-volume samples used by the plotting scripts.
- `Fig-Voronoi_PDF_2D.*` and `Fig-Voronoi_PDF_3D.*`: reproduced figures in EPS and PDF formats.

## Parameter settings

The figure scripts contain the complete fitted parameter settings.  The parameters used for the proposed models in `main_MX.m` are:

| Dimension | Two-parameter model `(a,b)` | Three-parameter model `(a,b,c)` |
| --- | --- | --- |
| 2-D | `(3.5692, 3.5692)` | `(3.31605, 3.03689, 1.07871)` |
| 3-D | `(5.5856, 5.5856)` | `(4.828, 4.097, 1.160)` |

The empirical-data settings in `get_area_volume.m` are:

| Setting | 2-D area simulation | 3-D volume simulation |
| --- | --- | --- |
| Point intensity | `lambda = 1` | `lambda = 1` |
| Observation window | `[0,200] x [0,200]` | `[0,20] x [0,20] x [0,20]` |
| Guard ratio | `0.6` | `0.6` |
| Number of realizations | `4000` | `4000` |

The value `lambda = 1` is defined in `areas.m` and `volumes.m`; the remaining simulation settings are defined in `get_area_volume.m`.

Each realization is generated in an extended guard window. The code retains a cell only when its nucleus lies in the nominal observation window, the cell is bounded, and all of its vertices lie strictly inside the extended window. With guard ratio `0.6`, the extended windows are `[-120,320]^2` for the 2-D simulation and `[-12,32]^3` for the 3-D simulation. The implementation fixes the number of uniformly distributed nuclei at `round(lambda * extended-window measure)`, which is the fixed-count (binomial) approximation to a homogeneous PPP used for these simulations.

In the primary reproduction script, `main_MX.m`, the empirical PDFs are constructed with 400 histogram bins in both dimensions and `Normalization` set to `pdf`. The alternative `main.m` configuration uses 200 bins for the 2-D data and 400 bins for the 3-D data.

## Parameter estimation

The proposed-model parameters were estimated by moment matching. For the three-parameter generalized-gamma model, `solve_abc.m` uses the Optimization Toolbox routine `fminunc` with the quasi-Newton algorithm to minimize the sum of squared discrepancies between the theoretical and empirical first three raw moments. The two-parameter gamma-model parameters are obtained from the corresponding first two moments under the unit-mean normalization. The separate `cal_error.m` script evaluates the resulting PDFs using MSE, MAE, and coefficient of determination rather than re-estimating their parameters.

## Random seed

The supplied `.mat` files are the canonical empirical data for reproducing the reported figures, so the default plotting procedure does not invoke random-number generation. For an independent regeneration from the MATLAB scripts, initialize MATLAB's Mersenne Twister generator with seed **2025** before running the simulation:

```matlab
rng(2025, 'twister');
```

Using the supplied data makes the plotting stage deterministic. Reusing the seed, parameter settings, and MATLAB version specified above makes a new simulation run reproducible.

## Execution procedure

1. Download or clone the complete repository, including `valid_areas.mat` and `valid_volumes.mat`.
2. Open MATLAB R2025a and change the current folder to the repository root.
3. Run:

   ```matlab
   main_MX
   ```

4. The script loads the supplied data and writes `Fig-Voronoi_PDF_2D.eps`, `Fig-Voronoi_PDF_2D.pdf`, `Fig-Voronoi_PDF_3D.eps`, and `Fig-Voronoi_PDF_3D.pdf` to the repository root. `main.m` and `main_v2.m` provide alternative plotting configurations.

## Optional regeneration of the empirical data

Regenerating the data is not required to reproduce the figures because both `.mat` files are included. To generate a new stochastic data set:

1. In `get_area_volume.m`, uncomment the 2-D area block when `valid_areas.mat` is to be regenerated. Leave only the required generation blocks active if memory is limited.
2. Initialize the random-number generator and run the script:

   ```matlab
   rng(2025, 'twister');
   get_area_volume
   ```

3. Save the generated variables as required:

   ```matlab
   save('valid_areas.mat', 'valid_areas', '-v7.3');
   save('valid_volumes.mat', 'valid_volumes', '-v7.3');
   ```

The 3-D generation can require substantial memory and execution time because it constructs 4000 three-dimensional Voronoi tessellations.

## Data-integrity checksums

The SHA-256 checksums of the supplied numerical data are:

| File | SHA-256 |
| --- | --- |
| `valid_areas.mat` | `B3571F92481CB69CDAE9461C3B4129A2DDE61621984C9D26B1F9A5457D092FD0` |
| `valid_volumes.mat` | `15F7E6F4C4D9379A9DE38A007A9253245349E63B8A435DCC012795F84F57A601` |

## Repository

The complete code, numerical data, and reproduction instructions are available at <https://github.com/shitian-0715/Voronoi-volume-PDF-survey>.
