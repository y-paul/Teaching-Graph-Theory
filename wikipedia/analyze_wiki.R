library(tidyverse)
library(igraph)




depression_data <- read_csv("wikipedia/depression.csv")
anxiety_data <- read_csv("wikipedia/angst.csv")

depression_data$from <- depression_data$from %>% str_replace("^https://de.wikipedia.org", "")
depression_data$to <- depression_data$to %>% str_replace("^https://de.wikipedia.org", "")
anxiety_data$from <- anxiety_data$from %>% str_replace("^https://de.wikipedia.org", "")
anxiety_data$to <- anxiety_data$to %>% str_replace("^https://de.wikipedia.org", "")



write_csv(depression_data, "wikipedia/depression_clean.csv")
write_csv(anxiety_data, "wikipedia/anxiety_clean.csv")


graph_depression <- graph_from_data_frame(depression_data)

# layout_depression <- layout_with_lgl(graph_depression)
# plot(graph_depression, layout=layout_depression,
#      vertex.size=5,
#      edge.width=.2,
#      vertex.label.cex=.2,
#      edge.arrow.size=.1,
#      edge.curved=.2,
#      edge
#      )
# 
# tkplot(graph_depression, layout=layout_depression)
# plot(degree_distribution(graph_depression))
# mean(degree((graph_anxiety)))
# 
# 
# graph_anxiety <- graph_from_data_frame(anxiety_data)
# 
# 
# layout_anxiety <- layout_with_fr(graph_anxiety)
# 
# tkplot(graph_anxiety, layout=layout_anxiety, vertex.label.cex = .2,
#      edge.color=c(255, 255 ,255 ,100))
