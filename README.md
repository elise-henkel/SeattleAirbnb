# SeattleAirbnb

### Data Overview
[Data Source](https://insideairbnb.com/get-the-data/) /
I used the Seattle listings.csv file. It contained 90 columns and 7769 rows of data.

### Part 1 - Cleaning the Data
After ensuring there were no duplicate rows, I removed all columns that contained only NA values. Additionally, many of the columns in the original dataset needed to be converted from characters to a more appropriate data type, such as a boolean or number. The remaining character columns were in good shape and did not require any data cleaning measures. Lastly, I created an individual box plot for each numeric column to check for questionable or suspicious data. All of the values seemed reasonable, so I was able to save my updated dataset for use in my Shiny app.

### Part 2 - Shiny App
