# Developing Data Products

# Week 1 (24-01-2024)


# Shiny, Shiny-Gadget, GoogleVis, Plotly, RMarkdown, Swirl, Rpackages

# HTML - Webpage structure
# CSS - Style
# Javascript - Interaction


library(shiny)
# Files 
# - ui.R - user interface - control how app looks, 
# 0 server.R - controls what the app does

setwd("C:/Users/LefMel/Documents/Courses/Coursera/Developing Data Products/app_2")
runApp()


# HTML tags in Shiny

# Heading - h1() through h6()
# Hyper-refs p() 
# a(), div(), span()
# em() - emphasized text
# code() - code format

?builder

# Reactive - expressions subject to change (is like creating a function)

calc_sum <- reactive({
  input$box1 + input$box2 
})

# ....

calc_sum()

setwd("C:/Users/LefMel/Documents/Courses/Coursera/Developing Data Products/TestApp3")
runApp()


# Brush argument to visualize many models

# brush argument in plotOutput() - ui.R
# brushedPoints - server.R


# brushedPoints() 
# --- returns rows from a data frame which are under a brush.

# Shiny Gadget


library(shiny)
library(miniUI)

# First example
myFirstGadget <- function(){
  
  ui <- miniPage(
    gadgetTitleBar("My first Gadget")
  )
  server <- function(input, output, session){
    
    observeEvent(input$done, {
      stopApp()
    })
  }
  runGadget(ui, server)
}


# Second example
multiplynumbers <- function(numbers1, numbers2){
  ui <- miniPage(
    gadgetTitleBar("Multiply two numbers"),
    miniContentPanel(
      selectInput("num1", "First number", choices = numbers1),
      selectInput("num2", "Second number", choices = numbers2)
    )
  )
  server <- function(input, output, session){
    observeEvent(input$done, {
      num1 <- as.numeric(input$num1)
      num2 <- as.numeric(input$num2)
      stopApp(num1 * num2)
    })
  }
  runGadget(ui, server)
}

multiplynumbers(1:10, 1:10)

# Third example - Gadgets with interactive graphics

pickTrees <- function(){
  ui <- miniPage(
    gadgetTitleBar("Select points by dragging your mouse"),
    miniContentPanel(
      plotOutput("plot", height="100%", brush="brush")
    )
  )
  server <- function(input, output, session){
    
    output$plot <- renderPlot({
      plot(trees$Girth, trees$Volume, main="Trees!",
           xlab="Girth", ylab="Volume")
    })
    observeEvent(input$done,{
      stopApp(brushedPoints(trees, input$brush,
                            xvar="Girth", yvar="Volume"))
    })
  }
  runGadget(ui, server)
}

pickTrees()

treesIpicked <- pickTrees()
treesIpicked


# GoogleVis

# Motion charts, Interactive maps, Interactive tables, Line charts, Bar charts, Tree maps
install.packages("googleVis")
library(googleVis)
suppressPackageStartupMessages(library(googleVis))
Fruits
M <- gvisMotionChart(Fruits, "Fruit", "Year",
                     options=list(width=600, height=400))
plot(M)

#Warning message:
#Flash charts are no longer supported by most browsers.
#An alternative is plotly::ggplotly.
plotly::ggplotly(M)
print(M, "chart")

Exports
# specifying a region
G <- gvisGeoChart(Exports, locationvar = "Country",
                  colorvar="Profit", options=list(width=600, height=400, region=150))
plot(G)

df <- data.frame(label=c("Us", "GB", "BR"), val1 = c(1,3,4), val2=c(23,12,32))
Line <- gvisLineChart(df, xvar="label", yvar=c("val1", "val2"),
                      options=list(title="Hello World", legend="bottom"))
plot(Line)

# combine multiple plots together
G <- gvisGeoChart(Exports, locationvar = "Country",colorvar="Profit", options=list(width=600, height=400, region=150))
T1 <- gvisTable(Exports, options=list(width=200, height=270))
M <- gvisMotionChart(Fruits, "Fruit", "Year",options=list(width=600, height=400))
GT <- gvisMerge(G,T1, horizontal = FALSE)
GTM <- gvisMerge(GT, M, horizontal = TRUE, tableOptions = "bgcolot=\"CCCCC\" cellspacing=10")
plot(GTM)
print(GTM, "chart")

# results = "asis" in the chunk options in R markdown documents


# Plotly
library(plotly)
data(mtcars)
names(mtcars)

# Scatterplot
plot_ly(data=mtcars, x = mtcars$wt, y = mtcars$mpg, mode="markers", color = as.factor(mtcars$cyl))
plot_ly(data=mtcars, x = mtcars$wt, y = mtcars$mpg, mode="markers", color = mtcars$disp)
plot_ly(data=mtcars, x = mtcars$wt, y = mtcars$mpg, mode="markers", color = as.factor(mtcars$cyl), size=mtcars$hp)

