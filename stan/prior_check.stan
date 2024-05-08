data {
  int N; //number of measurements
  int K; //number of basis functions
  matrix [N,K] X; //design matrix
}


generated quantities {
  vector[N] y_pred;
  real<lower=0> sigma;
  vector[K] betas;
  vector[N] mu;

  sigma = normal_rng(10,1);
  print("sigma",sigma);
  for (k in 1:K) {
      betas[k] = normal_rng(0,1);
  }
  mu = X*betas;
  print("mu",mu);
  for (i in 1:N) {
    y_pred[i] = normal_rng(mu[i],sigma);
  }

}

