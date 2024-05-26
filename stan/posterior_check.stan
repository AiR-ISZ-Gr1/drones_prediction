data {
  int I; //number of samples
  int N; //number of measurements
  int K; //number of basis functions
  matrix [N,K] X; //design matrix
  matrix<lower=0> [N,I] y; //measurements
}

parameters {
  vector [K] betas;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu = X*betas;
}

model {
  betas ~ normal(0,1);
  sigma ~ exponential(1);
  for (i in 1:I){
    y[:,i] ~ normal(mu,sigma);
  }
}

generated quantities {
  array[N]real y_pred;
  for (i in 1:N) {
    y_pred[i] = normal_rng(mu[i], sigma);
  }

  vector[N] y_pred_hat;
  real<lower=0> sigma_sim_hat;
  vector[K] betas_sim_hat;
  vector[N] mu_hat;

  sigma_sim_hat = exponential_rng(1);
  print("sigma",sigma);
  for (k in 1:K) {
      betas_sim_hat[k] = normal_rng(0,1);
  }

  mu_hat = X*betas_sim_hat;
  print("mu",mu);
  for (i in 1:N) {
    y_pred_hat[i] = normal_rng(mu_hat[i],sigma_sim_hat);
  }

}
