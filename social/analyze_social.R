library(igraph)
library(tidyverse)



social_dat <- read_csv("social/contacts.csv")

graph <- graph_from_data_frame(social_dat, directed = F)

graph


co <- layout_with_drl(graph)

plot(graph,layout=co, edge.arrow.size=.2,
     vertex.label.cex = .6)


