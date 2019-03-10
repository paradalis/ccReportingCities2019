# hit the run button to activate this script
setwd("/Users/jen/Documents/OneDrive/UBC/RA/Publications/data/Rdata")
getwd()

#set up libraries
library()
#for each that are not there:
library(readxl)
library(grid) #this is the same as require(grid)
library(scales)library(lib = .Library)
library("grid", lib.loc="/Library/Frameworks/R.framework/Versions/3.3/Resources/library")
library("scales", lib.loc="/Library/Frameworks/R.framework/Versions/3.3/Resources/library")
library(ggplot2)
# only if the library is not there, then use this one:
# install.packages("ggplot2")
library("ggplot2", lib.loc="/Library/Frameworks/R.framework/Versions/3.3/Resources/library")

# load your data, but first see what you already have:
ls()
rdatacities <- read_excel("~/Documents/OneDrive/UBC/RA/Publications/data/Rdata/rdatacities.xlsx")
rdatacities_nobasemissions <- read_excel("~/Documents/OneDrive/UBC/RA/Publications/data/Rdata/rdatacities_nobasemissions.xlsx")
rdatanation <- read_excel("~/Documents/OneDrive/UBC/RA/Publications/data/Rdata/rdatanation.xlsx", 
                          col_types = c("text", "text", "numeric", 
                                        "numeric", "numeric", "numeric", 
                                        "numeric", "numeric", "numeric", 
                                        "text","text","numeric"))

# you should now have 3 sets of data: rdatacities, rdatanation, and rdatacities_nobasemissions
ls()
dim(rdatacities)
str(rdatacities)
str(rdatanation)
#check to be sure that variables are in proper form
rdatanation$target <- as.numeric(as.character(rdatanation$target))
apply(rdatanation, 2, class)
summary(rdatacities)
autoplot(rdatacities$region)
# dot plot instructions http://www.sthda.com/english/wiki/ggplot2-dot-plot-quick-start-guide-r-software-and-data-visualization
ggplot(rdatacities, aes(region, target))
p<-ggplot(rdatacities, aes(region, target))
plot


#no minor ticks
#f_labels1 <- data.frame(region = c("a", "b", "c"), label = c("Region", "", ""))
#setting the plot data for cities by nation, clustered by region
p2<-ggplot(data=rdatacities, aes(x=country, y=target, size=citiesorig)) +
  geom_point(shape=21, alpha=.6, stroke=.75) + #municipal targets
  facet_grid(region ~ ., scales = "free_y", space = "free_y") #regional clusters
#overlay national targets on top
p3 <- p2 + geom_point(data=rdatanation, shape=0, size=2.5, stroke=1, aes(colour='red')) #national targets
#setting the plot theme (appearance)
plot <- p3 + theme(
  plot.title = element_text(hjust=0.5), legend.key=element_rect(fill='white'), 
  panel.background = element_blank(), plot.margin = margin(2), 
  axis.ticks.y = element_blank(), panel.grid.major.y= element_line(size=.2, linetype='solid', colour='grey'), 
  axis.text.y = element_text(size=6),
  panel.grid.major.x= element_blank(),  axis.line.x = element_blank(), 
  axis.ticks.x=element_line(color='black'),
  #aspect.ratio=1/5, #tried this didn't work
  strip.background=element_rect(fill = NA, size = 0, color = "white", linetype = "blank")
) + 
  #coord_fixed(ratio=1/500) + #new one for fixing y axis spacing #tried this didn't work
  scale_y_continuous(name="Target by 2030 as Percent of Base Year", labels = percent) +
  scale_x_discrete(name="Country", expand=waiver()) +
  coord_flip(ylim = c(0, 3)) +
  ggtitle("National vs. Municipal GHG Emissions Targets") +
  guides(colour = guide_legend(order = 1, "Targets"),
         size = guide_legend(order = 2, "Municipalities", override.aes=list(size=seq(1,5) )) ) +
  scale_color_manual(name="Targets", labels = c("National"), values = c('#843C0C'))
#putting the data and the appearance together into one plot
plot
