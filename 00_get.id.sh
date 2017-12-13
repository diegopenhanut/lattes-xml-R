#!/usr/bin/env sh

# usar http://buscacv.cnpq.br/buscacv/#/espelho?nro_id_cnpq_cp_s=<id> para acessar o currículo

ls data/ | 
	cut -f1 -d "." |
	tr "-" "\t" |
	sort |
	uniq |
	awk '{print $1 "\thttp://buscacv.cnpq.br/buscacv/#/espelho?nro_id_cnpq_cp_s="$2}' |
	column -t > lista.id.professores.txt
