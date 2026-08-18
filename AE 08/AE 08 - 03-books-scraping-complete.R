# ============================================================
# 03-books-scraping-complete.R
# AE 08: Scraping books from Books to Scrape - COMPLETE SOLUTION
# ============================================================

# 1. Load packages ------------------------------------------
library(tidyverse)
library(rvest)

# 2. Read the HTML page --------------------------------------
page <- read_html("https://books.toscrape.com/")

# 3. Extract titles -------------------------------------------
# Full titles live in the `title` attribute; visible text is truncated
titles <- page %>%
  html_nodes(".product_pod h3 a") %>%
  html_attr("title")

# 4. Extract prices ---------------------------------------------
prices <- page %>%
  html_nodes(".price_color") %>%
  html_text() %>%
  str_remove("£") %>%
  as.numeric()

# 5. Extract star ratings -----------------------------------------
# The rating is encoded in the CSS class name, e.g. "star-rating Three"
ratings <- page %>%
  html_nodes(".product_pod p.star-rating") %>%
  html_attr("class") %>%
  str_remove("star-rating ") %>%
  case_match(
    "One"   ~ 1,
    "Two"   ~ 2,
    "Three" ~ 3,
    "Four"  ~ 4,
    "Five"  ~ 5
  )

# 6. Combine into a data frame -------------------------------------
books <- tibble(
  title  = titles,
  price  = prices,
  rating = ratings
)

# 7. Add rank numbers -----------------------------------------------
books <- books %>%
  mutate(rank = row_number()) %>%
  relocate(rank, .before = title)

# 8. Check your work --------------------------------------------------
head(books)
nrow(books)  # Should be 20

# ------------------------------------------------------------------
# BONUS (Exercise 12): follow the "next" link to grab page 2 as well
# ------------------------------------------------------------------
next_link <- page %>%
  html_nodes(".next a") %>%
  html_attr("href")

page2 <- read_html(paste0("https://books.toscrape.com/", next_link))

titles2 <- page2 %>% html_nodes(".product_pod h3 a") %>% html_attr("title")
prices2 <- page2 %>% html_nodes(".price_color") %>% html_text() %>%
  str_remove("£") %>% as.numeric()
ratings2 <- page2 %>% html_nodes(".product_pod p.star-rating") %>%
  html_attr("class") %>% str_remove("star-rating ") %>%
  case_match("One" ~ 1, "Two" ~ 2, "Three" ~ 3, "Four" ~ 4, "Five" ~ 5)

books_page2 <- tibble(title = titles2, price = prices2, rating = ratings2) %>%
  mutate(rank = row_number() + 20) %>%
  relocate(rank, .before = title)

books_all <- bind_rows(books, books_page2)
nrow(books_all)  # Should be 40
