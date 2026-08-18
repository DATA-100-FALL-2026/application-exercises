# ============================================================
# 01-books-scraping.R
# AE 08: Scraping books from Books to Scrape
# ============================================================
# Fill in each blank marked with ___
# ============================================================

# 1. Load packages ------------------------------------------
library(tidyverse)
library(rvest)

# 2. Read the HTML page --------------------------------------
# Hint: the site is https://books.toscrape.com/
page <- read_html("___")

# 3. Extract titles -------------------------------------------
# Hint: titles live in the `title` ATTRIBUTE of the <a> tag
#       inside .product_pod h3 - the visible text is truncated!
titles <- page %>%
  html_nodes("___") %>%
  html_attr("___")

# 4. Extract prices ---------------------------------------------
# Hint: prices are in .price_color as visible text like "£51.77"
# You'll need to remove the £ sign before converting to numeric
prices <- page %>%
  html_nodes("___") %>%
  html_text() %>%
  str_remove("___") %>%
  as.numeric()

# 5. Extract star ratings -----------------------------------------
# Hint: the rating is NOT visible text - it's encoded in the CSS
# class name, e.g. class="star-rating Three"
# Steps:
#   a) select .product_pod p.star-rating
#   b) pull the "class" attribute
#   c) remove the text "star-rating " to leave just the word (e.g. "Three")
#   d) use case_match() to turn the word into a number
ratings <- page %>%
  html_nodes("___") %>%
  html_attr("___") %>%
  str_remove("___") %>%
  case_match(
    "One"   ~ ___,
    "Two"   ~ ___,
    "Three" ~ ___,
    "Four"  ~ ___,
    "Five"  ~ ___
  )

# 6. Combine into a data frame -------------------------------------
books <- tibble(
  title  = ___,
  price  = ___,
  rating = ___
)

# 7. Add rank numbers -----------------------------------------------
books <- books %>%
  mutate(rank = row_number()) %>%
  relocate(rank, .before = title)

# 8. Check your work --------------------------------------------------
head(books)
nrow(books)  # Should be 20
