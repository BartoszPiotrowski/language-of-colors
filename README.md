# language-of-colors

An experiment demonstrating a proposed model of dynamics of learning color terms in population.

To run a simulation, in the cloned repository run R and paste the following code:

```R
source("src.R")

board <- createBoard(boardSize=c(100, 100), M=c(25,20), sd=c(40, 30))
population <- createPopulation(boardSize=c(100, 100), nOfcolors=4, sizeOfPopulation=6)
simulation(board, population, learningRate=.1, nOfInteractions = 1000)
```
