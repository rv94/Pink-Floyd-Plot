##Clear workspace and load relevant packages
rm(list = ls())
install.packages("devtools")
install.packages("billboard")
install.packages("ggbeeswarm")
library("ggtheme")
library("billboard")
library("tidyverse")
library("knitr")
library("devtools")
library("RColorBrewer")
devtools::install_github('charlie86/spotifyr')
install.packages('spotifyr')
library('spotifyr')
library("ggbeeswarm")

##Obtain authorization
Sys.setenv(SPOTIFY_CLIENT_ID = "XXXXXXXXxx")
Sys.setenv(SPOTIFY_CLIENT_SECRET = "XXXXXXXXXXXXX")
access_token <- get_spotify_access_token()

##GetDataset, correct to factor and relevel factor
PF <- get_artist_audio_features(artist = 'pink floyd')
PF$album_name <- as.factor(PF$album_name)
getPalette = colorRampPalette(brewer.pal(8, "Dark2"))
PF <- PF %>% 
  arrange(album_release_year) %>% 
  mutate(album_name = factor(album_name, unique(album_name)))

##Plot 
PF %>% 
  filter(album_name!= "More (Original Film Sountrack) [2011 - Remaster] [2011 Remastered Version]") %>% 
  select(album_name, track_name, duration_ms) %>% 
  ggplot(aes(y = duration_ms/1000, x = album_name, group = album_name, colour = album_name)) +
    geom_beeswarm(size = 4, shape = 24, fill = "black", stroke = 3, alpha = 0.8) +
    geom_beeswarm(size = 0.2, alpha = 0.8) +
    scale_color_manual(values = getPalette(18)) +
    theme_classic() +
    theme(legend.position = "none", axis.text.y = element_text(size = 10, colour = "white"), axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, colour = "white"), axis.title.x = element_text(size = 20, colour = "white"), axis.title.y = element_text(size = 15, colour = "white"), plot.title = element_text(size = 20, hjust = 0.5, colour = "white"), panel.background = element_rect(fill='black', colour='white'), plot.background = element_rect(fill = 'black', colour = 'white')) +
    ggtitle("Song Lengths of Pink Floyd Songs by Album") +
    scale_y_continuous(name = "Song Duration in Seconds", limits = c(0,1500), breaks = seq(0, 1500, 60)) +
    xlab("Album") 


