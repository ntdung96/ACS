if (!require("tigris")) {
      install.packages("tigris", dependencies = TRUE)
      require(tigris)
}

if (!require("leaflet")) {
      install.packages("leaflet", dependencies = TRUE)
      require(leaflet)
}

if (!require("mapview")) {
      install.packages("mapview")
      require(mapview)
}

if (!require("phantomjs")) {
      webshot::install_phantomjs()
}

#read the file named ACSdat_withmoe.csv
dat = read.csv("ACSdat_withmoe.csv", stringsAsFactors = FALSE)

#mapping
#getting block geographical info
bg = block_groups(state = "VA", county = "Lynchburg city")

#remove "15000US" from all rows in the GEOID column
dat$GEOID = gsub("^15000US", "", dat$GEOID)

#create a new variable called HighSchoolDiploma
dat$HighSchoolDiploma = 100*(dat$B15003_017/dat$population)

#merge the dat table with block group geo information
temp = geo_join(bg,dat[,c("GEOID", "HighSchoolDiploma")],"GEOID","GEOID")

#map the variable
x = mapview(temp, zcol = "HighSchoolDiploma", 
            map.types = "OpenStreetMap", legend = TRUE)
x
mapshot(x, url = paste0(getwd(), "/map.html"))
mapshot(x, file = paste0(getwd(), "/map.png"))