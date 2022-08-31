#' mcbette: Model Comparison Using Babette
#'
#' 'mcbette' does a model comparing using \link[babette]{babette},
#' where the models are Bayesian phylogenetic models,
#' as created by \link[beautier]{create_inference_model}.
#'
#' The main function is \link{est_marg_liks},
#' which estimate the marginal likelihoods (aka evidence)
#' for one or more inference models, based on a single alignment.
#' Also, the marginal likelihoods are compared, resulting in a
#' relative weight for each model, where a relative weight of a model
#' close to \code{1.0} means that that model is way likelier than
#' the others.
#'
#' In the process, multiple (temporary) files are created (where
#' \code{[x]} denotes the index in a list)
#'
#' \itemize{
#'   \item \code{beast2_optionses[x]$input_filename}
#'     path to the the BEAST2 XML input file
#'   \item \code{beast2_optionses[x]$output_state_filename}
#'     path to the BEAST2 XML state file
#'   \item \code{inference_models[x]$mcmc$tracelog$filename}
#'     path to the BEAST2 trace file with parameter estimates
#'   \item \code{inference_models[x]$mcmc$treelog$filename}
#'     path to the BEAST2 \code{trees} file with the posterior trees
#'   \item \code{inference_models[x]$mcmc$screenlog$filename}
#'     path to the BEAST2 screen output file
#' }
#'
#' These file can be deleted manually by \link[babette]{bbt_delete_temp_files},
#' else these will be deleted automatically by the operating system.
#' @seealso Use \link{can_run_mcbette} to see if 'mcbette' can run.
#' @examples
#' if (can_run_mcbette()) {
#'
#'   # An example FASTA file
#'   fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
#'
#'   inference_model_1 <- beautier::create_ns_inference_model(
#'     site_model = beautier::create_jc69_site_model()
#'   )
#'   inference_model_2 <- beautier::create_ns_inference_model(
#'     site_model = beautier::create_gtr_site_model()
#'   )
#'
#'   # Shorten the run, by doing a short (dirty, unreliable) MCMC
#'   inference_model_1$mcmc <- beautier::create_test_ns_mcmc()
#'   inference_model_2$mcmc <- beautier::create_test_ns_mcmc()
#'
#'   inference_models <- c(list(inference_model_1), list(inference_model_2))
#'
#'   # Estimate the marginal log-likelihoods of the two models
#'   marg_liks <- est_marg_liks(
#'     fasta_filename = fasta_filename,
#'     inference_models = inference_models
#'   )
#'
#'   # Interpret the results
#'   interpret_marg_lik_estimates(marg_liks)
#'
#'   beastier::remove_beaustier_folders()
#'   beastier::check_empty_beaustier_folders()
#' }
#' @docType package
#' @name mcbette
#' @author Richèl J.C. Bilderbeek
#' @importFrom beautier create_alpha_param
#' @importFrom beautier create_bd_tree_prior
#' @importFrom beautier create_beast2_input
#' @importFrom beautier create_beast2_input_file
#' @importFrom beautier create_beast2_input_file_from_model
#' @importFrom beautier create_beast2_input_from_model
#' @importFrom beautier create_beta_distr
#' @importFrom beautier create_beta_param
#' @importFrom beautier create_cbs_tree_prior
#' @importFrom beautier create_ccp_tree_prior
#' @importFrom beautier create_cep_tree_prior
#' @importFrom beautier create_clock_model
#' @importFrom beautier create_clock_model_from_name
#' @importFrom beautier create_clock_model_rln
#' @importFrom beautier create_clock_model_strict
#' @importFrom beautier create_clock_models
#' @importFrom beautier create_clock_models_from_names
#' @importFrom beautier create_clock_rate_param
#' @importFrom beautier create_distr
#' @importFrom beautier create_distr_beta
#' @importFrom beautier create_distr_exp
#' @importFrom beautier create_distr_gamma
#' @importFrom beautier create_distr_inv_gamma
#' @importFrom beautier create_distr_laplace
#' @importFrom beautier create_distr_log_normal
#' @importFrom beautier create_distr_normal
#' @importFrom beautier create_distr_one_div_x
#' @importFrom beautier create_distr_poisson
#' @importFrom beautier create_distr_uniform
#' @importFrom beautier create_exp_distr
#' @importFrom beautier create_gamma_distr
#' @importFrom beautier create_gamma_site_model
#' @importFrom beautier create_gtr_site_model
#' @importFrom beautier create_hky_site_model
#' @importFrom beautier create_inference_model
#' @importFrom beautier create_inv_gamma_distr
#' @importFrom beautier create_jc69_site_model
#' @importFrom beautier create_kappa_1_param
#' @importFrom beautier create_kappa_2_param
#' @importFrom beautier create_lambda_param
#' @importFrom beautier create_laplace_distr
#' @importFrom beautier create_log_normal_distr
#' @importFrom beautier create_m_param
#' @importFrom beautier create_mcmc
#' @importFrom beautier create_mcmc_nested_sampling
#' @importFrom beautier create_mean_param
#' @importFrom beautier create_mrca_prior
#' @importFrom beautier create_mu_param
#' @importFrom beautier create_normal_distr
#' @importFrom beautier create_ns_mcmc
#' @importFrom beautier create_one_div_x_distr
#' @importFrom beautier create_param
#' @importFrom beautier create_param_alpha
#' @importFrom beautier create_param_beta
#' @importFrom beautier create_param_clock_rate
#' @importFrom beautier create_param_kappa_1
#' @importFrom beautier create_param_kappa_2
#' @importFrom beautier create_param_lambda
#' @importFrom beautier create_param_m
#' @importFrom beautier create_param_mean
#' @importFrom beautier create_param_mu
#' @importFrom beautier create_param_rate_ac
#' @importFrom beautier create_param_rate_ag
#' @importFrom beautier create_param_rate_at
#' @importFrom beautier create_param_rate_cg
#' @importFrom beautier create_param_rate_ct
#' @importFrom beautier create_param_rate_gt
#' @importFrom beautier create_param_s
#' @importFrom beautier create_param_scale
#' @importFrom beautier create_param_sigma
#' @importFrom beautier create_poisson_distr
#' @importFrom beautier create_rate_ac_param
#' @importFrom beautier create_rate_ag_param
#' @importFrom beautier create_rate_at_param
#' @importFrom beautier create_rate_cg_param
#' @importFrom beautier create_rate_ct_param
#' @importFrom beautier create_rate_gt_param
#' @importFrom beautier create_rln_clock_model
#' @importFrom beautier create_s_param
#' @importFrom beautier create_scale_param
#' @importFrom beautier create_screenlog
#' @importFrom beautier create_sigma_param
#' @importFrom beautier create_site_model
#' @importFrom beautier create_site_model_from_name
#' @importFrom beautier create_site_model_gtr
#' @importFrom beautier create_site_model_hky
#' @importFrom beautier create_site_model_jc69
#' @importFrom beautier create_site_model_tn93
#' @importFrom beautier create_site_models
#' @importFrom beautier create_site_models_from_names
#' @importFrom beautier create_strict_clock_model
#' @importFrom beautier create_temp_screenlog_filename
#' @importFrom beautier create_temp_tracelog_filename
#' @importFrom beautier create_temp_treelog_filename
#' @importFrom beautier create_test_inference_model
#' @importFrom beautier create_test_mcmc
#' @importFrom beautier create_test_ns_inference_model
#' @importFrom beautier create_test_ns_mcmc
#' @importFrom beautier create_test_screenlog
#' @importFrom beautier create_test_tracelog
#' @importFrom beautier create_test_treelog
#' @importFrom beautier create_tn93_site_model
#' @importFrom beautier create_tracelog
#' @importFrom beautier create_tree_prior
#' @importFrom beautier create_tree_prior_bd
#' @importFrom beautier create_tree_prior_cbs
#' @importFrom beautier create_tree_prior_ccp
#' @importFrom beautier create_tree_prior_cep
#' @importFrom beautier create_tree_prior_yule
#' @importFrom beautier create_tree_priors
#' @importFrom beautier create_treelog
#' @importFrom beautier create_uniform_distr
#' @importFrom beautier create_xml_declaration
#' @importFrom beautier create_yule_tree_prior
#' @importFrom beautier is_on_ci
#' @importFrom beastier check_beast2
#' @importFrom beastier create_beast2_options
#' @importFrom beastier install_beast2
#' @importFrom beastier is_beast2_installed
#' @importFrom beastier uninstall_beast2
#' @importFrom mauricer install_beast2_pkg
#' @importFrom mauricer is_beast2_ns_pkg_installed
#' @importFrom mauricer uninstall_beast2_pkg
NULL
