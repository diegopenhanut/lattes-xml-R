- Execute `00_create_dir.sh`
- Faça o download dos arquivos xml dos currículos lattes de interesse e os
  coloque na pasta `data`
  - Não há um modo automatizado de fazer isso. Para cada currículo existe um
    captcha que deve ser respondido.
- Rode os scripts na ordem abaixo para obter uma tabela com a produção
  científica dos professores.
  - `01_get.id.sh`
  - `02_recompres.sh`
  - `03_report_impressao.R`
- Isso vai gerar dois arquivos com o mesmo conteúdo.
  - `output/producao_professores.csv`
  - `output/producao_professores.xlsx`
- E um terceiro, com dados de 2017
  - `output/producao_professores_2017.xlsx`
- para plotar a produção de 2017 por currículo, execute
  - `plot.R`
- caso precise modificar obter mais informações do xml, use o arquivo
xmlpath.txt para ver os paths que poder sem usados na função xpathApply, no
script `03_report_impressao.R`
  - essa lista foi extraída/adaptada com ajuda de `XMLStarlet`
