library(tidyverse)


dat <- read.csv("taylor_swift/g_data.csv", dec = ",")
dat <- dat[order(dat$year),]
dat$album <- recode(dat$album, red="Red", reputation="Reputation")
dat$album <- factor(dat$album, levels=c("Taylor Swift", "Fearless", "Speak Now", "Red", "1989", "Reputation"))
dat$CC[4]  <- dat$CC[4]/1000
ggplot(dat, aes(x = album, y = Verkauft, fill=CC)) + geom_col() + 
  theme_bw() + scale_fill_gradient(low="blue", high="red")

ggplot(dat, aes(x = album, y = Verkauft, fill=m_emotional)) + geom_col() + 
  theme_bw() + scale_fill_gradient(low="blue", high="red")
