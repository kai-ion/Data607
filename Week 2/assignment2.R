# Load packages
library(DBI)
library(RMySQL)
library(dplyr)

db_password <- Sys.getenv("MY_DB_PASSWORD")
# Connect to MySQL
con <- dbConnect(
  RMySQL::MySQL(),
  dbname = "movie_ratings",
  host = "localhost",
  port = 3306,
  user = "root",
  password = db_password
)

# Load tables
movies <- dbGetQuery(con, "SELECT * FROM movies")
friends <- dbGetQuery(con, "SELECT * FROM friends")
ratings <- dbGetQuery(con, "SELECT * FROM ratings")

# Merge friend and movie names with ratings
full_ratings <- ratings %>%
  left_join(friends, by = c("friend_id" = "friend_id")) %>%
  left_join(movies, by = c("movie_id" = "movie_id"))

print(full_ratings)

# Average rating per movie
full_ratings %>%
  group_by(movie_name) %>%
  summarise(avg_rating = mean(rating, na.rm = TRUE))

# Average rating per friend
full_ratings %>%
  group_by(friend_name) %>%
  summarise(avg_rating = mean(rating, na.rm = TRUE))



# Disconnect
dbDisconnect(con)
