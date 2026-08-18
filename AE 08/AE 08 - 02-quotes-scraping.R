# ============================================================
# 02-quotes-scraping.R
# AE 08: Scraping quotes from Quotes to Scrape
# ============================================================
# Fill in each blank marked with ___
# ============================================================

# 1. Load packages ------------------------------------------
library(tidyverse)
library(rvest)

# 2. Read the HTML page --------------------------------------
# Hint: the site is https://quotes.toscrape.com/
page <- read_html("___")

# 3. Extract quote text -----------------------------------------
# Hint: quote text lives in .text
quote_text <- page %>%
  html_nodes("___") %>%
  html_text()

# 4. Extract authors --------------------------------------------
# Hint: author names live in .author
author <- page %>%
  html_nodes("___") %>%
  html_text()

# 5. Extract tags -------------------------------------------------
# TRICKY: each quote has a DIFFERENT NUMBER of tags (some have 1,
# some have 5). If you just grab "all the tags on the page" in one
# shot, you'll get the wrong total and they won't line up with your
# quotes! Instead, you need to go quote-by-quote:
#   a) select all the .quote "container" nodes first
#   b) for EACH one, pull just the tags found INSIDE that container
#   c) glue that quote's tags together into one string (e.g. "life, love")
# We use purrr::map_chr() to apply a function to each .quote node
# one at a time.
quote_nodes <- page %>%
  html_nodes("___")

tags <- quote_nodes %>%
  map_chr(function(q) {
    q %>%
      html_nodes("___") %>%   # tags nested INSIDE this one quote
      html_text() %>%
      paste(collapse = "___")
  })

# 6. Combine into a data frame -------------------------------------
quotes <- tibble(
  quote_text = ___,
  author     = ___,
  tags       = ___
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

# 9. Manually add birth info for the first 3 authors -------------------
# Visit each author's "(about)" page linked under their quote and
# fill in what you find. Example format shown below - replace with
# YOUR three authors' real info.
quotes$author_born_date[1]     <- "___"
quotes$author_born_location[1] <- "___"

quotes$author_born_date[2]     <- "___"
quotes$author_born_location[2] <- "___"

quotes$author_born_date[3]     <- "___"
quotes$author_born_location[3] <- "___"

# 10. Check your work --------------------------------------------------
head(quotes)
nrow(quotes)  # Should be 10
