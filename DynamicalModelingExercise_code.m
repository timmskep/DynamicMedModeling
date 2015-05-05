clear all
close all
warning off
options = simset('SrcWorkspace','current');

load example_subject_1.csv;
load example_subject_2.csv;


%%%%%%%%%%%%%%%%%%%%%%

%%% Comment and un-comment the following as desired to estimate models using the different example data (produced in simulation, not actual clinical trial data)

example_data = example_subject_1;
% example_data = example_subject_2;

%%%%%%%%%%%%%%%%%%%%%%


%%% Gather the data used for estimation

TotalSampleT=size(example_data,1);
BaseEnd=8;      % Index of last datapoint in baseline time period

craving_data_raw = example_data(1:TotalSampleT,2);
cigsmked_data_raw = example_data(1:TotalSampleT,3);

craving_base = (craving_data_raw(BaseEnd)+craving_data_raw(BaseEnd-1)+craving_data_raw(BaseEnd-2))/3;
cigsmked_base = (cigsmked_data_raw(BaseEnd)+cigsmked_data_raw(BaseEnd-1)+cigsmked_data_raw(BaseEnd-2))/3;

craving_dev = craving_data_raw - craving_base;      % Putting data in deviation variable form
cigsmked_dev = cigsmked_data_raw - cigsmked_base;


%%% Define the possible ODE structures we want to test as "Type"
% See Table 2 of manuscript for more information on structures. More detail found at http://www.mathworks.com/help/ident/ref/idproc.html

type = {'P1';'P1Z';'P2';'P2U';'P2Z';'P2ZU';'P0';'P3';'P3U';'P3Z';'P3ZU';'P1I';'P1IZ';'P2I';'P2IU';'P2IZ';'P2IZU';'P3I';'P3IU';'P3IZ';'P3IZU';'P1D';'P1ZD';'P2D';'P2UD';'P2ZD';'P2ZUD';'P3D';'P3UD';'P3ZD';'P3ZUD';'P1ID';'P1IZD';'P2ID';'P2IUD';'P2IZD';'P2IZUD';'P3ID';'P3IUD';'P3IZD';'P3IZUD'};
struct=idproc(type);

    %  1st element in "struct": P1, a first-order ODE
    %  2nd: P1Z, first-order with zero term
    %  3rd: P2, second-order ODE
    %  4th: P2U, second order with complex poles (will feature oscillation)
    %  5th: P2Z, second order with zero term
    %  7th: p0, just a gain

%%% Define Quit variable

StepTime=8; 
OneDayPriorToTreatment=StepTime-1;
BaseBegin=StepTime-6;

Quit(1:OneDayPriorToTreatment)=0;
Quit(StepTime:length(craving_dev))=1;    

                                
%%% Estimate P_a as a single-input, single-output system

X = [Quit'];                    % Quit is X(t) in this example
med = [craving_dev];            % Craving is M(t) in this example
med_base = craving_base;

med_iddata = iddata(med,X,1);   % Defines P_a as a single-input, single-output system with Quit as the input and craving as the output

j = 2;
pA_struct=struct(j);            % P_a defined to have an ODE structure corresponding to the j-th element in the "struct" variable created earlier in this script
                                % Vary j as desired to esitmate candidate models with different ODE structures for P_a

med_model = pem(med_iddata,pA_struct)      % Estimates P_a


%%% Estimate P_c' and P_b simultaneously as a 2-input, 1-output system

out = [cigsmked_dev];
out_base = cigsmked_base;

out_iddata = iddata(out,[X, med],1);

m = 7;                          % Assigns an ODE structure to the P_c' function to be estimated
n = 1;                          % Assigns an ODE structure to the P_b function to be estimated
pC_struct=struct(m);            
pB_struct=struct(n);

out_model=pem(out_iddata',[pC_struct pB_struct])
                

%%% Use the estimated P_a, P_b, and P_c' expressions in a simulation of how the mediator and outcome respond to X(t), as captured in the estimated ODEs

sim('DynamicalMediationModel_SimB',[],options);         % Runs the simulation, where "new_out_sim" is the name of a simulation file
med_sim = med_response_sim.signals.values;                     % The simulated data for M(t) responding to the defined change in X(t) according ot the model
out_sim = out_response_sim.signals.values;                 % The simulated data for Y(t) responding to the defined change in X(t) through the mediated and non-mediated paths, according to the model


%%% Assess the estimated models
        
m_stddev=sqrt(diag(med_model.CovarianceMatrix));    % Gives the standard deviations for the P_a parameter estimates
o_stddev=sqrt(diag(out_model.CovarianceMatrix));    % Gives the standard deviations for the P_b, P_c' parameter estimates

x2=1:length(med);                                   % Get the settling times of the estimated ODEs
placeholder_var_stepinfo=stepinfo(med,x2,med(end));
settling_m=placeholder_var_stepinfo.SettlingTime    % Settling time for mediator
placeholder_var_stepinfo=stepinfo(out,x2,out(end));
settling_o=placeholder_var_stepinfo.SettlingTime    % Settling time of outcome
        
m_diff_h=med-med_sim(1:length(med));                % Calculating the goodness-of-fit metric
m_diff_h_norm=norm(m_diff_h);
m_mean=mean(med);
m_d_mean=med-m_mean;
m_d_mean_norm=norm(m_d_mean);
MediatorModel_FitPercent=100*(1-(m_diff_h_norm/m_d_mean_norm))    % Goodness-of-fit metric for the mediator variable

o_diff_h=out-out_sim(1:length(out));
o_diff_h_norm=norm(o_diff_h);
o_mean=mean(out);
o_d_mean=out-o_mean;
o_d_mean_norm=norm(o_d_mean);
OutcomeModel_FitPercent=100*(1-(o_diff_h_norm/o_d_mean_norm))    % Goodness-of-fit metric for the outcome variable


%%% Plot the data, simulated responses

time=1:length(med);     time = time';
med_plot = med + med_base;
out_plot = out + out_base;
med_sim_plot = med_sim + med_base;
out_sim_plot = out_sim + out_base;

figure(1)
plot(time,med_plot,'b--',time,med_sim_plot,'b'), legend('Data used for estimation', 'Simulated response predicted by estimated expression')
title('Mediator');

figure(2)
plot(time,out_plot,'b--',time,out_sim_plot,'b'), legend('Data used for estimation', 'Simulated response predicted by estimated expression')
title('Outcome');
