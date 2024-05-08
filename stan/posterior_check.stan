data {
  int I; //number of samples
  int N; //number of measurements
  int K; //number of basis functions
  matrix [N,K] X; //design matrix
  matrix<lower=0> [N,I] y; //measurements
}

parameters {
  vector [K] beta;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu = X*beta;
}

model {
  beta ~ normal(2,6);
  sigma ~ exponential(1);
  for (i in 1:I){
    y[:,i] ~ normal(mu,sigma);
  }
}

generated quantities {
  array[N]real y_pred;
  for (i in 1:N) {
    y_pred[i] = normal_rng(mu[i],sigma);
  }

}
