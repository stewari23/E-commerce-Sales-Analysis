# Load necessary libraries
library(ggplot2)
library(dplyr)

# Assuming the dataset has already been cleaned using SQL, we read it in as 'cleaned_data'
# Example: cleaned_data <- read.csv("cleaned_ecommerce_data.csv")

# Checking and Handling Outliers
# This code removes outliers based on the IQR method for the 'Quantity' column
q <- quantile(cleaned_data$Quantity, c(0.25, 0.75))  # Calculate quartiles
iqr <- 1.5 * (q[2] - q[1])  # Interquartile range
cleaned_data <- cleaned_data %>%
  filter(Quantity >= (q[1] - iqr) & Quantity <= (q[2] + iqr))  # Remove outliers

# Format Invoice Date to POSIXct for date-time operations
cleaned_data$InvoiceDate <- as.POSIXct(cleaned_data$InvoiceDate, format="%Y-%m-%d %H:%M:%S")

# Calculate Total Sales per Invoice
cleaned_data$TotalSales <- cleaned_data$Quantity * cleaned_data$UnitPrice

# Total Sales and Unique Customers
total_sales <- sum(cleaned_data$TotalSales)  # Calculate total sales
unique_customers <- length(unique(cleaned_data$CustomerID))  # Count unique customers

# Output Total Sales and Unique Customers
print(paste("Total Sales: ", total_sales))
print(paste("Unique Customers: ", unique_customers))

# Visualization: Top 10 Countries by Total Sales
# Summarize sales by country and select the top 10 countries
top_countries <- cleaned_data %>%
  group_by(Country) %>%
  summarise(TotalSales = sum(TotalSales)) %>%
  arrange(desc(TotalSales)) %>%
  top_n(10, wt = TotalSales)

# Create a bar plot for the top 10 countries by total sales
ggplot(top_countries, aes(x = reorder(Country, -TotalSales), y = TotalSales)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  xlab("Country") +
  ylab("Total Sales") +
  ggtitle("Top 10 Countries by Total Sales") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# You can save the plot if needed:
# ggsave("top_10_countries_by_sales.png")
