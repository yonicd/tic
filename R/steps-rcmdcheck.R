TicStepWithPackageDeps <- R6Class(
  "TicStepWithPackageDeps", inherit = TicStep,

  public = list(
    initialize = function() {},

    prepare = function() {
      verify_install("remotes")

      remotes::install_deps(dependencies = TRUE)

      # Using a separate library for "build dependencies"
      # (which might well be ahead of CRAN)
      # works very poorly with custom steps that are not aware
      # of this shadow library.
      utils::update.packages(ask = FALSE)
    }
  ),
)

RCMDcheck <- R6Class(
  "RCMDcheck", inherit = TicStepWithPackageDeps,

  public = list(
    initialize = function(path = ".", error_on = "error",
                          args = c("--no-manual", "--as-cran"), build_args = "--force") {
      private$path <- path
      private$error_on <- error_on
      private$args <- args
      private$build_args <- build_args

      super$initialize()
    },

    run = function() {
      res <- rcmdcheck::rcmdcheck(path = private$path, args = private$args,
                                  error_on = private$error_on)

      print(res)
      if (length(res$errors) > 0) {
        stopc("Errors found.")
      }
      # if (private$warnings_are_errors && length(res$warnings) > 0) {
      #   stopc("Warnings found, and `warnings_are_errors` is set.")
      # }
      # if (private$notes_are_errors && length(res$notes) > 0) {
      #   stopc("Notes found, and `notes_are_errors` is set.")
      # }
    },

    prepare = function() {
      verify_install("rcmdcheck")
      super$prepare()
    }
  ),

  private = list(
    error_on = NULL,
    args = NULL,
    build_args = NULL
  )
)

#' Step: Check a package
#'
#' Check a package using \pkg{rcmdcheck}, which ultimately calls `R CMD check`.
#' The preparation consists of installing package dependencies
#' via [remotes::install_deps()] with `dependencies = TRUE`,
#' and updating all packages.
#'
#' This step uses a dedicated library,
#' a subdirectory `tic-pkg` of the current user library
#' (the first element of [.libPaths()]),
#' for the checks.
#' This is done to minimize conflicts between dependent packages
#' and packages that are required for running the various steps.
#'
#' @param warnings_are_errors `[flag]`\cr
#'   Should warnings be treated as errors? Default: `TRUE`.
#' @param notes_are_errors `[flag]`\cr
#'   Should notes be treated as errors? Default: `FALSE`.
#' @param args `[character]`\cr
#'   Passed to `[rcmdcheck::rcmdcheck()]`, default:
#'   `c("--no-manual", "--as-cran")`.
#' @param build_args `[character]`\cr
#'   Passed to `[rcmdcheck::rcmdcheck()]`, default:
#'   `"--force"`.
#' @export
step_rcmdcheck <- function(path = ".", error_on = "error",
                           args = c("--no-manual", "--as-cran"),
                           build_args = "--force") {
  RCMDcheck$new(
    path = path,
    error_on = error_on,
    args = args,
    build_args = build_args
  )
}
