#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h1("H1 Text"),
            h2("H2 Text"),
            h3("H3 Text"),
            em("Move the slider"),
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            h3("slider example 2"),
            numericInput("numeric", "How many random numbers should be ploted",
                         value=1000, min=1, max=1000, step=1),
            sliderInput("sliderX", "Pick minimum and maximum X values",
                        -100,100, value = c(-50,50)),
            sliderInput("sliderY",  "Pick minimum and maximum Y values",
                        -100,100, value = c(-50,50)),
            checkboxInput("show_xlab", "Show/Hide X axis label", value=TRUE),
            checkboxInput("show_ylab", "Show/Hide Y axis label", value=TRUE),
            checkboxInput("show_title", "Show/Hide", value=TRUE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3("Main Panel text"),
            code("Some Code!"),
            plotOutput("distPlot"),
            textOutput("text1"),
            h3("Graph of random points"),
            plotOutput("plot1")
    
        )
    )
))


