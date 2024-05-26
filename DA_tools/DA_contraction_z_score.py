import numpy as np

def get_z_contr(results,num_knots):
    z_score_run = []
    contr_run = []
    z_score = []
    contr = []
    prior_param = results.stan_variable('sigma_sim_hat')[0]
    post_mn = np.mean(results.stan_variable('sigma'))
    post_sd = np.std(results.stan_variable('sigma'))
    prior_sd = 1
    z_score.append((post_mn-prior_param)/post_sd)
    contr.append(1 - (post_sd/prior_sd)**2)
    
    for knot in range(num_knots):
        prior_param = results.stan_variable('betas_sim_hat')[0,knot]
        post_mn = np.mean(results.stan_variable('betas')[:,knot])
        post_sd = np.std(results.stan_variable('betas')[:,knot])
        prior_sd = 1
        z_score.append((post_mn-prior_param)/post_sd)
        contr.append(1 - (post_sd/prior_sd)**2)

    z_score_run.append(z_score)
    contr_run.append(contr)
    return z_score_run, contr_run