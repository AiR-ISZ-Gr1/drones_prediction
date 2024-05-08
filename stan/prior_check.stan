data {
  int N; //number of measurements
  int K; //number of basis functions
  matrix [N,K] X; //design matrix
}


generated quantities {
  vector[N] y_pred;
  real sigma;
  vector[K] betas;
  vector[N] mu;

  sigma = exponential_rng(1);
  print("sigma",sigma);
  for (k in 1:K) {
      betas[k] = normal_rng(2,6);
  }
  mu = X*betas;
  print("mu",mu);
  for (i in 1:N) {
    y_pred[i] = normal_rng(mu[i],sigma);
  }

}

