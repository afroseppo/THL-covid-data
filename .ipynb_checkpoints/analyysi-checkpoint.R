# Paketti JSON-stat tiedon lukemista varten
#library(rjstat)
#library(tidyr)
#library(tidyverse)


# Osoitteen perusosa
url_base <- "https://sampo.thl.fi/pivot/prod/fi/epirapo/covid19case/fact_epirapo_covid19case.json"

# Osoitteen perään lisättävä pyyntöosa (Tapaukset viikoittain ja kunnittain)
request <- "?row=hcdmunicipality2020-445222&column=dateweek20200101-508804L&filter=measure-444833"

# Yhdistetään URL:t yhdeksi merkkijonoksi
url <- paste0(url_base, request)

# Haetaan näkymä kuutiosta (palautuu listana, jossa alkiona taulukko data.framena)
cube <- fromJSONstat(url, naming = "label", use_factors = F, silent = T)

# Tallennetaan kuution näkymä talteen omaksi objektikseen ja tarkastellaan muutamaa ensimmäistä riviä
res <- cube[[1]]
head(res, 20)
names(res)[names(res) == 'dateweek20200101'] <- 'Date'
names(res)[names(res) == 'hcdmunicipality2020'] <- 'Municipality'
names(res)[names(res) == 'value'] = 'Values'

class(res$Values) = "double"

head(res, 20)

res[is.na(res)] = 0

res_fin = res %>% pivot_wider(
  names_from = Municipality, 
  values_from = Values,
  values_fill = 0
)

rownames(res_fin) = res$Date
head(res_fin, 20)