set.seed(2023-08-27)
temp <- rnorm(100, mean=30, sd=5)
pressure <- rnorm(100)
dtime <- 1:100
plot_ly(x=temp, y=pressure, z = dtime, type="scatter3d", mode="markers", color=temp)

# Lines
data("airmiles")
airmiles
str(airmiles)
time(airmiles)
?plot_ly
plot_ly(x=time(airmiles), y=airmiles, mode="line")


library(tidyr)
library(dplyr)
data("EuStockMarkets")
EuStockMarkets

stocks <- as.data.frame(EuStockMarkets) %>%
  gather(index,price) %>%
  mutate(time=rep(time(EuStockMarkets),4))

plot_ly(x=stocks$time, y=stocks$price, color=stocks$index, mode="line")

# Histogram
plot_ly(x=precip, type="histogram")

# Boxplot
plot_ly(iris, y=iris$Petal.Length, color=iris$Species, type="box")

# Heatmap
terrain1 <- matrix(rnorm(100*100), nrow=100, ncol=100)
plot_ly(z=terrain1, type="heatmap")

# 3D surface
terrain2 <- matrix(sort(rnorm(100*100)), nrow=100, ncol=100)
plot_ly(z=terrain2, type="surface")

# Choropleth Maps
state_pop <- data.frame(State=state.abb, Pop = as.vector(state.x77[,1]))
state_pop$hover <- with(state_pop, paste(State, '<br>', "Population:", Pop))
borders <- list(color=toRGB("red"))
map_options <- list(
  score='usa',
  pojection = list(type="albers usa"),
  showlakes=TRUE,
  lakecolor = toRGB("white")
)

plot_ly(state_pop, z=state_pop$Pop, text=state_pop$hover, locations=state_pop$State,
        type="choropleth", locationmode="USA-states", color=state_pop$Pop,
        colors="Blues", marker=list(line=borders)) %>%
  layout(title="US Population in 1975", geo=map_options)


set.seed(100)
d <- diamonds[sample(nrow(diamonds),1000),]
d
p <- ggplot(data=d, aes(x=carat, y=price)) + 
  geom_point(aes(text=paste("Clarity:", clarity)), size=4) +
  geom_smooth(aes(colour=cut, fill=cut)) + facet_wrap(~ cut)

gg <- ggplotly(p) # ggptlot to plotly
gg

?plotly_POST # post/publish plot online



# Week 2 (27-08-2023)

# R Markdown basics also presented in Reproducible Research course

# ```{r, comment="", echo=TRUE}
# echo - prints R-code true
# eval = FALSE - do not evaluate code
# for plots: fig.align = 'center', fig.cap=' My AWESOME figure'
# ```


# Leaflet - Javascript library to create interactive maps
#install.packages("leaflet") # terra, raster
#remotes::install_github("rstudio/leaflet")
library(leaflet)

my_map <- leaflet() %>%
  addTiles()
my_map

# add markers
my_map <- leaflet() %>%
  addTiles() %>%
  addMarkers(lat=39.2980803, lng=-76.5898801,
             popup="Jeff Leek's office")
my_map

# add many markers
set.seed(2023-08-27)
df <- data.frame(lat=runif(20, min=39.2, max=39.3),
                 lng=runif(20, min=-76.7, max=-76.5))

df %>% 
  leaflet() %>%
  addTiles() %>%
  addMarkers()


#hopkingIcon <- makeIcon(url, iconWidth = , iconHeight = ,
#                        iconAnchorX = , iconAnchorY = )
#hopkingSites <- c(
# "<a href= ''>East Baltimore Campus</a>",
#
#)

# addMarkers(icon = hopkingIcon, popup=hopkinsSites)

# Mapping Clusters
set.seed(2023-08-27)
df <- data.frame(lat=runif(500, min=39.25, max=39.35),
                 lng=runif(500, min=-76.65, max=-76.55))

df %>% 
  leaflet() %>%
  addTiles() %>%
  addMarkers(clusterOptions = markerClusterOptions())

df %>% 
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers()


# addCircles(weight=1, radius = sqrt(md_cities$pop)*30)
# addRectangles(lat1=, lng1=,
#               lat2=, lng2=)
# addLegend(labels=LETTERS[1:3], colors=c("blue", "red", "green"))


# Week 3 (28-08-2023)

# R packages

# R classes and methods

# Classes - define new data types
# Methods - extend generic functions to specify the behavior of generic functions on new classes

# install.packages("DDPQuiz3") # not installed

# Week 4 (29-08-2023)
# swirl

library(swirl)
swirl()
install.packages("swirlify")
library(swirlify)
getwd()  
setwd("C:/Users/LefMel/Documents/Courses/Coursera/Developing Data Products/Swirl")
new_lesson("Lesson 1.1", "Trial Course")

wq_message()
wg_command()
add_to_manifest()
test_lesson() # test lesson
demo_lesson() # run lesson

get_current_lesson()

new_lesson("Lesson 1.2", "Trial Course")
wq_message()
wq_multiple()
add_to_manifest()
test_lesson()
demo_lesson()


# Figure type question
plot(1:10)
wq_figure()
