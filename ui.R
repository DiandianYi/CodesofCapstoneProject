#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(shinycssloaders)
# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Data Science Capstone: Word Prediction"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Inputs"),
            textInput("PriorText",
                      "Please text more than 2 words in English:",
                      value = "good luck"),
            sliderInput("NumberOfPredictions",
                        "Please input that how many top likely predictions you'd like to get:",
                        min = 1,
                        max = 10,
                        value = 3),
            submitButton("Apply Inputs")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            
            tabsetPanel(type = "tabs",
                        tabPanel("Predictions", 
                                 h4("The possible next words according to your prior input:"),
                                 verbatimTextOutput("PredictedText")%>% withSpinner(color="#0dc5c1"),
                                 h4("Word cloud for all possible matches:"),
                                 plotOutput("WordCloud")%>% withSpinner(color="#0dc5c1")),
                        tabPanel("Instruction", 
                                 hr(),
         
        
                                 p(em("This is a web application which can predict the next word according to the prior sequence of words.
                                    To use the application, you can follow below steps:")),

                                 br(),
                                 p(em("1. Input more than 2 english words on the left;")),
                                 p(em("2. Use the slider to choose how many predictions you'd like to get. If you choose, for example, 3 here, the
                                    application would provide 3 most possible predictions for the next one word and rank them from the most likely one to the least
                                    likely one.")),
                                 br(),
                                 p(em("Interested in the algorithm and the data source? you can check:")),
                                 a(href="https://rpubs.com/Yidd/614867", "Word prediction model for Data Science Capstone.")
          
            )  
          
            
        )
        
        
            
        
    )
)))
