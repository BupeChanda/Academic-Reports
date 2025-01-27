*(11 variables, 40 observations pasted into data editor)
ssc install coefplot
ssc install heatplot

* Rename variables
rename var1 Country
rename var2 Year
rename var3 Crypto
rename var4 inf
rename var5 Int
rename var6 GDP
rename var7 IPR
rename var8 CNY
rename var9 INR
rename var10 USD
rename var11 EUR

* Create Shock Variable
gen Shock = (Year == 2020 | Year == 2018 | Year == 2019 | Year == 2022)


* Regression with 2018 shock
reg Crypto inf Int GDP IPR CNY INR USD EUR Shock i.Country i.Year, cluster(Country)
estat vif
coefplot, drop(_cons) xline(0) title("Coefficient Plot") xlabel(, angle(45))


xtset Country Year
xtreg Crypto inf Int GDP IPR CNY INR USD EUR Shock, fe cluster(Country)
coefplot, drop(_cons) xline(0) title("Coefficient Plot") xlabel(, angle(45))
xtreg Crypto inf Int GDP IPR CNY INR USD EUR Shock, re cluster(Country)
coefplot, drop(_cons) xline(0) title("Coefficient Plot") xlabel(, angle(45))

* Remove 2018 shock
replace Shock = 0 in 5
replace Shock = 0 in 6
replace Shock = 0 in 15
replace Shock = 0 in 16
replace Shock = 0 in 25
replace Shock = 0 in 26
replace Shock = 0 in 35
replace Shock = 0 in 36

* Regression without 2018 Shock
reg Crypto inf Int GDP IPR CNY INR USD EUR Shock i.Country i.Year, cluster(Country)
coefplot, drop(_cons) xline(0) title("Coefficient Plot") xlabel(, angle(45))
xtreg Crypto inf Int GDP IPR CNY INR USD EUR Shock, fe cluster(Country)
coefplot, drop(_cons) xline(0) title("Coefficient Plot") xlabel(, angle(45))


* Residuals and Fitted Values Plot
predict residuals, residuals
scatter residuals fitted_values, title("Residual Diagnostics") yline(0)


xtreg Crypto inf Int GDP IPR CNY INR USD EUR Shock, re cluster(Country)
coefplot, drop(_cons) xline(0) title("Coefficient Plot") xlabel(, angle(45))

* Breush Pagan Test
xttest0

* Correlation Matrix

pwcorr dCrypto inf int dGDP wIPR dCNY dINR dUSD dEUR, obs
matrix corr_matrix = r(C)
heatplot corr_matrix, title("Correlation Heatmap")
