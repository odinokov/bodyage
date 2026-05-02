# Body Shape Age Calculator

**Live app: [odinokov.github.io/bodyage](https://odinokov.github.io/bodyage)**

## Description
The Body Shape Age Calculator is a web application that calculates the predicted age based on the Body Shape Index (ABSI). The ABSI is calculated by dividing waist circumference by its estimate obtained from allometric regression of weight and height. The corresponding mortality risks are converted into loss/gain of years.

## How it Works
The calculator takes inputs such as sex, age, standing height, weight, and waist circumference, and uses them to calculate the ABSI and predict the age based on mortality risks. The ABSI calculations and predictive formulas are based on the research papers:

- [A New Body Shape Index Predicts Mortality Hazard Independently of Body Mass Index](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0039504) by N. Y. Krakauer and J. C. Krakauer.
- [An Anthropometric Risk Index Based on Combining Height, Weight, Waist, and Hip Measurements](https://www.hindawi.com/journals/jobe/2016/8094275/#supplementary-materials) by N. Y. Krakauer and J. C. Krakauer.

## Installation
To run the Body Shape Age Calculator locally, follow these steps:

1. Clone the repository.
2. Make sure you have the `shiny` and `jsonlite` packages installed. You can install them by running `install.packages(c("shiny", "jsonlite"))`.
3. Place the `ABSI_mean_std.json` file in the same directory as the R files.
4. Run the `app.R` file using an R development environment or by running `shiny::runApp('app.R')` in the R console.
5. Access the application in your web browser at the provided URL.

## Dependencies
- shiny
- jsonlite

## License
This project is licensed under the [MIT License](LICENSE).

