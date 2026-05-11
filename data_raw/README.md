# Raw Data

This folder stores the raw source files downloaded from official data providers.
Raw files are not included in the GitHub repository because they are large and
should be obtained directly from the original sources.

Do not edit raw files by hand. The scripts treat this folder as read-only input.

## Official Sources

| Source | Link |
| --- | --- |
| ENEM microdata and item files | https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/enem |
| INPE SISAM data | https://dataserver-coids.inpe.br/queimadas/queimadas/sisam/ |
| School Census microdata | https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/censo-escolar |
| SAEB microdata | https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/saeb |
| IBGE municipal shapefiles | https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html |

## Required Layout

The data script expects this structure:

```text
data_raw/
  enem/
    parameters/
      itens_prova_2009.csv
      ...
      itens_prova_2019.csv
    2013/dados/MICRODADOS_ENEM_2013.dta
    2014/dados/MICRODADOS_ENEM_2014.dta
    2015/dados/MICRODADOS_ENEM_2015.dta
    2016/dados/microdados_enem_2016.csv
    2017/dados/MICRODADOS_ENEM_2017.csv
    2018/dados/MICRODADOS_ENEM_2018.csv
    2019/dados/MICRODADOS_ENEM_2019.csv
  inpe/
    dados_sisam-2013/task_9045.dados_sisam.2013.csv
    ...
    dados_sisam-2019/task_9045.dados_sisam.2019.csv
  censo_escolar/
    situacao_aluno/
      ts_censo_basico_situacao_2018.dta
      ts_censo_basico_situacao_2019.dta
  saeb/
    microdados_saeb_2017/dados/
      ts_aluno_5ef.dta
      ts_aluno_9ef.dta
      ts_aluno_3em_esc.dta
    microdados_saeb_2019/dados/
      ts_aluno_5ef.dta
      ts_aluno_9ef.dta
      ts_aluno_34em.dta
  shapes/
    br_municipios_mapa_files/
```

The ENEM helper in the code constructs raw-data paths as:

```r
enem_raw_file(year, filename)
```

which maps to:

```text
data_raw/enem/<year>/dados/<filename>
```

The item-parameter files are read from:

```text
data_raw/enem/parameters/
```
