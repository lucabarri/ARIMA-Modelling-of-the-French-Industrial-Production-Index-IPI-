rm(list = ls())

# Load necessary libraries
library(readxl)
library(dplyr)
library(zoo)
library(forecast)
library(tseries)
library(fUnitRoots)

# Data preparation
monthly_values <- read_excel("C:\\Users\\mdida\\OneDrive\\Documents\\uni_IPP\\Semester 2\\Time Series\\project\\serie_010767602_16052024.xlsx", skip = 3)
colnames(monthly_values) <- c("date", "value")
monthly_values$date <- as.yearmon(monthly_values$date, format = "%Y-%m")
value <- zoo(monthly_values$value, order.by = monthly_values$date)

# Difference the series to ensure stationarity
dvalue <- diff(diff(value, 1))
plot(cbind(dvalue))

# Model fitting and storage of results
results <- expand.grid(p = 0:10, q = 0:3)
results$AIC <- NA
results$BIC <- NA

for (i in 1:nrow(results)) {
  model <- tryCatch({
    arima(dvalue, order = c(results$p[i], 0, results$q[i]), include.mean = FALSE)
  }, error = function(e) {
    NULL  # Return NULL if an error occurs
  })
  
  # Check if model is NULL
  if (!is.null(model)) {
    results$AIC[i] <- AIC(model)
    results$BIC[i] <- BIC(model)
  }
}

# Identify the best model based on AIC and BIC
best_aic_model <- results[which.min(results$AIC),]
best_bic_model <- results[which.min(results$BIC),]

print(best_aic_model)
print(best_bic_model)

# Forecasting with the best model based on AIC
best_aic_arima <- arima(dvalue, order = c(best_aic_model$p, 0, best_aic_model$q), include.mean = FALSE)
forecasted_values <- forecast(best_aic_arima, h = 2)

# Determine the range for x-axis to show less of the past values
start_date <- index(dvalue)[length(dvalue) - 24]  # Show the last 24 months (2 years) of historical data
end_date <- index(forecasted_values$mean)[2]

# Plot forecast with limited historical data
plot(forecasted_values, main = "Forecasting with Best AIC Model", xlab = "Time", ylab = "Forecast", xlim = c(start_date, end_date))

# Perform portmanteau test on the best AIC model
aic_test <- Box.test(best_aic_arima$residuals, lag = 12, type = "Ljung-Box")  # Changed lag to 12 for monthly data
print(aic_test)

# Forecasting with the best model based on BIC
best_bic_arima <- arima(dvalue, order = c(best_bic_model$p, 0, best_bic_model$q), include.mean = FALSE)
forecasted_values_bic <- forecast(best_bic_arima, h = 2)

# Plot forecast with limited historical data
plot(forecasted_values_bic, main = "Forecasting with Best BIC Model", xlab = "Time", ylab = "Forecast", xlim = c(start_date, end_date))

# Perform portmanteau test on the best BIC model
bic_test <- Box.test(best_bic_arima$residuals, lag = 12, type = "Ljung-Box")  # Changed lag to 12 for monthly data
print(bic_test)

# Plot residuals of the best AIC model for diagnostic purposes
par(mfrow = c(2, 1))
ts.plot(residuals(best_aic_arima), main = "Residuals of Best AIC Model", ylab = "Residuals", xlab = "Time")
acf(residuals(best_aic_arima), main = "ACF of Residuals of Best AIC Model")

# Plot residuals of the best BIC model for diagnostic purposes
ts.plot(residuals(best_bic_arima), main = "Residuals of Best BIC Model", ylab = "Residuals", xlab = "Time")
acf(residuals(best_bic_arima), main = "ACF of Residuals of Best BIC Model")

# Print model summaries for diagnostics
summary(best_aic_arima)
summary(best_bic_arima)

