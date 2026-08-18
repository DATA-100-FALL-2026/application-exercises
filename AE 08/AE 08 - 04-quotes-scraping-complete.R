# ============================================================
# 04-quotes-scraping-complete.R
# AE 08: Scraping quotes from Quotes to Scrape - COMPLETE SOLUTION
# ============================================================

# 1. Load packages ------------------------------------------
library(tidyverse)
library(rvest)

# 2. Read the HTML page --------------------------------------
page <- read_html("https://quotes.toscrape.com/")

# 3. Extract quote text -----------------------------------------
quote_text <- page %>%
  html_nodes(".text") %>%
  html_text()

# 4. Extract authors --------------------------------------------
author <- page %>%
  html_nodes(".author") %>%
  html_text()

# 5. Extract tags -------------------------------------------------
# Each quote has a DIFFERENT NUMBER of tags, so we go quote-by-quote:
# select every .quote container, then for each one, pull just the
# tags found inside THAT container and glue them together.
quote_nodes <- page %>%
  html_nodes(".quote")

tags <- quote_nodes %>%
  map_chr(function(q) {
    q %>%
      html_nodes(".tags a.tag") %>%
      html_text() %>%
      paste(collapse = ", ")
  })

# 6. Combine into a data frame -------------------------------------
quotes <- tibble(
  quote_text = quote_text,
  author     = author,
  tags       = tags
)

# 7. Add rank numbers -----------------------------------------------
quotes <- quotes %>%
  mutate(rank = row_number()) %>%
  relocate(rank, .before = quote_text)

# 8. Add empty columns for manual data entry -------------------------
quotes <- quotes %>%
  mutate(
    author_born_date = NA_character_,
    author_born_location = NA_character_
  )

# 9. Manually add birth info for the first 3 quotes' authors -----------
# (Found by visiting each author's "(about)" page on the site)
# Quote 1: Albert Einstein
quotes$author_born_date[1]     <- "March 14, 1879"
quotes$author_born_location[1] <- "in Ulm, Germany"

# Quote 2: J.K. Rowling
quotes$author_born_date[2]     <- "July 31, 1965"
quotes$author_born_location[2] <- "in Yate, South Gloucestershire, England, The United Kingdom"

# Quote 3: Albert Einstein (again - same author, different quote)
quotes$author_born_date[3]     <- "March 14, 1879"
quotes$author_born_location[3] <- "in Ulm, Germany"

# 10. Check your work --------------------------------------------------
head(quotes)
nrow(quotes)  # Should be 10
