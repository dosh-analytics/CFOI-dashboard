install.packages("ggplot2")
install.packages("ggrepel")
install.packages("RCurl")
install.packages("bslib")
library("ggplot2")
library("RCurl")
library("shiny")
library("bslib")
library("ggrepel")

## Fatality Data 

urlfile <-("https://raw.githubusercontent.com/dosh-analytics/CFOI-dashboard/refs/heads/main/Raw_Fatality_Data.csv?token=GHSAT0AAAAAADJDWGIKO5QAABD24RGMN6FA2FDTBUQ")
df_data<-read.csv('/Users/ryan/Documents/GitHub/CFOI-dashboard/Raw_Fatality_Data.csv')

## Subset All Data

df_totals <- subset(df_data, class=="Totals")

df_rate <- subset(df_data, class=='Rates')

df_gender <- subset(df_data, class=='Gender')
df_gender$Label <- factor(df_gender$Label, levels=c('Women', 'Men'))

df_age <- subset(df_data, class=='Age')
df_age_current <-subset(df_age, Year=="2023")
df_age_previous <-subset(df_age, Year=="2022")

df_race <-subset(df_data, class=="Race")
df_race_current <-subset(df_race, Year=="2023")
df_race_previous <-subset(df_race, Year=="2022")

df_employment <-subset(df_data, class=="Employee_Status")
df_employment_current <-subset(df_employment, Year=="2023")

df_causes <-subset(df_data, class=="Causes")
df_causes_current <-subset(df_causes, Year=="2023")
df_causes_previous <-subset(df_causes, Year=="2022")

df_industry <-subset(df_data, class=="Industry")
df_industry_current <-subset(df_industry, Year=="2023")
df_industry_previous <-subset(df_industry, Year=="2022")

df_occupation <-subset(df_data, class=="Occupation")
df_occupation_current <-subset(df_occupation, Year=="2023")
df_occupation_previous <-subset(df_occupation, Year=="2022")

## Figure 1 -- California Fatal Occupational Injuries Within the Scope of CFOI

figure1 <- ggplot(data=df_totals, aes(x=year, y=count)) +
  scale_x_continuous(breaks=1999:2023) +
  geom_bar(stat="identity", fill="#9098CF") +
  geom_line(linewidth=1, color = '#B94700') + 
  geom_text(aes(label=count), vjust=4.0, color="black", size=4.5) +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(
    x = "Year",
    y = "Fatal Occupational Injuries",
    title = "California Fatal Occupational Injuries Within the Scope of CFOI (1999-2023)"
  )

## Figure 2 -- California and U.S. Occupational Fatality Rate (per 100,000 workers)

figure2 <- ggplot(data=df_rate, aes(x=year, y=count, group=label, color=label, shape = label)) +
  geom_line() + 
  geom_point(size = 3) + 
  guides(color = guide_legend(override.aes = list(linetype = c('solid', 'solid'), shape = c(15, 16))), shape = 'none') + 
  scale_x_continuous(breaks=2013:2023) +
  labs(
    x = "Year",
    y = "Rate of Occupational Injury Per 100,000",
    color = "",
    title = "California and U.S. Occupational Fatality Rate (per 100,000 Workers)"
  ) + 
  geom_text(aes(label = count, vjust=-1.25, size=4), show.legend = FALSE) + ylim(0, 4) +
  theme(legend.key.size = unit(2, 'cm'), legend.text = element_text(size=12), legend.position="bottom") +
  scale_shape_manual(values = c(15,16)) + 
  scale_color_manual(values=c('#25408F', '#B94700')) + 
  theme(plot.title = element_text(hjust = 0.5))

## Figure 3 -- Gender

figure3 <- ggplot(df_gender, aes(x = year, y = count, fill = label)) + 
  geom_bar(stat = "identity", position="stack") +
  geom_label(aes(label = count, size = 6), position = position_stack(vjust = 0.5), show.legend = FALSE) +
  scale_y_continuous(limits = c(0,550), breaks=c(0, 100, 200, 300, 400, 500, 500)) + 
  scale_x_continuous(breaks=2009:2023) + 
  scale_fill_manual(values=c("#FFD41C", "#6ECAC8")) + 
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(
    x = "Year",
    y = "Fatal Occupational Injuries",
    title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Gender",
    fill = 'Gender'
  )

## Figure 4a -- Current Year Age Pie Chart

