% Compute MaxEnt objective and gradient. Discounted infinite-horizon version.
function [val,dr] = maxentdiscounted(r,F,muE,mu_sa,mdp_data,initD,laplace_prior)

if nargin < 7,
    laplace_prior = 0;
end;

% Compute constants.
actions = mdp_data.actions;

% Convert to full reward.
wts = r;


[row,~,~] = find(F); %Finds non zero indices
rew = zeros(size(F,1),1);

rew(row) = r;
r = F*rew;




[~,~,policy,logpolicy] = linearvalueiteration(mdp_data,repmat(r,1,actions));


%[~,~,policy,logpolicy] = td_learning(mdp_data,repmat(r,1,actions));

% Compute value by adding up log example probabilities.
val = sum(sum(logpolicy.*mu_sa));   % This is computing a mean Q value by averaging with the probability of observing (s,a) 

% Add laplace prior.
if laplace_prior,
    val = val - laplace_prior*sum(abs(wts));
end;

% Invert for descent.
val = -val;

if nargout >= 2,    
    % Compute state visitation count D.
    D = linearmdpfrequency(mdp_data,struct('p',policy),initD);

    % Compute gradient.
    dr = muE - F'*D;
    dr = nonzeros(dr);
    % Laplace prior.
    if laplace_prior,
        dr = dr - laplace_prior*sign(wts);
    end;
    
    % Invert for descent.
    dr = -dr;
end;