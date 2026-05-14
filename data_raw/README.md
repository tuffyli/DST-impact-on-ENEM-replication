# Raw Data

This folder stores the raw source files downloaded from official data providers.
Raw files are not included in the GitHub repository because they are large and
should be obtained directly from the original sources.

Do not edit raw files by hand. The scripts treat this folder as read-only input.

## Official Sources


| Source | Years Used | Purpose | Official Link |
| --- | ---: | --- | --- |
| ENEM microdata | 2013-2019 | Main high-stakes exam outcomes and student characteristics. | [INEP ENEM microdata](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/enem) |
| ENEM item parameters | 2009-2019 | Item-level parameters used to construct difficulty- and discrimination-based measures. | [INEP ENEM microdata](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/enem) |
| INPE SISAM | 2013-2019 | Municipality-level weather and atmospheric controls. | [INPE SISAM data server](https://dataserver-coids.inpe.br/queimadas/queimadas/sisam/) |
| School Census | 2018-2019 | Student-flow and school-environment measures. | [INEP School Census microdata](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/censo-escolar) |
| SAEB | 2017 and 2019 | Lower-stakes municipality-level achievement outcomes. | [INEP SAEB microdata](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/saeb) |
| IBGE municipal shapefiles | 2017 | Municipality boundaries used to construct DST-border geometry. | [IBGE Malha Municipal](https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html) |
| IBGE Municipal GDP (PIB municipal) | 2013-2019 | Municipality-level GDP used to construct GDP per capita. | [IBGE SIDRA table 5938](https://sidra.ibge.gov.br/tabela/5938) |
| IBGE Municipal Population (2010 Census) | 2010 | Municipality-level population denominator used in GDP per capita construction. | [IBGE SIDRA table 1378](https://sidra.ibge.gov.br/tabela/1378) |
| IBGE Municipal Population Estimates | 2013-2019 | Annual municipality-level population estimates. | [IBGE SIDRA table 6579](https://sidra.ibge.gov.br/tabela/6579) |
| Brazil's Territorial Division (DTB) | 2017 | Official municipality crosswalk used for INPE merges. | [IBGE Territorial Division](https://www.ibge.gov.br/geociencias/organizacao-do-territorio/estrutura-territorial/23701-divisao-territorial-brasileira.html?=&t=downloads) |



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
