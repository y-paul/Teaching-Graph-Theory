### How to use:


**Attention:** Data can be found [here](https://www.kaggle.com/datasets/thespacefreak/taylor-swift-song-lyrics-all-albums).

Different scripts produce different versions of data:


**taylor_swift_prepro.R:** 
Produces basic data set with all albums and sentiments for each word

**taylor_swift_prepro_positive.R**:
Produces data set over all albums for only positive sentiments

**taylor_swift_prepro_negative.R**:
Produces data set over all albums for only negative sentiments

**taylor_swift_prepro_over_albums.R**:
Produces data set for each album


Layouting was done in Gephi. Load in nodes.csv as a node table, undirected. Then load in edges.csv, undirected, set "append to workspace". Copy values from "name" column to "Label". Select Force-Atlas-2 for layouting, check seperate hubs, increase attraction to center to about 10.
After running FA, set labels to a reasonable size and run noverlap/label-adjust. Color nodes by sentiment and set size (reversed) by clustering coefficient (that you calculate in the bar on the right in Gephi.)
A csv for the plot in the presentation was done by hand and is not synced to this repo.