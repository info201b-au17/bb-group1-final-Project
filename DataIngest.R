library(httr)
library(jsonlite)
library(dplyr)

getLimeBikeDataInternal = function(data) {
  baseUrl = "https://web-production.lime.bike/api/public/v1/views/bikes"
  query = paste0("?map_center_latitude=", data[1], "&map_center_longitude=", data[2], "&user_latitude=", data[1], "&user_longitude=", data[2])
  result = GET(paste0(baseUrl, query))
  content = content(result, "text")
  data = fromJSON(content)[1]
  return(data)
}

getLimeBikeData = function (latLongPair){
  raw = getLimeBikeDataInternal(latLongPair)
  formatted = raw[["data"]][["attributes"]][["nearby_locked_bikes"]]$attributes %>% select(latitude, longitude)
  return(formatted)
}

getBikeRackData = function(){
  url = "https://data.seattle.gov/api/views/stpx-rghv/rows.csv"
  result = GET(url)
  content = content(result, "text")
  data = read.csv(text = content)
  return(data)
}

getBikeData = function(){
  locations = list(c("47.652413", "-122.309003"),
                   c("47.655842", "-122.309959"),
                   c("47.660077", "-122.311011"),
                   c("47.658293", "-122.305126"),
                   c("47.654968", "-122.304545"),
                   c("47.651557", "-122.305969"),
                   c("47.660839", "-122.300400"),
                   c("47.655212", "-122.313452"),
                   c("47.654012", "-122.317239"),
                   c("47.658767", "-122.313999"))
  
  data = sapply(locations, getLimeBikeDataInternal)
  
  bikes = data[[1]][["attributes"]][["nearby_locked_bikes"]]$attributes %>% select(latitude, longitude, last_activity_at)
  for(num in 2:length(data)){
    bikes = union(bikes, data[[num]][["attributes"]][["nearby_locked_bikes"]]$attributes %>% select(latitude, longitude, last_activity_at) )
  }
  
  return(bikes)
}

getBikeAndRackData = function(){
  bikes = getBikeData() %>% select(latitude, longitude) %>% mutate(type = "bike")
  racks = getBikeRackData() %>% select(latitude = LATITUDE, longitude = LONGITUDE) %>% mutate(type = "rack")
  unifiedData = union(bikes, racks)
  return(unifiedData)
}