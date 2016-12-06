context("name_suggest")

test_that("name_suggest returns the correct", {
  skip_on_cran()

  a <- name_suggest(q='Puma concolor')
  b <- name_suggest(q='Puma')
  c <- name_suggest(q='Puma', limit=2)
  d <- name_suggest(q='Puma', fields=c('key','canonicalName'))

  # class
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "data.frame")
  expect_is(d, "data.frame")
  expect_is(a$key, "integer")
  expect_is(c$canonicalName, "character")
  expect_is(d$canonicalName, "character")

  # name_suggest returns the correct dimensions
  expect_equal(NCOL(a), 3)
  expect_equal(NCOL(b), 3)
  expect_equal(NCOL(c), 3)
  expect_equal(NCOL(d), 2)
  expect_equal(names(d), c("key","canonicalName"))

  # value
  expect_match(b$canonicalName[1], "Puma")
  expect_equal(c$rank[1], "GENUS")
})
