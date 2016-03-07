# set up work
library(shiny)
library(ggplot2)
library(plyr)
nba <- read.csv("nba_atleast100threes.csv", stringsAsFactors = FALSE)
nba <- nba[order(nba$name),]
nba$shot_made_flag <- as.factor(nba$shot_made_flag) # 0 for missed, 1 for made
nba$shot_clock <- as.numeric(nba$shot_clock) # divide this into intervals
nba$shotClkInt <- round_any(nba$shot_clock / 6, 1, f=floor) # 4 intervals
nba$shotClkInt[nba$shotClkInt==4] <- 3 # make shot clock of 24, fit into interval 3
nba$shotClkInt <- as.factor(nba$shotClkInt)
nba$dribbles <- as.numeric(nba$dribbles)
nba$shot_distance <- as.numeric(nba$shot_distance)

# server #
shinyServer(function(input, output) {
    
    player <- reactive({
        input$Select
    })
    
    shotdist <- reactive({
        input$Slider1
    })
    
    output$text <- renderText({
       paste(player(), "vs. NBA 3-PT Shots of Qualified Players")
    })
    
    output$view <- renderPlot({
        ggplot() + geom_boxplot(data=nba[nba$shot_distance >= shotdist(),], 
                                aes(shotClkInt, dribbles, fill=shot_made_flag)) +
            geom_jitter(data=nba[nba$name==player() & nba$shot_distance >= shotdist(),], 
                        aes(shotClkInt, dribbles, colour=shot_made_flag, shape=shot_made_flag), 
                        size=5) +
            scale_fill_discrete(name = "Shot Attempts of Qualified Players", breaks=c("0", "1"),
                                labels=c("Shots Missed", "Shots Made")) +
            scale_colour_manual(name = paste0(sub("^(\\w+)\\s?(.*)$", "\\2", player()), "Shot Attempts"), 
                                breaks=c(0, 1), labels=c("Shot Missed", "Shot Made"),
                                values=c("brown", "green")) +
            scale_shape_manual(name = paste0(sub("^(\\w+)\\s?(.*)$", "\\2", player()), "Shot Attempts"), 
                               breaks=c(0, 1), labels=c("Shot Missed", "Shot Made"),
                               values=c(4, 19)) +
            scale_x_discrete(name="Shot Clock Intervals (seconds)", 
                             labels=c("0-6", "7-12", "13-18", "19-24")) +
            scale_y_discrete(name="Number of Dribbles Before Shot Attempt") + ylim(c(0, 35)) +
            theme(axis.title.x=element_text(size=18), axis.text.x=element_text(size=13),
                  axis.title.y=element_text(size=18), axis.text.y=element_text(size=13))
    })
})