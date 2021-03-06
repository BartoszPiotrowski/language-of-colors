# language-of-colors

An experiment demonstrating a proposed model of dynamics of learning color terms in population.

To run a simulation, in the cloned repository run R (or open RStudio and set a proper working directory) and paste the following code:

```R
source("src.R")

board <- createBoard(boardSize=c(100, 100), M=c(25,20), sd=c(40, 30))
population <- createPopulation(boardSize=c(100, 100), nOfcolors=4, sizeOfPopulation=6)
simulation(board, population, learningRate=.1, nOfInteractions = 1000)
```

You can experiment with different parameters. 
- `M` and `sd` are parameters of gaussian distribution of probability on color space,
- `nOfColors` and `sizeOfPopulation` determine number of colors in language of population and number of idividuals in population,
- `learningRate` and `nOfInteractions` are parameters of simulation determining level of tendency to adjust convictons by individuals, and number of interactions between individuals changing their covictions.
