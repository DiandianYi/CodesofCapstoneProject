#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RColorBrewer)
library(wordcloud)
library(data.table)
library(tidyverse)
library(quanteda)
library(tidytext)
library(data.table)

uni_freplot <- readRDS("uni_freplot.rds")
bi_prefreq <- readRDS("bi_prefreq.rds")
tri_preqreq <- readRDS("tri_preqreq.rds")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    matchedrows_bi <- reactive({
        text0 <- tokens(input$PriorText, what = "word", 
                           remove_numbers = TRUE, remove_punct = TRUE, 
                           remove_symbols = TRUE, split_hyphens = TRUE)
        text1 <- tokens_tolower(text0)
        text2 <- tokens_select(text1, stopwords(), selection = "remove")
        text_unigram <- tokens_wordstem(text2, language = "english")
        bi_prefreq[bi_prefreq$Prior == unlist(text_unigram)[length(unlist(text_unigram))],]
        })
    
    matchedrows_tri <- reactive({
        text0 <- tokens(input$PriorText, what = "word", 
                        remove_numbers = TRUE, remove_punct = TRUE, 
                        remove_symbols = TRUE, split_hyphens = TRUE)
        text1 <- tokens_tolower(text0)
        text2 <- tokens_select(text1, stopwords(), selection = "remove")
        text_unigram <- tokens_wordstem(text2, language = "english")
        text_bigram <- tokens_ngrams(text_unigram, n=2)
        tri_preqreq[tri_preqreq$Prior == unlist(text_bigram)[length(unlist(text_bigram))],]
        })
    
    output$PredictedText <- renderPrint({
    if (is.data.frame(matchedrows_tri()) && nrow(matchedrows_tri())!=0) {
        (matchedrows_tri()[order(-matchedrows_tri()$Frequency),][1:input$NumberOfPredictions,"Prediction"])
    } else {
        if (is.data.frame(matchedrows_bi()) && nrow(matchedrows_bi())!=0) {
            (matchedrows_bi()[order(-matchedrows_bi()$Frequency),][1:input$NumberOfPredictions,"Prediction"]) 
        } else {
            (unname(uni_freplot[order(-uni_freplot$Frequency),][1:input$NumberOfPredictions,"Features"]))
        }
    }
    })
    
    output$WordCloud <- renderPlot({
    if (is.data.frame(matchedrows_tri()) && nrow(matchedrows_tri())!=0) {
        wordcloud(matchedrows_tri()$Prediction,matchedrows_tri()$Frequency,min.freq = 1,
                  max.words=200, random.order=FALSE, rot.per=0.35, 
                  colors=brewer.pal(8, "Dark2"))
    } else {
        if (is.data.frame(matchedrows_bi()) && nrow(matchedrows_bi())!=0) {
            wordcloud(matchedrows_bi()$Prediction,matchedrows_bi()$Frequency,min.freq = 1,
                      max.words=200, random.order=FALSE, rot.per=0.35, 
                      colors=brewer.pal(8, "Dark2"))
        } else {
            wordcloud(uni_freplot$Features[1:100],uni_freplot$Frequency[1:100],min.freq = 1,
                      max.words=200, random.order=FALSE, rot.per=0.35, 
                      colors=brewer.pal(8, "Dark2"))
        }
    }  
    })
    
    })


