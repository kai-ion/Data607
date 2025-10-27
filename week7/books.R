
# Load required packages
library(jsonlite)
library(xml2)
library(rvest)
library(dplyr)
library(stringr)
library(purrr)

# Set basePath to local files by default; update to a URL path (e.g., your GitHub raw URL) when publishing
basePath <- "."

# Helper to normalize data frames (consistent column order and types)
normalizeDf <- function(df) {
  df %>%
    mutate(
      title = as.character(title),
      authors = as.character(authors),
      year = as.integer(year),
      publisher = as.character(publisher),
      isbn = as.character(isbn),
      subject = as.character(subject)
    ) %>%
    select(title, authors, year, publisher, isbn, subject) %>%
    arrange(title)
}

# 1) Load HTML table -> data frame
htmlPath <- file.path(basePath, "books.html")
htmlDoc <- read_html(htmlPath)
htmlTables <- html_table(htmlDoc, header = TRUE, fill = TRUE, trim = TRUE)
dfHtml <- htmlTables[[1]] %>%
  rename_all(tolower) %>%
  mutate(authors = str_replace_all(authors, "\\s*;\\s*", "; "))

# 2) Load XML -> data frame
xmlPath <- file.path(basePath, "books.xml")
xmlDoc <- read_xml(xmlPath)
xmlBooks <- xml_find_all(xmlDoc, "//book")

dfXml <- tibble(
  title = xml_text(xml_find_all(xmlBooks, "./title")),
  authors = map_chr(xmlBooks, function(b) {
    auths <- xml_find_all(b, "./authors/author") %>% xml_text()
    paste(auths, collapse = "; ")
  }),
  year = as.integer(xml_text(xml_find_all(xmlBooks, "./year"))),
  publisher = xml_text(xml_find_all(xmlBooks, "./publisher")),
  isbn = xml_text(xml_find_all(xmlBooks, "./isbn")),
  subject = xml_attr(xmlDoc, "subject")
)

# 3) Load JSON -> data frame
jsonPath <- file.path(basePath, "books.json")
jsonData <- fromJSON(jsonPath, flatten = TRUE)
dfJson <- as_tibble(jsonData) %>%
  mutate(authors = map_chr(authors, ~ paste(.x, collapse = "; ")))

# Normalize and compare
dfHtmlN <- normalizeDf(dfHtml)
dfXmlN  <- normalizeDf(dfXml)
dfJsonN <- normalizeDf(dfJson)

identicalHtmlXml  <- identical(dfHtmlN, dfXmlN)
identicalHtmlJson <- identical(dfHtmlN, dfJsonN)
identicalXmlJson  <- identical(dfXmlN, dfJsonN)

list(
  identicalHtmlXml = identicalHtmlXml,
  identicalHtmlJson = identicalHtmlJson,
  identicalXmlJson = identicalXmlJson,
  dfHtml = dfHtmlN,
  dfXml = dfXmlN,
  dfJson = dfJsonN
)
