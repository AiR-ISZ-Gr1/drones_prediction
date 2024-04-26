data {
  int<lower=1> N;   // number of samples per item
  int<lower=1> IL;   // number of labeled data items
  int<lower=1> K;   // number of predictors
  int<lower=1> M;  // number of mixture components
  matrix[N, K] x;   // predictor matrix
  array[IL] int<lower=1,upper=M> labels;
  matrix[N,IL]  y_labeled;      // matrix of labeled outputs
  simplex [M] lambda0; // prior for mixture components
  int<lower=1> IT;   // number of test data items
  matrix[N,IT]  y_test;      // matrix of test outputs
  
}
transformed data {
  matrix[N, K] Q_ast;
  matrix[K, K] R_ast;
  matrix[K, K] R_ast_inverse;
  // thin and scale the QR decomposition
  Q_ast = qr_thin_Q(x) * sqrt(N - 1);
  R_ast = qr_thin_R(x) / sqrt(N - 1);
  R_ast_inverse = inverse(R_ast);
}
parameters {
  matrix[K,M] theta;      // coefficients on Q_ast for each mixture component
  array [M] real<lower=0> sigma;  // error scale for each mixture component
  simplex [M] lambda; //mixture components
}
model {
  vector[M] log_lambda = log(lambda);  // cache log calculation

  for (m in 1:M) {
     /* code */
     target += std_normal_lpdf(theta[1:K,m]);
  }

  sigma ~ exponential(1);
  lambda ~ dirichlet(lambda0);
  
  for (n in 1:IL) {
    target += normal_lpdf(y_labeled[1:N,n] | Q_ast * theta[1:K,labels[n]], sigma[labels[n]]);    
  }  

}
generated quantities {
  matrix[K,M] beta = R_ast_inverse * theta;// coefficients on x
  matrix[M,IT] probabilities;
  matrix[M,IT] log_probabilities;
  {
  real normalizer;
   for (n in 1:IT) {
      /* code */
      for (m in 1:M) {
         /* code */
          log_probabilities[m,n]=normal_lpdf(y_test[1:N,n]|  Q_ast * theta[1:K,m], sigma[m]) +log(lambda[m]);   
          print("probs =", log_probabilities[m,n]);

      }
      normalizer = log_sum_exp( log_probabilities[1:M,n]);
      log_probabilities[1:M,n] = log_probabilities[1:M,n]-normalizer;
   }
  }
  probabilities = exp(log_probabilities);
  
}
