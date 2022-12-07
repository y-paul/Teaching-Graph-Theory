library(tidyverse)
library(jsonlite)
library(igraph)
library(ggmap)

# put in your api key
#register_google("YOUR_API_KEY", write=T)






# get all the locations from the json file
gmaps_data_raw <- fromJSON("googlemaps/2022_May.json")

gmaps_data_raw <- gmaps_data_raw[["timelineObjects"]]
gmaps_data_raw <- gmaps_data_raw[["placeVisit"]]

gmaps_data_raw <- data.frame(latitude = gmaps_data_raw$location$latitudeE7,
                       longitude = gmaps_data_raw$location$longitudeE7,
                       location = gmaps_data_raw$location$address)




gmaps_data_raw <- na.omit(gmaps_data_raw)





# now loop through and create an edge table for igraph, not pretty but works

graph_table <- data.frame(
  long_from = c(),
  lat_from = c(),
  long_to = c(),
  long_from = c(),
  location_from = c(),
  location_to = c()
)

for (i in 2:dim(gmaps_data_raw)[1]) {
  last_row_number = i - 1
  
  last_row = gmaps_data_raw[last_row_number,]
  current_row = gmaps_data_raw[i,]
  
  div_const <- 10000000
  
  move_dat <- data.frame(
    long_from = c(last_row$longitude)/div_const,
    lat_from = c(last_row$latitude)/div_const,
    long_to = c(current_row$longitude)/div_const,
    lat_to = c(current_row$latitude)/div_const,
    location_from = c(last_row$location),
    location_to = c(current_row$location)
  )
  
  graph_table <- rbind(graph_table, move_dat)
  
}
# give each move unique id, needed later for plotting
graph_table$move_id <- 1:dim(graph_table)[1]



# create a pivoted version for drawing on the map, ugly but works
pivot_data <- graph_table %>% pivot_longer(cols=c("location_from", "location_to"))

for (i in 1:dim(pivot_data)[1]) {
  # for each second row, but the to data into from to make plotting easier
  if (i%%2 == 0) {
    pivot_data$long_from[i] <- pivot_data$long_to[i]
    pivot_data$lat_from[i] <- pivot_data$lat_to[i]
  }
}



# we only need graph table for layouting the graph, reduce
graph_table <- data.frame(
  location_from = graph_table$location_from,
  location_to = graph_table$location_to
)
igraph_obj <- graph_from_data_frame(graph_table)
edges_df <- as.data.frame(get.edges(igraph_obj, c(1:ecount(igraph_obj))))
nodes_df <- data.frame(ID=c(1:vcount(igraph_obj)), NAME = V(igraph_obj)$name)




# Now start plotting, we start with the maps part
# get the correct longitude/latitudes
div_const = 10000000
gmaps_data_raw$latitude <-  gmaps_data_raw$latitude/div_const
gmaps_data_raw$longitude <-  gmaps_data_raw$longitude/div_const


#get kiel from google
map <-get_map(location=c(lat=54.321278, lon=10.133306), zoom=13)



base_plot <- ggmap(map)
base_plot +   geom_line(data=pivot_data, aes(group=move_id, x=long_from, y= lat_from), alpha=.15, size=1.2) +
  geom_point(
  data=pivot_data,
  aes(x=long_from, y=lat_from),
  size=2,
  color="darkred",
  alpha=.3
)  

#get kiel from google
map <-get_map(location=c(lat=54.321278, lon=10.133306), zoom=12)




base_plot <- ggmap(map)
base_plot +   geom_line(data=pivot_data, aes(group=move_id, x=long_from, y= lat_from), alpha=.15, size=1.2) +
  geom_point(
    data=pivot_data,
    aes(x=long_from, y=lat_from),
    size=2,
    color="darkred",
    alpha=.3
  )  













co <- layout_with_fr(igraph_obj)

plot(igraph_obj,layout=co, edge.arrow.size=.2,
      vertex.label.cex = .6, vertex.label=NA)


