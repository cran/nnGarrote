#'
#' @title Coefficients for cv.nnGarrote Object
#'
#' @description \code{coef.cv.nnGarrote} returns the coefficients for a cv.nnGarrote object.
#'
#' @param object An object of class cv.nnGarrote
#' @param optimal.only A boolean variable (TRUE default) to indicate if only the coefficient of the optimal split are returned.
#' @param ... Additional arguments for compatibility.
#'
#' @return A matrix with the coefficients of the \code{cv.nnGarrote} object.
#'
#' @export
#'
#' @author Anthony-Alexander Christidis, \email{anthony.christidis@stat.ubc.ca}
#'
#' @examples
#' \donttest{
#' # Setting the parameters
#' p <- 500
#' n <- 100
#' n.test <- 5000
#' sparsity <- 0.15
#' rho <- 0.5
#' SNR <- 3
#' set.seed(0)
#' # Generating the coefficient
#' p.active <- floor(p*sparsity)
#' a <- 4*log(n)/sqrt(n)
#' neg.prob <- 0.2
#' nonzero.betas <- (-1)^(rbinom(p.active, 1, neg.prob))*(a + abs(rnorm(p.active)))
#' true.beta <- c(nonzero.betas, rep(0, p-p.active))
#' # Two groups correlation structure
#' Sigma.rho <- matrix(0, p, p)
#' Sigma.rho[1:p.active, 1:p.active] <- rho
#' diag(Sigma.rho) <- 1
#' sigma.epsilon <- as.numeric(sqrt((t(true.beta) %*% Sigma.rho %*% true.beta)/SNR))
#'
#' # Simulate some data
#' library(mvnfast)
#' x.train <- mvnfast::rmvn(n, mu=rep(0,p), sigma=Sigma.rho)
#' y.train <- 1 + x.train %*% true.beta + rnorm(n=n, mean=0, sd=sigma.epsilon)
#' x.test <- mvnfast::rmvn(n.test, mu=rep(0,p), sigma=Sigma.rho)
#' y.test <- 1 + x.test %*% true.beta + rnorm(n.test, sd=sigma.epsilon)
#'
#' # Applying the NNG with Ridge as an initial estimator
#' nng.out <- cv.nnGarrote(x.train, y.train, intercept=TRUE,
#'                         initial.model=c("LS", "glmnet")[2],
#'                         lambda.nng=NULL, lambda.initial=NULL, alpha=0,
#'                         nfolds=5)
#' nng.predictions <- predict(nng.out, newx=x.test)
#' mean((nng.predictions-y.test)^2)/sigma.epsilon^2
#' coef(nng.out)
#' }
#'
#' @seealso \code{\link{cv.nnGarrote}}
#'
coef.cv.nnGarrote <- function(object, optimal.only = TRUE, ...){

  # Check input data
  if(!any(class(object) %in% "cv.nnGarrote"))
    stop("The object should be of class \"cv.nnGarrote\"")

  # Returning the coefficients
  if(optimal.only)
    return(object$betas[,object$optimal.lambda.nng.ind]) else
      return(object$betas)
}








