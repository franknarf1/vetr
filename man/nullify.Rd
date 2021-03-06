% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/abstract.R
\name{nullify}
\alias{nullify}
\alias{nullify.default}
\title{Set Element to NULL Without Removing It}
\usage{
nullify(obj, index)

\method{nullify}{default}(obj, index)
}
\arguments{
\item{obj}{the R object to NULL a value in}

\item{index}{an indexing vectors of values to NULL}
}
\value{
object with selected values NULLified
}
\description{
This function is required because there is no straightforward way to
over-write a value in a list with NULL without completely removing the entry
from the list as well.
}
\details{
This returns a copy of the object modified with null slots; it does
not modify the input argument.

Default method will attempt to convert non-list objects to lists
with \code{\link{as.list}}, and then back to whatever they were by using a
function with name \code{paste0("as.", class(obj)[[1L]])}
if it exists and works.  If the object cannot be coerced back
to its original type the corresponding list will be returned.

If this is not appropriate for your object type you can write an S3 method
for it.
}
\note{
attributes are copied from original object and re-applied to final
object before return, which may
not make sense in some circumstances.
}
\examples{
nullify(list(1, 2, 3), 2)
nullify(call("fun", 1, 2, 3), 2)
}
