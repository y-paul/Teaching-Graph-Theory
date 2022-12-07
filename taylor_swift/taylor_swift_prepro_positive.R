library(tidyverse)
library(tidytext)
library(stopwords)
library(widyr)
library(igraph)
library(textdata)


dat <- read_csv("taylor_swift/taylor_swift_lyrics.csv")

dat$unique_line <- 1:length(dat$artist)


# get all words as rows
text_df <- dat %>% unnest_tokens(word, lyric)


# remove all stopwords and some handchosen "words"
text_df <- text_df %>% anti_join(
  tibble(word=stopwords::stopwords("en", source="snowball"))
) %>% filter(!word %in% c("00", "1", "14", "17", "18", "2", "203d", "22", "3", "30", "32", "4", "45", "58" ))



# only use words for which sentiments are available:
# this part is optional, toggle via comments
sentiments <- get_sentiments("afinn")
text_df <- text_df <- text_df %>% inner_join(sentiments)
colnames(text_df)[9] <- "sentiment"

text_df <- text_df %>% filter(sentiment>= 0)




# now count all word pairs on how often they occur together
word_pair <- text_df %>% pairwise_count(word, unique_line, sort=T)
word_pair <- word_pair %>% filter(n>0)
colnames(word_pair) <- c("target", "source", "Weight")



# some transformation magic to make these into a node and edge df to save these
# you do not need to undestand details here, its just some transformation stuff that saves
# us from doing this by hand
graph <- graph_from_data_frame(word_pair, directed=F)
nodes_df <- data.frame(ID=c(1:vcount(graph)), NAME = V(graph)$name)

edges_df <- as.data.frame(get.edges(graph, c(1:ecount(graph))))
edges_df$Weight <- E(graph)$Weight
colnames(edges_df) <- c("source", "target", "Weight")



# get sentiments
sentiments <- get_sentiments("afinn")
nodes_df <- nodes_df %>% left_join(sentiments, c("NAME" = "word"))
colnames(nodes_df)[3] <- "sentiment"



# ready for gephi
write.csv(nodes_df, str_c("taylor_swift/data/","pos_","nodes.csv"), row.names=F, fileEncoding="utf-8")
write.csv(edges_df, str_c("taylor_swift/data/", "pos_","edges.csv"), row.names=F, fileEncoding="utf-8")
