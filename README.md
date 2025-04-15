# ARIMA Modelling of the French Industrial Production Index (IPI)

**Authors:** Luca Barriviera, Maxime Didascalou

**Date:** May 23, 2024

## Overview

This project analyzes and models the French Industrial Production Index (IPI) for the Food Industries sector using ARIMA techniques in R. The goal is to identify an appropriate model based on historical data (Jan 1990 - Apr 2024, seasonally adjusted, from INSEE) and generate short-term forecasts.

## Methodology & Key Findings

1.  **Data Preparation:** Loaded and visualized the monthly IPI series.
2.  **Stationarity:** The original series was tested using the Augmented Dickey-Fuller (ADF) test and found to be non-stationary. First-order differencing (`d=1`) was applied to achieve stationarity.
3.  **Model Identification:** ACF and PACF plots of the differenced series suggested potential ARMA orders (p<=7, q<=1).
4.  **Model Selection:** ARMA models were compared using AIC and BIC. The ARMA(1,1) model was chosen for the differenced series based on AIC and successful residual validation (Ljung-Box tests).
5.  **Final Model:** The analysis resulted in an **ARIMA(1,1,1)** model for the original IPI series.
*   Equation (Differenced):
    ```math
    X_t = -0.1803 X_{t-1} + \varepsilon_t - 0.7321 \varepsilon_{t-1}
    ```
*   Equation (Original):
    ```math
    Y_t - 0.8197Y_{t-1} - 0.1803Y_{t-2} = \varepsilon_t - 0.7321\varepsilon_{t-1}
    ```
6.  **Forecasting:** Generated forecasts for the next two months, including 95% confidence intervals and a 2D confidence region (assuming Gaussian residuals).

## Visualizations

The analysis includes plots for:
*   Original and differenced time series.
*   ACF and PACF of the differenced series.
*   Forecasts with confidence intervals.
*   2D confidence region for forecast points.
*   ![Forecast Plot Example](images/forecast.png)

## Code

The R script (`time_series_analysis.R`) used for this analysis is included in the repository. It details the implementation of the tests, model fitting, validation, and forecasting steps.
