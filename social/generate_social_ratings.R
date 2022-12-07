library(tidyverse)

social_contact_list <- c()


counter <- 1


contin <- T

while (contin) {
  friend <- readline(prompt = "Sozial-Kontakt Name ('n' for stopping): ")
  
  if (friend == "n") {
    contin <- F
  } else {
    social_contact_list[counter] <- friend
    counter <- counter + 1
    print(social_contact_list)
  }
  

}

social_contact_list <- c("Ich", social_contact_list)
all_combis <- combn(social_contact_list, 2)

all_combis <- as.data.frame(t(all_combis))


know_rating <- c()
# 0 = kennen sich gar nicht
# 1 = Bekannter
# 2 = schonmal getroffen
# 3 = regelmäßig, aber nur mit anderen
# 4 = guter Freund, auch einzeln
# 5 = sehr guter Freund/Familie

for (i in 1:dim(all_combis)[1]) {
  n1 <- all_combis[i,1]
  n2 <- all_combis[i,2]
  print(paste0(n1, " - ", n2))
  rating <- readline("Wie gut kennen sich beide? Antwort: ")
  know_rating[i] <- rating
}

all_combis$rating <- know_rating

all_combis <- all_combis %>% filter(rating > 0)

final_comb <- all_combis
colnames(final_comb) <- c("Person_A", "Person_B", "weight")


write_csv(final_comb, "social/contacts.csv")

