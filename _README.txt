%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Kevin P. Timms <timms.kevin@gmail.com>
% Exercise for readers of "Idiographic Dynamic Modeling and System Identification of Mediated Behavior Change with a Smoking Cessation Case Study" to appear in Multivariate Behavioral Research.
% Manuscript authors: Kevin P. Timms, Daniel E. Rivera, Linda M. Collins, & Megan E. Piper
% Corresponding author: Daniel E. Rivera <daniel.rivera@asu.edu>

% This document last updated: 2015-05-06
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


This document describes the contents of the files accessible at https://github.com/timmskep/DynamicMedModeling. The files available offer readers of the manuscript a simplified dynamical mediation modeling exercise that employs the same general procedure as that used for the manuscript's case study. The authors offer a number of comments about the files and the exercise:

- This exercise estimates dynamical mediation models to describe craving-mediated changes in daily smoking levels, where the craving and smoking dynamics are induced by an initiation of a quit attempt.

- Two example data sets are provided. It should be noted that these data sets are *not* the data used in the manuscripts case study. Rather, they are data describing behavior change in two hypothetical subjects. This data was produced in MATLAB by simulating the response of craving and smoking levels to initiation of a quit attempt using the estimated case study models and captured in the manuscript's Equations (20) - (22), and then adding noise to the simulated data.

- The noise added to the simulated data sets is white Gaussian noise with a signal-to-noise ratio of 20 dB. Negative values of the cigarettes per day metric of the resulting noisy simulated data were then adjusted to equal 0. More information on how the noise was incorporated is found at the following: http://www.mathworks.com/help/comm/ref/awgn.html

- The files were most recently configured to run on MATLAB version 2015a.

- Once the files are downloaded, the user should change the MATLAB directory to the folder in which the downloaded files are saved. Only then can they be run.

- The files included are:
    > example_subject_1.csv -- The data for hypothetical Subject #1, patterned after the dynamics observed for the manuscript's Subject 1.
    > example_subject_2.csv -- The data for hypothetical Subject #2, patterned after the dynamics observed for the manuscript's Subject 2.
    > DynamicalModelingExercise_code.m -- The script to be run in MATLAB that estimates differential equations for Pa, Pb, and Pc' that describe craving-mediated cessation for the hypothetical subjects. Using this file, we invite the reader to estimate models for both hypothetical subjects and using different equation structures for Pa, Pb, and Pc'; this can be done with minor adjustments to the code, which is commented to indicate where these adjustments can be made.
    > DynamicalMediationModel_Sim.slx -- The Simulink file called by DynamicalModelingExercise_code.m in which the response of craving and smoking levels to initiation of a quit attempt are simulated, using an set of estimated differential equations.
