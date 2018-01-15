
library(tidyverse)

prod <- read.csv(file = "output/producao_professores.csv")

prod_2017 <- filter(prod, ano == 2017)

ggplot(prod_2017, aes(x = sobrenome_professor, y = freq, fill = tipo)) +
	   geom_bar(stat = "identity")
	   
