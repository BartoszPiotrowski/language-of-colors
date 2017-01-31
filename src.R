library(ggplot2)

# this function creates a board representing color space in a given environment;
# each color is attributed with probability of occurence in the environment;
# variable boardSize is a vector of two integers (default is c(100, 100));
# variables M and sd are parameters of a two-dimensional gaussian distribution underlying color space;
# if one of this parameters is equal NULL, than each color has equal probability of occurence;
createBoard <- function(boardSize=c(100, 100), M=NULL, sd=NULL){
  board <- expand.grid(1:boardSize[1], 1:boardSize[2])
  if(is.null(M) | is.null(sd)){
    weights <- rep(1/nrow(board), nrow(board))
  } else {
    gauss <- function(x, m, sd){
      exp((-(x-m)^2)/(2*sd^2))/(sd*sqrt(2*pi))
    }
    probabilities1dim <- sapply(1:boardSize[1], gauss, m=M[1], sd=sd[1])
    probabilities2dim <- sapply(1:boardSize[2], gauss, m=M[2], sd=sd[2])
    probabilities <- apply(board, 1, FUN = function(x) probabilities1dim[x[1]] * probabilities2dim[x[2]])
  }
  board <- cbind(board, probabilities)
  colnames(board) <- c("X", "Y", "probability")
  board
}

# this function creates a population of agents living on a board of given boardSize;
# nOfColors is number of color terms in the language of the population;
# agents are represented by its prototype of color on board for each color term;
# these prototype representations are choosen randomly and independently for each agent;
# it is recommended to assign to sizeOfPopulation number not larger than 20 for performance reasons;
createPopulation <- function(boardSize=c(100, 100), nOfcolors=3, sizeOfPopulation=6){
  createAgent <- function(boardSize, nOfcolors=3){
    X <- sample(boardSize[1], nOfcolors)
    Y <- sample(boardSize[2], nOfcolors)
  data.frame(X, Y)
}
  do.call(list, replicate(sizeOfPopulation, createAgent(boardSize, nOfcolors), simplify=FALSE))
}

# function which determines for given agent and given color what is the name of this color according to the agent's beliefs;
# this is the name which representation is closest to the indicated color;
chooseColor <- function(agent, color){
  dist <- function(A) sum((A-color)^2)
  dists <- apply(agent, 1, dist)
  which.min(dists)
}


# function which performs interaction between two agents seeing a given color;
# agent1 tells what is the name of indicated color according to his beliefs (which is determined with help of a function interaction();
# after that agent2 slightly (according to learningRate) adapts his beliefs with respect to the color term he is hearing in direction of indicated color in the color space,  ;
# the function returns updated beliefs of agent2;
interaction <- function(color, agent1, agent2, learningRate=.1){
  colorNameAgent1 <- chooseColor(agent1, color)
  colorReprAgent2 <- agent2[colorNameAgent1,]
  newColorReprAgent2 <- as.integer(colorReprAgent2 + (color - colorReprAgent2) * learningRate + c(.5, .5))
  agent2[colorNameAgent1,] <- newColorReprAgent2
  agent2
}

plotSituation <- function(board, population){
  shapes <- c(15:17, 7:10, 12, 0:6, 35:112)
  agent <- rep(1:length(population), each=nrow(population[[1]]))
  agent <- shapes[agent]
  dfPopulation <- data.frame(agent=agent, 
                    color=as.factor(rep(1:nrow(population[[1]]), length(population))), 
                    do.call(rbind, population))
  p <- ggplot(board, aes(x=X, y=Y)) + 
    geom_tile(aes(fill=probability)) + scale_fill_gradient(low = "grey", high="black") + 
    scale_shape_identity() +
    geom_point(data=as.data.frame(dfPopulation), aes(x=X, y=Y, color=color, shape=agent), size=5)
  print(p)
}

# the function run and visualize a simulation of multiple interactions among the population;
# to perform the simulation we have to:
# supply a board of color space (value of the function createBoard()),
# population of agents (value of the function createPopulation()),
# determine learningRate, nOfInteractions between randomly choosen pairs of agents 
# and parameter n which determine frequency of visualizing situation during the simulation
simulation <- function(board, population, learningRate=.1, nOfInteractions = 1000, n = 10){
  plotSituation(board, population)
  cat("Situation after 0 interactions. ")
  readline(prompt="Press [enter] to continue.")
  for(j in 1:n){
    for(i in 1:(nOfInteractions/n)){
      pair <- sample(1:length(population), 2)
      agent1 <- population[[pair[1]]]
      agent2 <- population[[pair[2]]]
      color <- board[sample(1:nrow(board), prob = board[,3], 1),1:2]
      population[[pair[2]]] <- interaction(color, agent1, agent2, learningRate)
    }
    plotSituation(board, population)
    cat("Situation after", i*j, "interactions. ")
    readline(prompt="Press [enter] to continue.")
  }
}



