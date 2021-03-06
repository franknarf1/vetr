% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validators.R
\docType{data}
\name{vet_token}
\alias{vet_token}
\alias{NO.NA}
\alias{vet_token}
\alias{NO.INF}
\alias{vet_token}
\alias{GTE.0}
\alias{vet_token}
\alias{LTE.0}
\alias{vet_token}
\alias{GT.0}
\alias{vet_token}
\alias{LT.0}
\alias{vet_token}
\alias{INT.1}
\alias{vet_token}
\alias{INT.1.POS}
\alias{vet_token}
\alias{INT.1.NEG}
\alias{vet_token}
\alias{INT.1.POS.STR}
\alias{vet_token}
\alias{INT.1.NEG.STR}
\alias{vet_token}
\alias{INT}
\alias{vet_token}
\alias{INT.POS}
\alias{vet_token}
\alias{INT.NEG}
\alias{vet_token}
\alias{INT.POS.STR}
\alias{vet_token}
\alias{INT.NEG.STR}
\alias{vet_token}
\alias{NUM.1}
\alias{vet_token}
\alias{NUM.1.POS}
\alias{vet_token}
\alias{NUM.1.NEG}
\alias{vet_token}
\alias{NUM}
\alias{vet_token}
\alias{NUM.POS}
\alias{vet_token}
\alias{NUM.NEG}
\alias{vet_token}
\alias{CHR.1}
\alias{vet_token}
\alias{CHR}
\alias{vet_token}
\alias{CPX}
\alias{vet_token}
\alias{CPX.1}
\alias{vet_token}
\alias{LGL}
\alias{vet_token}
\alias{LGL.1}
\title{Vetting Tokens With Custom Error Messages}
\format{An object of class \code{call} of length 2.}
\usage{
vet_token(exp, err.msg = "\%s")

NO.NA

NO.INF

GTE.0

LTE.0

GT.0

LT.0

INT.1

INT.1.POS

INT.1.NEG

INT.1.POS.STR

INT.1.NEG.STR

INT

INT.POS

INT.NEG

INT.POS.STR

INT.NEG.STR

NUM.1

NUM.1.POS

NUM.1.NEG

NUM

NUM.POS

NUM.NEG

CHR.1

CHR

CPX

CPX.1

LGL

LGL.1
}
\arguments{
\item{exp}{an expression which will be captured but not evaluated}

\item{err.msg}{character(1L) a message that tells the user what the
expected value should be, should contain a \dQuote{\%s} for \code{sprintf}
to use (e.g. \dQuote{\%sshould be greater than 2})}
}
\value{
a quoted expressions with \code{err.msg} attribute set
}
\description{
Utility function to generate vetting tokens with attached error messages.
You should only need to use this if the error message produced naturally by
\code{vetr} is unclear.  Several predefined tokens created by this function
are also documented here.
}
\details{
Allows you to supply error messages for vetting to use for each error
token.  Your token should not contain top level \code{&&} or \code{||}.  If
it does your error message will not be reported because \code{vetr} looks for
error messages attached to atomic tokens.  If your token must involve
top level \code{&&} or \code{||}, use \code{I(x && y)} to ensure that
your error message is used by \code{vet}, but beware than in doing so you do
not use templates within the \code{I} call as everything therein will be
interpreted as a vetting expression rather than a template.

Error messages are typically of the form \dQuote{\%sshould be XXX}.

This package ships with many predefined tokens for common use cases. They
are listed in the \dQuote{Usage} section of this documentation.  The tokens
are named in format \code{TYPE[.LENGTH][.OTHER]}.  For example
\code{INT} will vet an integer vector, \code{INT.1} will vet a scalar integer
vector, and \code{INT.1.POS.STR} will vet a strictly positive integer vector.
At this time tokens are predefined for the basic types as scalars or
any-length vectors.  Some additional checks are available (e.g. positive only
values).

Every one of the predefined vetting tokens documented here implicitly
disallows NAs.  Numeric tokens also disallow infinite values. If you wish
to allow NAs or infinite values just use a template object (e.g.
\code{integer(1L)}).
}
\note{
\strong{This will only work with custom expressions containing \code{.}}.  Anything
else will be interpreted as a template token.
}
\examples{
## Predefined tokens:
vet(INT.1, 1:2)
vet(INT.1 || LGL, 1:2)
vet(INT.1 || LGL, c(TRUE, FALSE))

## Check squareness
mx <- matrix(1:3)
SQR <- vet_token(nrow(.) == ncol(.), "\%sshould be square")
vet(SQR, mx)

## Let `vetr` make up error message; note `quote` vs `vet_token`
## Often, `vetr` does fine without explictly specified err msg:
SQR.V2 <- quote(nrow(.) == ncol(.))
vet(SQR.V2, mx)

## Combine some tokens, notice how we use `quote` at the combining
## step:
NUM.MX <- vet_token(matrix(numeric(), 0, 0), "\%sshould be numeric matrix")
SQR.NUM.MX <- quote(NUM.MX && SQR)
vet(SQR.NUM.MX, mx)

## If instead we used `vet_token` the overall error message
## is not used; instead it falls back to the error message of
## the specific sub-token that fails:
NUM.MX <- vet_token(matrix(numeric(), 0, 0), "\%sshould be numeric matrix")
SQR.NUM.MX.V2 <-
  vet_token(NUM.MX && SQR, "\%sshould be a square numeric matrix")
vet(SQR.NUM.MX.V2, mx)
}
\seealso{
\code{\link[=vet]{vet()}}
}
\keyword{datasets}
