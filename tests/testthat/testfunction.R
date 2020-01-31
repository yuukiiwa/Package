context("TxDb_to_GTF")
library(Package)
test_that("TxDb_to_GTF is working", {
  expect_message(TxDb_to_GTF(),"This will take several minutes.")
  expect_is(TxDb_to_GTF(), "data.frame")
})
