data {
  // int I; //number of samples
  int N; //number of measurements
  int K; //number of basis functions
  matrix [N,K] X; //design matrix
  // matrix<lower=0> [N,I] y; //measurements
}

// parameters {
//   vector [K] beta;
//   real<lower=0> sigma;
// }

// transformed parameters {
//   vector[N] mu = X*beta;
// }

// model {
//   beta ~ normal(0,1);
//   sigma ~ exponential(1);
//   for (i in 1:I){
//     y[:,i] ~ normal(mu,sigma);
//   }
// }

generated quantities {
  array[N]real y_pred;
  real sigma;
  vector[K] betas;
  vector[N] mu;

  sigma = exponential_rng(1);
  for (i in 1:N) {
    betas[K] = normal_rng(0,1);
    mu = X*betas;
    y_pred[i] = normal_rng(mu[i],sigma);
  }

}
