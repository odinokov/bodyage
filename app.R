if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny")
}

library(shiny)
library(jsonlite)

# Z-score clamp bounds; must match Z_MIN/Z_MAX in index.html.
Z_MIN <- -4.740683
Z_MAX <- 2.177522

ABSI_mean_std <- tryCatch(
  jsonlite::fromJSON("ABSI_mean_std.json"),
  error = function(e) {
    # Handle error when loading JSON file
    stop("Error: Failed to load ABSI_mean_std.json. Please make sure the file exists and is valid JSON.")
  }
)

ui <- fluidPage(
  titlePanel(
    h1("Body Shape Age Calculator"),
    windowTitle = "ABSI AGE (powered by R shiny"
  ),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "SEX",
        label = "Select your sex:",
        choices = c("Male", "Female"),
        selected = "Male",
        inline = TRUE
      ),
      
      sliderInput(
        inputId = "AGE",
        label = "Select your age (years):",
        min = 20,
        max = 85,
        value = 25
      ),
      
      sliderInput(
        inputId = "BMPHT",
        label = "Enter your standing height (cm):",
        min = 150,
        max = 210,
        value = 175
      ),
      
      sliderInput(
        inputId = "BMPWT",
        label = "Enter your weight (kg):",
        min = 40,
        max = 150,
        value = 71
      ),
      
      sliderInput(
        inputId = "BMPWAIST",
        label = "Enter your waist circumference (cm):",
        min = 50,
        max = 150,
        value = 79
      ),
      
      wellPanel(
        style = "font-size: small;",
        p("For more detailed information, please refer to"),
        p("Krakauer, N. Y. & Krakauer, J. C. A New Body Shape Index Predicts Mortality Hazard Independently of Body Mass Index. PLoS ONE 7, e39504 (2012)."),
        p("Krakauer, N. Y. & Krakauer, J. C. An Anthropometric Risk Index Based on Combining Height, Weight, Waist, and Hip Measurements. Journal of Obesity 2016, 1-9 (2016).")
      )
    ),
    
    mainPanel(
      uiOutput(outputId = "age")
    )
  )
)

server <- function(input, output) {
  output$age <- renderUI({
    sex <- tolower(input$SEX)
    wc <- input$BMPWAIST / 100
    w <- input$BMPWT
    h <- input$BMPHT / 100
    age <- input$AGE
    
    BMI <- w / h^2
    ABSI <- wc / (BMI^(2/3) * h^0.5)
    
    ABSI_stats <- ABSI_mean_std[[sex]][[as.character(age)]]
    ABSI_mean <- ABSI_stats[1]
    ABSI_std <- ABSI_stats[2]

    ABSI_z_score <- (ABSI - ABSI_mean) / ABSI_std

    ABSI_z_score <- pmin(pmax(ABSI_z_score, Z_MIN), Z_MAX)
    
    relative_death_risk <- (0.918 + 0.0485 * ABSI_z_score + 0.0347 * ABSI_z_score^2) / (1.0 - 0.284 * ABSI_z_score)
    
    years <- -10 * log(relative_death_risk)
    
    prediction <- round(age - years)
    
    strong_output <- HTML(paste("Your predicted ABSI age is ", tags$strong(prediction), " years<br><br><br>"))

    div(style = "font-size: larger;", h3(strong_output))
  })
}

shinyApp(ui = ui, server = server)
