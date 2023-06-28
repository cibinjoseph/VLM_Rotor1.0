[![](https://img.shields.io/badge/status-under%20development-green.svg)]() ![Documentation](https://github.com/cibinjoseph/VOLCANOR/actions/workflows/docs.yaml/badge.svg)

![VOLCANOR](media/VOLCANOR-logo.png)

# Documentation
A Parallel, Object oriented implementation of the Unsteady Vortex Lattice method in Fortran 90+ for aerodynamic analysis of rotors and wings under generic 3D motion.

## Features
- Parallelized implementation using OpenMP
- Rankine vortex model (includes ideal vortex model)
- Vortex dissipation due to turbulence and viscosity
- Slow-start to avoid large starting vortex
- Wake strain to prevent violation of Helmholtz's Law
- Predictor-Corrector based wake convection for improved stability and accuracy
- Visualization of load history, circulation, wake structure etc in VisIt
- Arbitrary prescribed trajectory
- Wake axisymmetry leveraging for efficient solution
- Wake truncation

## Installation
The solver has the following dependencies:
- CMake
- OpenMP
- LAPACK
- BLAS
- GNU or Intel Fortran compiler
- Python (Optional; for postprocessing)
- Paraview (Optional; for postprocessing)

The volcanor executable may be built in the following manner:
```bash
mkdir build
cd build
FC=ifort cmake ..
make
```

## Contribution and Usage
This code is under active development and a lot of features--including a proper user-friendly interface--have yet to be added. At this point, often changes have to be made in-code which requires compilation. This solver is open-sourced only to serve as a starting point to other researchers and extensive changes may be required to adapt it to your specific needs. Users are encouraged to go through the code if interested, and let the author know of issues and bugs. However, be warned that most of the features are untested and unvalidated and the author offers no guarantee on the results obtained.

## Authors
All code here was created by me, [Cibin Joseph](https://github.com/cibinjoseph) (cibinjoseph92@gmail.com) during my PhD tenure at Indian Institute of Technology (IIT) Madras, India. I have shifted my focus to other engineering challenges, resulting in a decreased pace of development for this project of mine.

## License
GNU General Public License v3.0
See [LICENSE](LICENSE) for full text.
