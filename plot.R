
library(tidyverse)

prod <- read.csv(file = "output/producao_professores.csv")

prod_2017 <- filter(prod, ano == 2017)

ggplot(prod_2017, aes(x = nome, y = freq, fill = tipo)) +
	   geom_bar(stat = "identity")+
	   theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
