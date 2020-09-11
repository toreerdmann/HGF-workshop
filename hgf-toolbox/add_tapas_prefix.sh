#!/bin/bash
rename 's/(.*)\.m/tapas_$1.m/g' *.m
perl -pi -e 's/bayes_/tapas_bayes_/g' *.m README
perl -pi -e 's/bayesian_/tapas_bayesian_/g' *.m README
perl -pi -e 's/fitModel/tapas_fitModel/g' *.m README
perl -pi -e 's/fit_plotCorr/tapas_fit_plotCorr/g' *.m README
perl -pi -e 's/gaussian_/tapas_gaussian_/g' *.m README
perl -pi -e 's/hgf\(/tapas_hgf(/g' *.m README
perl -pi -e 's/@hgf/@tapas_hgf/g' *.m README
perl -pi -e 's/hgf_/tapas_hgf_/g' *.m README
perl -pi -e 's/logit\(/tapas_logit(/g' *.m README
perl -pi -e 's/quasinewton_/tapas_quasinewton_/g' *.m README
perl -pi -e 's/riddersdiff\(/tapas_riddersdiff(/g' *.m README
perl -pi -e 's/riddersdiff2\(/tapas_riddersdiff2(/g' *.m README
perl -pi -e 's/riddersdiffcross\(/tapas_riddersdiffcross(/g' *.m README
perl -pi -e 's/riddersgradient\(/tapas_riddersgradient(/g' *.m README
perl -pi -e 's/riddershessian\(/tapas_riddershessian(/g' *.m README
perl -pi -e 's/rs_/tapas_rs_/g' *.m README
perl -pi -e 's/gtapas_/g/g' tapas_grw_gen.m
perl -pi -e 's/sgm\(/tapas_sgm(/g' *.m README
perl -pi -e 's/simModel\(/tapas_simModel(/g' *.m README
perl -pi -e 's/@softmax/@tapas_softmax/g' *.m README
perl -pi -e 's/softmax\(/tapas_softmax(/g' *.m README
perl -pi -e 's/softmax_/tapas_softmax_/g' *.m README
perl -pi -e 's/squared_/tapas_squared_/g' *.m README
perl -pi -e 's/sutton_/tapas_sutton_/g' *.m README
perl -pi -e 's/unitsq_/tapas_unitsq_/g' *.m README
perl -pi -e 's/Cov2Corr\(/tapas_Cov2Corr(/g' *.m README
perl -pi -e 's/plot_/tapas_plot_/g' *.m README
perl -pi -e 's/grw_/tapas_grw_/g' *.m README
perl -pi -e 's/ar1_/tapas_ar1_/g' *.m README
