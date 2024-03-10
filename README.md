# Hybrid-TDOA-Calib
This project has open source code and data for the article titled "Asynchronous Microphone Array Calibration Using Hybrid TDOA Information". This article aims to solve the calibration problem of asynchronous microphone arrays, which involves using hybrid TDOA and odometry measurements to construct a graph SLAM that simultaneously estimates microphone parameters (microphone positions, time offsets, and clock drift rates) and sound source positions. Simulation and real experiments consistently prove that our method performs better than the existing method.

## Calibration Scenario
<img src="https://github.com/Chen-Jacker/Hybrid-TDOA-Calib/blob/main/calibration_scenario.gif" width="500px">

## Audio Accessment
Link in OneDrive: https://1drv.ms/f/s!AilTdY3K-LzJgbdgoZZSl9-d8883ow?e=gFOias
Place folder named "Audio" at the same level as folder "displacement".

## How to use
- `quick_start.m` realizes the estimation and visualization of calibration results between our method and the oether method.
- `sim_main.m` achieves simulations in paper.
- `real_main.m` achieves real-world experiments in paper.
- `DataAnalysis.m` plot the results computed from `sim_main.m` and `real_main.m`.

## Details
- The first part in `real_main` compute TDOA-S and TDOA-M based on real-world audio in folder named "audio".
