context("count_facet")

test_that("count_facet", {
  countries <- isocodes$code[1:10]

  vcr::use_cassette("count_facet", {
    # returns the correct class
    a <- count_facet(by='country', countries=3, removezeros = TRUE)
    b <- count_facet(by='country', countries='AR', removezeros = TRUE)

    # by country name
    c <- count_facet(by='country', countries=countries, removezeros = TRUE)

    # get occurrences by georeferenced state
    d <- count_facet(by='georeferenced')
  })
  
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "data.frame")
  expect_is(d, "data.frame")
  expect_is(a$country, "character")

  # returns the correct dimensions
  expect_equal(NCOL(a), 2)
  expect_equal(NCOL(b), 2)
  expect_equal(NCOL(c), 2)
  expect_equal(NCOL(d), 2)
})

test_that("fails correctly", {
  skip_on_cran()

  # countries must be numeric/integer or character
  expect_error(count_facet(by='country', countries=logical(1)))

  # by must be character
  expect_error(count_facet(by=as.factor('country'), countries=3))

  # removezeros must be logical
  expect_error(count_facet(by='country', countries=3, removezeros=5))

  # throws error, you can't use basisOfRecord and keys in the same call
  # NOT TRUE ANYMORE as of 2020-11-09
  # expect_error(count_facet(c(2489670, 5231042, 2481447), by="basisOfRecord"),
  #              "you can't pass in both keys and have by='basisOfRecord'")
})
