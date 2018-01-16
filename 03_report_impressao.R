# bibliotecas

library(XML)
library(lubridate)
library(openxlsx)
library(tidyr)
# Funções

read_lattes <- function(xmlfile) {
	lattes_xml <- xmlParse(file = xmlfile)
	lattes_xml
	#lattes <- xmlToList(lattes_xml)
	#lattes
}

# número de produções científicas

get_name <- function(lattes_xml) {
	node <- getNodeSet(lattes_xml, "//DADOS-GERAIS")
	output <- xmlGetAttr(node[[1]], "NOME-COMPLETO")
	output
}

get_eventos <- function(lattes_xml) {
	output <- unlist(
					 xpathApply(
								lattes_xml,
								"//PRODUCAO-BIBLIOGRAFICA/TRABALHOS-EM-EVENTOS/TRABALHO-EM-EVENTOS/DADOS-BASICOS-DO-TRABALHO",
								xmlGetAttr,
								"ANO-DO-TRABALHO"
								)
					 )
	if (is.null(output)){
		return (data.frame(tipo = "eventos",
						   ano = "-",
						   freq = 0))
	}
	output <- data.frame(tipo = "eventos", table(output))
	colnames(output) <-  c("tipo", "ano", "freq")
	output
}

get_artigos <- function(lattes_xml){
	output <- unlist(
					 xpathApply(
								lattes_xml,
								"//PRODUCAO-BIBLIOGRAFICA/ARTIGOS-PUBLICADOS/ARTIGO-PUBLICADO/DADOS-BASICOS-DO-ARTIGO",
								xmlGetAttr,
								"ANO-DO-ARTIGO"
								)
					 )

	if (is.null(output)) {
		return (data.frame(tipo = "artigos",
						   ano = "-",
						   freq = 0))
	}

	output <- data.frame(tipo = "artigos", table(output))
	colnames(output) <-  c("tipo", "ano", "freq")
	output
}

get_capitulos <- function(lattes_xml){
	output <- unlist(
					 xpathApply(
								lattes_xml,
								"//PRODUCAO-BIBLIOGRAFICA/LIVROS-E-CAPITULOS/CAPITULOS-DE-LIVROS-PUBLICADOS/CAPITULO-DE-LIVRO-PUBLICADO/DADOS-BASICOS-DO-CAPITULO",
								xmlGetAttr,
								"ANO"
								)
					 )
	if (is.null(output)){
		return (data.frame(tipo = "capitulos",
						   ano = "-",
						   freq = 0))
	}
	output <- data.frame(tipo = "capitulos", table(output))
	colnames(output) <-  c("tipo", "ano", "freq")
	output
}

get_jornaisrevistas <- function(lattes_xml){
	output <- unlist(
					 xpathApply(
								lattes_xml,
								"//PRODUCAO-BIBLIOGRAFICA/TEXTOS-EM-JORNAIS-OU-REVISTAS/TEXTO-EM-JORNAL-OU-REVISTA/DADOS-BASICOS-DO-TEXTO",
								xmlGetAttr,
								"ANO-DO-TEXTO"
								)
					 )

	if (is.null(output)){
		return (data.frame(tipo = "jornais_revistas",
						   ano = "-",
						   freq = 0))
	}

	output <- data.frame(tipo = "jornais_revistas", table(output))
	colnames(output) <-  c("tipo", "ano", "freq")
	output
}

get_apres_trabalho <- function(lattes_xml){
	output <- unlist(
					 xpathApply(
								lattes_xml,
								"///PRODUCAO-TECNICA/DEMAIS-TIPOS-DE-PRODUCAO-TECNICA/APRESENTACAO-DE-TRABALHO/DADOS-BASICOS-DA-APRESENTACAO-DE-TRABALHO",
								xmlGetAttr,
								"ANO"
								)
					 )
	if (is.null(output)){
		return (data.frame(tipo = "apresentação",
						   ano = "-",
						   freq = 0))
	}
	output <- data.frame(tipo = "apresentação", table(output))
	colnames(output) <-  c("tipo", "ano", "freq")
	output
}


get_data_atualizacao <- function(lattes_xml){
	data_atualização <-
		xpathApply(lattes_xml, "//@DATA-ATUALIZACAO")[[1]][1]
	data_atualização <-
		as.Date(x = data_atualização, format = "%d%m%Y")
	data_atualização
}

get_report <- function(xmlfile) {
	print(xmlfile)
	lattes_xml <- xmlParse(file = xmlfile)
	lattes <- xmlToList(lattes_xml)


	#	data_atualização
	print("data atualização")

	# data em que lattes foi atualizado
	data_atualização <-
		xpathApply(lattes_xml, "//@DATA-ATUALIZACAO")[[1]][1]
	data_atualização <-
		as.Date(x = data_atualização, format = "%d%m%Y")
	print(data_atualização)
	# string com formação
	formacao <-
		xpathApply(lattes_xml,
				   "//DADOS-GERAIS/FORMACAO-ACADEMICA-TITULACAO",
				   xmlChildren
				   #	xmlName
				   #	xmlAttrs
				   #	    xmlGetAttr)
				   )
	formacao <- paste(names(formacao[[1]]), sep = '', collapse = '|')

	formacao

	prod_bibliografica <-
		as.numeric(c(eventos, artigos, capitulos, jornaisrevistas, apres_trabalho))
	prod_bibliografica
	prod_bibliografica_2014_2016 <-
		length(prod_bibliografica[prod_bibliografica >= 2014])

	print("produção entre 2014 e agora")
	print(prod_bibliografica_2014_2016)

}

get_producao_bibliografica <- function(xml_file){
	lattes_xml <- read_lattes(xml_file)
	output <- rbind(get_eventos(lattes_xml),
		  get_artigos(lattes_xml),
		  get_capitulos(lattes_xml),
		  get_jornaisrevistas(lattes_xml),
		  get_apres_trabalho(lattes_xml))
	cbind(nome = get_name(lattes_xml), 
		  data_atualização = get_data_atualizacao(lattes_xml),
		  output)
}



# running code

arquivos_professores <- list.files(path = "./data",
								   pattern = "*.gz",
								   full.names = TRUE)


relatorio <- sapply(arquivos_professores, get_producao_bibliografica, simplify = F)

output <- do.call(rbind, relatorio)

#output <- output %>% 
	#separate(xml_file,
			 #c("blank1", 
			   #"data", 
			   #"nome_professor", 
			   #"sobrenome_professor")) %>%
	#select(-blank1, data)


write.csv(output, "output/producao_professores.csv", row.names = FALSE)
write.xlsx(output, file = "output/producao_professores.xlsx")
write.xlsx(output[output$ano == 2017, ], file = "output/producao_professores_2017.xlsx")
