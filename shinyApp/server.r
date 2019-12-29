library(shiny)
library(datasets)

# sourcing the random forest model
# this app is modular, put in another model here
modelName <- "modelRF.r"
source(file = modelName)

shinyServer(function(input, output) {

  # Exploration part
  relationString <- reactive({
    paste("mpg ~", input$predictor)
  })

  relationToPoint <- reactive({
    paste("mpg ~", "as.integer(", input$predictor, ")")
  })

  fit <- reactive({
    lm(as.formula(relationToPoint()), data = mtcars)
  })

  output$caption <- renderText({
    relationString()
  })

  output$dataStructure <- renderPrint({
    str(mtcars)
  })

  output$dataHead <- renderPrint({
    head(mtcars, 5)
  })

  output$boxPlot <- renderPlot({
    par(bg = 'darkgray')
    boxplot(as.formula(relationString()),
      data = mtcars,
      outline = input$outlier,
      col = "orange",
      xlab = input$predictor,
      ylab = "MPG"
    )
  })

  output$fitSummary <- renderPrint({
    summary(fit())
  })

  output$lmPlot <- renderPlot({
    par(bg = 'darkgray')
    plot(as.formula(relationToPoint()),
      data = mtcars,
      xlab = input$predictor,
      ylab = "MPG"
    )
    abline(fit(), col = "red", lwd = 3, lty = 2)
  })

  output$varSummary <- renderPrint({
    summary(mtcars)
  })

  # Prediction part
  makePrediction <- reactive({
    carParameters <- data.frame(
      cyl = input$cyl,
      disp = input$disp,
      hp = input$hp,
      drat = input$drat,
      wt = input$wt,
      qsec = input$qsec,
      vs = as.numeric(input$vs),
      am = as.numeric(input$am),
      gear = input$gear,
      carb = input$carb)
    rfPredict(rfTrain(), carParameters)
  })

  output$prediction <- renderText({
    paste(round(makePrediction(), 2), "mpg")
  })

  output$model <- renderText({
    modelName
  })

})