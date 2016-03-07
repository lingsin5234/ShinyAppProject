library(shiny)
nba <- read.csv("nba_atleast100threes.csv", stringsAsFactors = FALSE)
nba <- nba[order(nba$name),]

# UI #
shinyUI(fluidPage(
    titlePanel("2015-2016 NBA League Leading 3-Point Shooters"),
    
    sidebarLayout(
        sidebarPanel(
            h3("Choose Player & Shooting Distance:"),
            selectInput("Select", label=h3("Choose player"),
                        choices = lapply(unique(nba$name), unlist)),
            sliderInput("Slider1", label=h3("Min. 3-pt Range (ft)"),
                        min=22, max=46.9, value=22, step=0.1),
            width=3
        ),
        mainPanel(
            h2(textOutput("text")),
            plotOutput("view"),
            br(),
            h4("Description"),
            p(paste("The plot above shows all the NBA shots taken in the 2015-2016 season up until January 23, 2016 by NBA players who have attempted at least 100 3-pt shots this season.",
            "By looking at the number of dribbles used before each shot attempt along with the shot clock time remaining, we can see how many shots are created by the player (those with more dribbles), and shots taken shortly after receiving a pass.",
            "Going through the list of qualified players, you will see that some players, for example, Stephen Curry, have a number of shots generated off the dribble, whereas others, such as his teammate, Klay Thompson, who just catch and shoot the ball without many dribbles.",
            "Therefore, this app allows you to pick a 3-pt shooter and see their spread of 3-pt shots off-a-dribble or catch-shoot.")),
            p(paste("The range of the 3-pt shot can also be adjusted to show those who make more shot attempts from long-distance. But as a precaution, there are shots here that may be just a heave at the end of a quarter.",
            "The plot is divided into shot clock intervals mainly to focus on the last portion, 0-6 seconds, as those who are handling the ball more and taking a 3-pt shot when the shot clock is about to expire.",
            "A more complete analysis of ball-handlers near the end of the shot clock would be to look at all shot attempts instead of just 3-pt shots.")),
            p("Data Source: http://NBAsavant.com")
        )
    )
))