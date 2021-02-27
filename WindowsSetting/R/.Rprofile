# font
if(Sys.info()["sysname"] == "Windows"){
  if(as.integer(str_extract(Sys.info()["release"], "^[0-9]+")) >=8){
    family_sans <- "Meiryo"
    family_serif <- "Meiryo UI"
    } else {
    family_sans <- "MS Gothic"
    family_serif <- "MS Mincho"
    }
  } else if(Sys.info()["sysname"] == "Linux") {
    family_sans <- "Noto Sans CJK JP"
    family_serif <- "Noto Serif CJK JP"
  } else if(Sys.info()["sysname"] == "Darwin"){
    family_serif <- "Hiragino Mincho ProN"
    family_sans <- "Hiragino Sans"
  } else {
    family_sans <- "Noto Sans CJK JP"
    family_serif <- "Noto Serif CJK JP"
}

# ggplot
require(tidyverse)
require(systemfonts)
require(fontregisterer)
require(ggplot2)
require(ggthemes)

# ggtheme
theme_set(
  theme_pander(base_family = family_serif) + theme(
    axis.title.y = element_text(face = "italic"),
    axis.title.x = element_text(face = "bold"))
  )
