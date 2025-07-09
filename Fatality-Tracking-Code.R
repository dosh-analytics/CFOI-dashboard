install.packages("ggplot2")
library("ggplot2")
install.packages("RCurl")
library("RCurl")

urlfile <-("https://raw.githubusercontent.com/dosh-analytics/CFOI-dashboard/refs/heads/main/Raw%20Fatality%20Data.csv?token=GHSAT0AAAAAADHC4JL2LVAH5HEGEYGJFFS22DO7C3Q")
df_data<-read.csv(urlfile)


## Subset Total Death Data

df_totals <- subset(df_data, class=="Totals")

## Figure 1 -- California Fatal Occupational Injuries Within the Scope of CFOI

ggplot(data=df_totals, aes(x=year, y=count)) +
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

## Subset Rate Data

df_rate <- subset(df_data, class=='Rates')

## Figure 2 -- California and U.S. Occupational Fatality Rate (per 100,000 workers)

ggplot(data=df_rate, aes(x=year, y=count, group=label, color=label, shape = label)) +
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

## Subset Gender Data

df_gender <- subset(df_data, class=='Gender')
df_gender$label <- factor(df_gender$label, levels=c('Women', 'Men'))

## Figure 3 -- Gender

ggplot(df_gender, aes(x = year, y = count, fill = label)) + 
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

## Subset Age Data

df_age <- subset(df_data, class=='Age')

## Figure 4a -- Current Year Age Pie Chart

df_age_current <-subset(df_age, year=="2023")

ggplot(df_age_current, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Occupation Groups', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Age Distribution in 2023")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Figure 4b -- Previous Year Age Pie Chart

df_age_previous <-subset(df_age, year=="2022")

ggplot(df_age_previous, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Occupation Groups', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Age Distribution in 2022")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Subset Race Data

df_race <-subset(df_data, class=="Race")

## Figure 5a -- by Race/Ethnicity Over Time

install.packages("ggrepel")                     # Install ggrepel package
library("ggrepel")                              # Load ggrepel

ggplot(df_race,aes(x = year, y = count, group = label, color = label, pattern = label)) + 
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

df_race_current <-subset(df_race, year=="2023")

ggplot(race_data_2023, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Race or Ethnic Origin', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Race/Ethnicity (2023)")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 


## Figure 5b2 -- Race Pie Chart Previous Year

df_race_previous <-subset(df_race, year=="2022")

ggplot(df_race_previous, aes(x = "", y = count, fill = label)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_manual('Race or Ethnic Origin', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  theme_void() + 
  ggtitle("Fatal Occupational Injuries by Race/Ethnicity (2022)")  +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), color = "black", show.legend = FALSE) 

## Subset Employment Data 

df_employment <-subset(df_data, class=="Employee_Status")


## Figure 6a -- Current Year Percentage Pie Chart -- NOT QUITE RIGHT, FIX MATH

df_employment_current <-subset(df_employment, year=="2023")

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











## Figures 11x -- Occupation Data

occupation_data <-subset(df_data, class=="Occupation" & year==2023)

ggplot(occupation_data,aes(x = "", y = count, fill = label )) +
  geom_col() +
  coord_polar(theta = "y") +
  theme_void() + 
  scale_fill_manual('Occupation Groups', values = c("#9D9FA2", "#9098CF", "#F2EEDD", "#00A8E0", "#6ECAC8", "#94C83D", "#FFD41C", "pink")) +  
  ggtitle("Fatal Occupational Injuries by Occupation 2023") +
  geom_label(aes(label = count),
             position = position_stack(vjust = 0.5), show.legend = FALSE) 