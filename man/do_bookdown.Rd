% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/macro-bookdown.R
\name{do_bookdown}
\alias{do_bookdown}
\title{Build a bookdown book}
\usage{
do_bookdown(..., deploy = NULL, orphan = FALSE, checkout = TRUE,
  repos = repo_default(), path = "_book", branch = "gh-pages",
  remote_url = NULL, commit_message = NULL, commit_paths = ".")
}
\arguments{
\item{...}{Passed on to \code{\link[=step_build_bookdown]{step_build_bookdown()}}}

\item{deploy}{\code{[flag]}\cr
If \code{TRUE}, deployment setup is performed before building the bookdown site,
and the site is deployed after building it.
Set to \code{FALSE} to skip deployment.
By default (if \code{deploy} is \code{NULL}), deployment happens
if the following conditions are met:
\enumerate{
\item The repo can be pushed to (see \code{\link[=ci_can_push]{ci_can_push()}}).
\item The \code{branch} argument is \code{NULL}
(i.e., if the deployment happens to the active branch),
or the current branch is \code{master} (see \code{\link[=ci_get_branch]{ci_get_branch()}}).
}}

\item{orphan}{\code{[flag]}\cr
Create and force-push an orphan branch consisting of only one commit?
This can be useful e.g. for \code{path = "docs", branch = "gh-pages"},
but cannot be applied for pushing to the current branch.}

\item{checkout}{\code{[flag]}\cr
Check out the current contents of the repository? Defaults to \code{TRUE},
set to \code{FALSE} if the build process relies on existing contents or
if you deploy to a different branch.}

\item{repos}{CRAN-like repositories to install from, defaults to
\code{\link[=repo_default]{repo_default()}}.}

\item{path}{\code{[string]}\cr
Path to the repository, default \code{"."} which means setting up the current
repository.}

\item{branch}{\code{[string]}\cr
Target branch, default: current branch.}

\item{remote_url}{\code{[string]}\cr
The URL of the remote Git repository to push to, defaults to the
current GitHub repository.}

\item{commit_message}{\code{[string]}\cr
Commit message to use, defaults to a useful message linking to the CI build
and avoiding recursive CI runs.}

\item{commit_paths}{\code{[character]}\cr
Restrict the set of directories and/or files added to Git before deploying.
Default: deploy all files.}
}
\description{
\code{do_bookdown()} adds default steps related to package checks
to the \code{"install"}, \code{"before_deploy"}, \code{"script"} and \code{"deploy"} stages.

\enumerate{
\item \code{\link[=step_install_deps]{step_install_deps()}} in the \code{"install"} stage, using the
\code{repos} argument.
\item \code{\link[=step_setup_ssh]{step_setup_ssh()}} in the \code{"before_deploy"} to setup the upcoming deployment (if \code{deploy} is set),
\item \code{\link[=step_setup_push_deploy]{step_setup_push_deploy()}} in the \code{"before_deploy"} stage (if \code{deploy} is set),
\item \code{\link[=step_build_bookdown]{step_build_bookdown()}} in the \code{"deploy"} stage, forwarding all \code{...} arguments.
\item \code{\link[=step_do_push_deploy]{step_do_push_deploy()}} in the \code{"deploy"} stage.
}

By default, the \code{_book/} directory is deployed to the \code{gh-pages} branch, keeping the history.
}
\examples{
dsl_init()

do_bookdown()

dsl_get()
}
\seealso{
Other macros: \code{\link{do_package_checks}},
  \code{\link{do_pkgdown}}
}
\concept{macros}
