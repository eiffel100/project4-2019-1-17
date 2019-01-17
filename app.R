library(shiny)
library(DT)
library(openxlsx)
library(dplyr)
library(googlesheets)
library(ggthemes)
library(ggplot2)
library(scales)
#library(plotly)
#D:/Johns-Hopkins1/Developing Data Products/Week4/Project4_xiu/Project4_xiu/
lp_data<-read.xlsx("league_positions.xlsx")

ui<-shinyUI(
  fluidPage(
    tags$style(
      type="text/css",
      ".shiny-output-error { visibility: hidden; }",
      ".shiny-output-error:before { visibility: hidden; }",
      "h1, h3 {
             text-align:center;
             }"
    ),
    titlePanel(
      h1("The Football Pyramid",h3("Select a club to see where it has finished in the top four divisions of English football since 1958/59."))
    ),
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          selectizeInput('x1', 'Club:', choices = c("", colnames(lp_data[3:118])),
                         multiple = FALSE, options = list(maxOptions = 4, maxItems = 1, placeholder = 'Select a team')),
          hr(),
          helpText("Data source:", (a("James P. Curley",
                                      href="https://github.com/jalapic/engsoccerdata",
                                      target="_blank")))
        ),
        mainPanel(
          plotOutput('plot')
        )
      )
    )
  )
)

server<-shinyServer(function(input, output,session){
  output$plot <- renderPlot({
    p <- ggplot(data = lp_data, aes(x = season)) +
      geom_line(aes(y = lp_data[,input$x1], group = 1), size = 1.1) +
      labs(x = "Season", y = "Finishing position") +
      theme_economist() +
      theme(axis.title = element_text(size = 20),
            axis.text = element_text(size = 16, hjust = 0.7),
            plot.title = element_text(size = 16),
            legend.title=element_blank(),
            legend.justification=c(0, 0)) +
      scale_y_continuous(limits = c(1,100)) +
      scale_y_reverse(limits = c(100,1), breaks = c(1,20,44,68,92), labels = c(1,20,44,68,92)) +
      scale_x_continuous(breaks = c(1958, 1968, 1978, 1988, 1998, 2008, 2016))

    p

  })
})
shinyApp(ui = ui, server = server)