figure4a <- ggplot(df_age_current, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Occupation Groups', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Age Distribution in 2023")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 4b -- Previous Year Age Pie Chart

figure4b <- ggplot(df_age_previous, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Occupation Groups', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Age Distribution in 2022")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 5a -- by Race/Ethnicity Over Time



figure5a <- ggplot(df_race,aes(x = year, y = count, group = label, color = label, pattern = label)) + 
  geom_line(linewidth=1) + 
  geom_label_repel(aes(label = label), max.overlaps = 1, nudge_x = 1, na.rm = TRUE) + 
  geom_point(size=3) + 
  theme(plot.title = element_text(hjust = 0.5)) +
  coord_cartesian(xlim=c(2013,2023)) + 
  labs(
    x = "Year",
    y = "Fatal Occupational Injuries",
    color = "",
    title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Race/Ethnicity (2013-2023)"
  ) + 
  theme(legend.position="bottom")

## Figure 5b1 -- Race Pie Chart Current Year

ggplot(df_race_current, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Race or Ethnic Origin', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Race/Ethnicity (2023)")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 5b2 -- Race Pie Chart Previous Year

ggplot(df_race_previous, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Race or Ethnic Origin', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Race/Ethnicity (2022)")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 6a -- Current Year Percentage Pie Chart -- NOT QUITE RIGHT, FIX MATH

ggplot(df_employment_current, aes(x = "", y = count, fill = label)) +
  geom_col() +   
  geom_text(aes(label = format(paste0(round(count, 3) * 100, '%'), digits = 3, big.mark = ",")), 
            position = position_stack(vjust = 0.5)) +
  theme_void() + 
  coord_polar(theta = "y") +
  labs(
    fill = "Employee Status"
  ) + 
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_manual(values = c("#9D9FA2", "#9098CF")) + 
  ggtitle("Worker Status")


#Figure 6b -- Employment Status Over Time Stacked Bar Chart

ggplot(df_employment, aes(x = year, y = count, fill = label)) + 
  geom_bar(stat = "identity", position="stack") +
  geom_label(aes(label = count, size = 6), position = position_stack(vjust = 0.5), show.legend = FALSE) +
  scale_y_continuous(limits = c(0,550), breaks=c(0, 100, 200, 300, 400, 500, 500)) + 
  scale_x_continuous(breaks=2009:2023) + 
  scale_fill_manual(values=c("#FFD41C", "#6ECAC8")) + 
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(
    x = "Year",
    y = "Fatal Occupational Injuries",
    title = "California Fatal Occupational Injuries by Employment Status",
    fill = 'Employment Status'
  )


## Figure 7a -- Fatal Injuries by Event All Time

ggplot(df_causes,aes(x = year, y = count, group = label, color = label, pattern = label)) + 
  geom_line(linewidth=1) + 
  geom_point(size=3) + 
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_continuous(breaks=2013:2023) + 
  labs(
    x = "Year",
    y = "Fatal Occupational Injuries",
    color = "",
    title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Event (2013-2023)"
  ) + 
  theme(legend.position="bottom")

## Figure 7c1 -- Fatal Injuries by Event, Current Year

ggplot(df_causes_current, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Causes of Fatal Events', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Event 2023")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 7c2 -- Fatal Injuries by Event, Previous Year

ggplot(df_causes_previous, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Causes of Fatal Events', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Event 2022")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 9a -- Fatal Injuries by Industry All Time

ggplot(df_industry,aes(x = year, y = count, group = label, color = label, pattern = label)) + 
  geom_line(linewidth=1) + 
  geom_point(size=3) + 
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_continuous(breaks=2013:2023) + 
  labs(
    x = "Year",
    y = "Fatal Occupational Injuries",
    color = "",
    title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Industry (2013-2023)"
  ) + 
  theme(legend.position="bottom")

## Figure 9b1 -- Fatal Injuries by Industry, Current Year

ggplot(df_industry_current, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Industry', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink", "red","brown")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Industry 2023")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 9b2 -- Fatal Injuries by Industry, Previous Year

ggplot(df_industry_previous, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Industry', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink", "red","brown")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Industry 2022")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 10 -- Fatal Injuries by Year, All Time, per 100,000 workers



## Figure 11 -- Occupation Data All Time (NOT PUBLISHED)

ggplot(df_occupation,aes(x = year, y = count, group = label, color = label, pattern = label)) + 
  geom_line(linewidth=1) + 
  geom_point(size=3) + 
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_continuous(breaks=2013:2023) + 
  labs(
    x = "Year",
    y = "Fatal Occupational Injuries",
    color = "",
    title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Occupation (2013-2023)"
  ) + 
  theme(legend.position="bottom")

## Figure 11a -- Fatal Injuries by Occupation, Current Year

ggplot(df_occupation_current, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Occupation Groups', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink", "red","brown")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Occupation 2023")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 11b -- Fatal Occupational Injuries by Occupation, Previous Year

ggplot(df_occupation_previous, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Occupation Groups', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink", "red","brown")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Occupation 2022")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 