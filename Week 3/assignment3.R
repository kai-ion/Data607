---
  title: "Lab 1: Intro to R"
author: "Cai Lin"
date: "`r Sys.Date()`"
output: pdf_document
---
  
  ```{r load-packages, message=FALSE}
library(tidyverse)
library(openintro)
```

### Dr. Arbuthnot’s Baptism Records
```{r Dr. Arbuthnot’s Baptism Records}
data('arbuthnot', package='openintro')
arbuthnot
glimpse(arbuthnot)
```
### Some Exploration
access the data in a single column of a data frame separately
```{r }
arbuthnot$boys
```

### Exercise 1

```{r view-girls-counts}
arbuthnot$girls
```


### Data visualization
R has some powerful functions for making graphics. We can create a simple plot of the number of girls baptized per year with the command
```{r }
ggplot(data = arbuthnot, aes(x = year, y = girls)) + 
  geom_point()

```
if you wanted to visualize the above plot using a line graph, you would replace geom_point() with geom_line().
```{r }
ggplot(data = arbuthnot, aes(x = year, y = girls)) + 
  geom_line()

```
You might wonder how you are supposed to know the syntax for the ggplot function
```{r }
?ggplot
```


### Exercise 2

Insert any text here.

```{r trend-girls}
# Insert code for Exercise 2 here
# Plot the number of girls baptized over the years
ggplot(arbuthnot, aes(x = year, y = girls)) +
  geom_line() + 
  geom_point() +
  labs(title = "Number of Girls Baptized Over the Years",
       x = "Year",
       y = "Number of Girls Baptized") +
  theme_minimal()
```
Interpretation:
  When you plot the number of girls baptized over the years, you will observe a general increase in the number of girls baptized over time, with some fluctuations along the way. This increase might indicate growing population size or changing social or cultural patterns. However, there could also be cyclical trends or sharp changes based on specific events in history, such as plagues or changes in religious practices.


### R as a big calculator
```{r }
5218 + 4683
```
to see the total number of baptisms in 1629. We could repeat this once for each year, but there is a faster way. If we add the vector for baptisms for boys to that of girls, R will compute all sums simultaneously.
```{r }
arbuthnot$boys + arbuthnot$girls
```
#### Adding a new variable to the data frame
We’ll be using this new vector to generate some plots, so we’ll want to save it as a permanent column in our data frame.
The %>% operator is called the piping operator. It takes the output of the previous expression and pipes it into the first argument of the function in the following one. To continue our analogy with mathematical functions, x %>% f(y) is equivalent to f(x, y).
``` {r }
arbuthnot <- arbuthnot %>%
  mutate(total = boys + girls)
ggplot(data = arbuthnot, aes(x = year, y = total)) + 
  geom_line()



```

### Exercise 3

Now, generate a plot of the proportion of boys born over time. What do you see?
  
  ```{r plot-prop-boys-arbuthnot}
# Insert code for Exercise 3 here
# Plot the proportion of boys born over time
arbuthnot <- arbuthnot %>%
  mutate(boy_ratio = boys / total)

ggplot(data = arbuthnot, aes(x = year, y = boy_ratio)) + 
  geom_line() + 
  geom_point() +
  labs(title = "Proportion of Boys Born Over Time",
       x = "Year",
       y = "Proportion of Boys Born") +
  theme_minimal()
```
You may observe:
  
  The ratio fluctuating around 0.5, which is typical for gender distribution in large populations.
There might be slight fluctuations or trends, which could be influenced by demographic or historical factors, though these changes are likely subtle given the general balance between boys and girls.

### More Practice

``` {r more practice}
data('present', package='openintro')
arbuthnot %>%
  summarize(min = min(boys), max = max(boys))
```

### Exercise 4

What years are included in this data set? What are the dimensions of the data frame? What are the variable (column) names?
  
  ```{r dim-present}
# Insert code for Exercise 4 here
# Check the years included in the dataset
present %>%
  summarize(min_year = min(year), max_year = max(year))

# Check the dimensions of the dataset
dim(present)
# Check the column names
colnames(present)
```


### Exercise 5

How do these counts compare to Arbuthnot’s? Are they of a similar magnitude?
  
  ```{r count-compare}
# Insert code for Exercise 5 here
# Min and max values for boys in Arbuthnot dataset
arbuthnot_boys_range <- arbuthnot %>%
  summarize(min_boys = min(boys), max_boys = max(boys))

# Min and max values for boys in Present dataset
present_boys_range <- present %>%
  summarize(min_boys = min(boys), max_boys = max(boys))

# Display results
arbuthnot_boys_range
present_boys_range
```
For the arbuthnot dataset, you should see a range of boy birth counts between 2,890 and 8,426, as you saw previously.
For the present dataset, the counts of boy births will likely be much larger, with values potentially reaching the tens or hundreds of thousands, reflecting the much larger population of the United States in the modern era.

The counts in the present dataset will likely be of a much higher magnitude than the counts in the arbuthnot dataset due to the difference in time periods and population sizes. This comparison illustrates how population size and data coverage have grown over the centuries.

### Exercise 6

Make a plot that displays the proportion of boys born over time. What do you see? Does Arbuthnot’s observation about boys being born in greater proportion than girls hold up in the U.S.? Include the plot in your response. Hint: You should be able to reuse your code from Exercise 3 above, just replace the dataframe name.

```{r plot-prop-boys-present}
# Insert code for Exercise 6 here

# Calculate the proportion of boys born each year in the present dataset
present <- present %>%
  mutate(total = boys + girls, boy_ratio = boys / total)

# Plot the proportion of boys born over time for the present dataset
ggplot(data = present, aes(x = year, y = boy_ratio)) + 
  geom_line() + 
  geom_point() +
  labs(title = "Proportion of Boys Born Over Time (U.S.)",
       x = "Year",
       y = "Proportion of Boys Born") +
  theme_minimal()
```
Proportion of boys: The proportion of boys born may fluctuate slightly but will generally hover around 0.51 to 0.52, as the ratio of boys to girls at birth is typically close to 1:1, but slightly in favor of boys.
Comparison with Arbuthnot's observation: In the case of Arbuthnot's dataset (historical data from the 1600s), the proportion of boys born was often observed to be slightly greater than 0.5. In modern times (the present dataset), the boy ratio is still typically above 0.5, but the variation might be smaller, and the proportions might be more stable.
Arbuthnot's observation that more boys are born than girls still holds true in modern-day U.S. birth records, but the proportions are much closer to 50/50 compared to the more pronounced difference observed in historical records.

### Exercise 7

In what year did we see the most total number of births in the U.S.? Hint: First calculate the totals and save it as a new variable. Then, sort your dataset in descending order based on the total column. You can do this interactively in the data viewer by clicking on the arrows next to the variable names. To include the sorted result in your report you will need to use two new functions: arrange (for sorting). We can arrange the data in a descending order with another function: desc (for descending order). The sample code is provided below.
```{r find-max-total}
# Insert code for Exercise 7 here
# Calculate the total births each year
present <- present %>%
  mutate(total = boys + girls)

# Sort the dataset in descending order based on the total column
most_births_year <- present %>%
  arrange(desc(total)) %>%
  slice(1)  # Get the first row (the year with the most total births)

# View the year with the most total births
most_births_year
```
1961	

