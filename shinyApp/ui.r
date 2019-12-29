library(shiny)
library(shinythemes)

# read out some values for UI sliders and radio boxes

minCyl <- min(mtcars$cyl)
maxCyl <- max(mtcars$cyl)
minDisp <- min(mtcars$disp)
maxDisp <- max(mtcars$disp)
minHp <- min(mtcars$hp)
maxHp <- max(mtcars$hp)
minDrat <- min(mtcars$drat)
maxDrat <- max(mtcars$drat)
minWt <- min(mtcars$wt)
maxWt <- max(mtcars$wt)
minQsec <- min(mtcars$qsec)
maxQsec <- max(mtcars$qsec)
minGear <- min(mtcars$gear)
maxGear <- max(mtcars$gear)
minCarb <- min(mtcars$carb)
maxCarb <- max(mtcars$carb)

defCar <- data.frame(
  cyl = 4,
  disp = 110,
  hp = 100,
  drat = 3.5,
  wt = 3,
  qsec = 20,
  vs = 1,
  am = 1,
  gear = 4,
  carb = 4
)

# shiny UI definition

shinyUI(
  navbarPage("C9W4: ShinyApp Project",
    theme = shinytheme("superhero"),
    tabPanel("Exploratory Analysis",
      fluidPage(
        titlePanel("The relationship between variables and miles per gallon (MPG)"),
        sidebarLayout(
          sidebarPanel(
# change background color of some elements
            tags$style(type = 'text/css', '#dataStructure {background-color: rgba(43, 62, 80, 1); color: white;}'),
            tags$style(type = 'text/css', '#dataHead {background-color: rgba(43, 62, 80, 1); color: white;}'),
            tags$style(type = 'text/css', '#varSummary {background-color: rgba(43, 62, 80, 1); color: white;}'),
            tags$style(type = 'text/css', '#fitSummary {background-color: rgba(43, 62, 80, 1); color: white;}'),
            tags$style(type = 'text/css', '#prediction {background-color: rgba(43, 62, 80, 1); color: white; font-size:120px}'),

            p("This page has the purpose to help the reader to explore the data set. You can do the following:"),
            tags$ul(
              tags$li("Examine the relationship between different variables and the miles per gallon (MPG) metric."),
              tags$li("Look at the box plot of the relationship `mpg~variable`"),
              tags$li("Display a scatter plot with linear fit of the `mpg~variable` relationship"),
              tags$li("And look at a summary of all the variables in the Summary tab")
            ),
            hr(),
            h4("Structure of the data set:"),
            verbatimTextOutput("dataStructure"),
            hr(),
            h4("First 5 entries of the data set:"),
            verbatimTextOutput("dataHead")
          ),
          mainPanel(
            selectInput("predictor", "Choose a variable to evaluate:",
              c("# of cylinders" = "cyl",
                "Displacement" = "disp",
                "Horsepower" = "hp",
                "Rear axle ratio" = "drat",
                "Weight" = "wt",
                "Quarter mile time" = "qsec",
                "V/S (Engine shape)" = "vs",
                "Transmission type" = "am",
                "# of gears" = "gear",
                "# of carburetors" = "carb"
              )
            ),
            hr(),
            h1(textOutput("caption")),
            hr(),
            tabsetPanel(type = "tabs",
              tabPanel("Box Plot",
                checkboxInput("outlier", "Show outliers in the box plot", TRUE),
                plotOutput("boxPlot")
              ),
              tabPanel("Linear Model",
                plotOutput("lmPlot"),
                hr(),
                verbatimTextOutput("fitSummary")
              ),
              tabPanel("Summary",
                verbatimTextOutput("varSummary")
              )
            )
          )
        )
      )
    ),
    tabPanel("Prediction",
      sidebarPanel(
        sliderInput("cyl", "# of cylinders", min = minCyl, max = maxCyl, value = defCar$cyl, step = 2),
        sliderInput("disp", "Displacement", min = minDisp, max = maxDisp, value = defCar$disp, step = 5),
        sliderInput("hp", "Horsepower", min = minHp, max = maxHp, value = defCar$hp, step = 5),
        sliderInput("drat", "Rear axle ratio", min = minDrat, max = maxDrat, value = defCar$drat, step = 0.1),
        sliderInput("wt", "Weight", min = minWt, max = maxWt, value = defCar$wt, step = 0.1),
        sliderInput("qsec", "Quarter mile time", min = minQsec, max = maxQsec, value = defCar$qsec, step = 1),
        radioButtons("vs", label = "V/S (Engine shape)", choices = list("V-Shape" = 0, "Straight" = 1), selected = 1, inline = TRUE),
        radioButtons("am", label = "Transmission type", choices = list("Automatic" = 0, "Manual" = 1), selected = 1, inline = TRUE),
        sliderInput("gear", "# of gears", min = minGear, max = maxGear, value = defCar$gear, step = 1),
        sliderInput("carb", "# of carburetors", min = minCarb, max = maxCarb, value = defCar$carb, step = 1),
      ),
      mainPanel(
        h1("Projected miles per gallon via:"),
        h1(textOutput("model")),
        hr(),
        textOutput("prediction")
      )
    ),
    tabPanel("Documentation",
      h2("Information about the shiny web app"),
      p("A list of things you can do with this app: "),
      tags$ul(
        tags$li("In the `Exploratory Analysis` tab you can view box plots and linear fits of the relationship `mpg~variable`. The structure of the dataset and statistical summaries of each variable are also displayed."),
        tags$li("In the `Prediction` tab you can make a MPG prediction for a hypothetical car by adjusting the different sliders for the parameters on the left."),
        tags$li("The `Documentation` tap will bring you on this help page."),
        tags$li("The `About` tap provide additional links to the supplementary material for this app.")
      ),
      hr(),

      h2("Prediction algorithm used"),
      p(
        "A relativly simple random forest model in conjunvtion with ",
        a(href = "https://en.wikipedia.org/wiki/Cross-validation_(statistics)", target = "_blank", "k-fold-cross-validation"),
        " (k=10) was used and trained on all observations."
      ),
      hr(),

      h2("Data set"),
      p(
        "The ",
        a(href = "https://www.rdocumentation.org/packages/datasets/versions/3.6.1/topics/mtcars", target = "_blank", "mtcars"),
        "data set is part of the base R package and consists of 32 observations of 11 variables (properties of different cars). Originally the data was extracted from the Motor Trend US magazine in 1974."
      ),
      p("Source: Henderson & Velleman, Building Multiple Regression Models Interactively (1981)")
    ),
    tabPanel("About",
      p(
        "This",
        a(href = "https://shiny.rstudio.com/", target = "_blank", "shiny"),
        "web app was created by xbuRAw (GH) as part of the Developing Data Products course (December 2019)."
      ),
      hr(),
      p(
        "You can fine the github repository with all the source code for the web app and the application",
        a(href = "https://github.com/xbuRAw/ds-course9-project-w4", target = "_blank", " here"),
        "."
      ),
      p(
        "If you are looking for the accompanying presentation, click ",
        a(href = "https://github.com/xbuRAw/ds-course9-project-w4", target = "_blank", "here"),
        "."
      )
    )
  )
)