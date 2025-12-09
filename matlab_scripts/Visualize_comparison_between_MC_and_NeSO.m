clear
close all
clc

% MC data
load("../data/multi_agent/MC/Calc_SafeProb_by_MCdata.mat")

% PDE data
% load("../data/multi_agent/PDE/SafeProb_FK_GeneralGraph_solData_(lambda_0,sigma=0.2).mat")
% load("../data/multi_agent/PDE/SafeProb_FK_GeneralGraph_solData_(lambda_1,sigma=0.2).mat")
% load("../data/multi_agent/PDE/SafeProb_FK_GeneralGraph_solData_(lambda_2,sigma=0.2).mat")
% load("../data/multi_agent/PDE/SafeProb_FK_GeneralGraph_solData_(lambda_3,sigma=0.2).mat")
% load("../data/multi_agent/PDE/SafeProb_FK_GeneralGraph_solData_(lambda_4,sigma=0.2).mat")
% load("../data/multi_agent/PDE/SafeProb_FK_GeneralGraph_solData_(lambda_5,sigma=0.2).mat")
% load("../data/multi_agent/PDE/SafeProb_FK_GeneralGraph_solData_(lambda_6,sigma=0.2).mat")

% NeSO data
load("../data/multi_agent/NeSO/SafeProb_FK_GeneralGraph_solData_matlab_with_time.mat")

threshold = [2, 2, 1.0, 1.0, 1.0, 1.0, 1.0];

% time steps for plotting
times = linspace(0, 10, 101);

% Setting the initial state vector
N = 7;
n = 2;
L = [5, -1, -1, -1, -1, -1, 0;
    -1, 3, 0, -1, 0, 0, -1;
    -1, 0, 2, 0, -1, 0, 0;
    -1, -1, 0, 4, -1, -1, 0;
    -1, 0, -1, -1, 4, -1, 0;
    -1, 0, 0, -1, -1, 3, 0;
    0, -1, 0, 0, 0, 0, 1];
[T, Lambda] = eig(L);
GFT = kron(transpose(T), eye(n));

initial_state_1 = transpose([0.3, 0.6, -0.6, 0.1, 0.3, -0.6, 0]);
initial_state_2 = transpose([-0.4, 0.6, -0.4, 0.6, 0.3, 0.1, -0.6]);
initial_state = kron(initial_state_1, [1;0]) + kron(initial_state_2, [0;1]);
initial_graph_spectrum = GFT * initial_state;

% Safety Probability obtained by MC simulation
time_num = length(times);
safeprob_stat = zeros(time_num, 1);

for i = 1:time_num
    safeprob_stat(i) = safeprob_MC((length(safeprob_MC)-1)*(i-1)/(time_num-1) + 1);
end

% Safety Probability obtained by Feynman-Kac PDE
safeprob_PDEdata = cat(4, data_lambda_0, data_lambda_1, data_lambda_2, data_lambda_3, data_lambda_4, data_lambda_5, data_lambda_6);
safeprob_mode = zeros(time_num, N);

for i = 1:N
    step_size = 2*threshold(i)/256;
    x_index = round((initial_graph_spectrum(2*i-1) + threshold(i)) / step_size);
    y_index = round((initial_graph_spectrum(2*i) + threshold(i)) / step_size);
    safeprob_mode(:,i) = safeprob_PDEdata(:, x_index, y_index, i);
end

safeprob_FK = prod(safeprob_mode, 2);

figure
hold on
box on

% colors = slanCM('RdPu', 10); 
colors = parula(10); % or 'jet', 'hot', 'cool', etc.
colororder(colors);

if 1
    for i = 1:N
        h = plot(times, safeprob_mode(:,i), LineWidth=2);
    end
end

plot(times, safeprob_stat, LineWidth=2, Color=[0, 0, 0.9])
plot(times, safeprob_FK, LineStyle='--', LineWidth=2, Color=[0.8, 0, 0])

lgd = legend('$\ F_1$','$\ F_2$','$\ F_3$','$\ F_4$','$\ F_5$','$\ F_6$','$\ F_7$','$\ F\ (\mathrm{Ground\ truth})$','$\ \prod_{k=1}^7F_k\ (\mathrm{Proposed})$',Interpreter='latex', FontSize=12, Location='southwest');
legend('boxoff')
lgd.LineWidth = 1;
lgd.NumColumns = 2;
lgd.EdgeColor = 'k';
pbaspect([1,1,1])

ax = gca;
ax.LineWidth = 1.0;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
xlabel('Time Horizon $T$','Interpreter','latex');
ylabel('Safety Probability $F,F_k$','Interpreter','latex');
xlim([0,10])
ylim([0, 1.02])

filename = sprintf('multi_safe_prob.pdf');
print(gcf, filename, '-dsvg');

% Compute time-averaged absolute and relative differences
abs_diff = abs(safeprob_FK - safeprob_stat);
avg_abs_diff = mean(abs_diff);

mask = safeprob_stat > 1e-8;  % avoid dividing by values too close to zero
relative_diff = zeros(size(safeprob_stat));
relative_diff(mask) = abs_diff(mask) ./ safeprob_stat(mask);
avg_relative_diff = mean(relative_diff(mask));

fprintf('Time-averaged absolute difference: %.4f\n', avg_abs_diff);
fprintf('Time-averaged relative difference: %.4f (%.2f%%)\n', ...
        avg_relative_diff, 100 * avg_relative_diff);




