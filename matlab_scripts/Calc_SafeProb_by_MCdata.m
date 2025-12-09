clear
close all
clc


load("../data/multi_agent/MC/StateTrajectories_MCdata.mat","L","X","N","n","path_num","time_num","terminal_time")


% Define the barrier function
[T, Lambda] = eig(L);
barrier = @(v,x,gamma) gamma - norm(transpose(kron(v,eye(2)))*x, inf);


% Check if the state vector of multi-agents are contained in the safe set
count = zeros(time_num+1, path_num);

for j = 1:path_num
    for i = 1:time_num+1
        if barrier(T(:,1), X(:,i,j), 2) >= 0 && barrier(T(:,2), X(:,i,j), 2) >= 0 && barrier(T(:,3), X(:,i,j), 1) >= 0 && barrier(T(:,4), X(:,i,j), 1) >= 0 && barrier(T(:,5), X(:,i,j), 1) >= 0 && barrier(T(:,6), X(:,i,j), 1) >= 0 && barrier(T(:,7), X(:,i,j), 1) >= 0
            count(i,j) = 1;
        else
            count(i,j) = 0;
        end
    end
end


% NOT count once the state enter the unsafe set
for j = 1:path_num
    for i = 1:time_num
        if count(i,j) == 0
            count(i+1,j) = 0;
        end
    end
end

time = linspace(0, terminal_time, time_num+1);
safeprob_MC = sum(transpose(count))/path_num;


figure
    plot(time, safeprob_MC, LineWidth=1.5)
    box on
    pbaspect([1,1,1])
    ax = gca;
    ax.LineWidth = 1.0;
    ax.XAxis.FontSize = 14;
    ax.YAxis.FontSize = 14;
    xlabel('Time Horizon $t_H$','Interpreter','latex');
    ylabel('Safety Probability $\pi$','Interpreter','latex');
    xlim([0,terminal_time])
    ylim([0,1.1])

print('Plot_SafeProb_by_MCdata', '-dsvg');
save("../data/multi_agent/MC/Calc_SafeProb_by_MCdata.mat","safeprob_MC")