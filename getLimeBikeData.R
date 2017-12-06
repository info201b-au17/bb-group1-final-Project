library(httr)
library(jsonlite)
library(dplyr)

getLimeBikeData = function(data) {
  baseUrl = "https://web-production.lime.bike/api/public/v1/views/bikes"
  query = paste0("?map_center_latitude=", data[1], "&map_center_longitude=", data[2], "&user_latitude=", data[1], "&user_longitude=", data[2])
  result = GET(paste0(baseUrl, query))
  content = content(result, "text")
  data = fromJSON(content)[1]
  return(data)
}
