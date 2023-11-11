% plot results after running main.m
% requires:
%   legendflex (by kakearney)
%   boundedline (by kakearney)
%   barwitherr (by Martina Callaghan)

linewidth = 3;
axiswidth = 2;
perc = 0:100;
r2d = 180/pi;
%% x y z ankle angles - group means single vs multi
figure;
set(gcf, 'Color', 'White');
for j = 1:3
    subplot(2,3,j)  % Angle
    b1 = boundedline(perc, groupMeans.ankleAngleSingle(j,:)'*r2d, groupSD.ankleAngleSingle(j,:)'*r2d, 'alpha');
    hold on;
    b2 = boundedline(perc, groupMeans.ankleAngleMulti(j,:)'*r2d, groupSD.ankleAngleMulti(j,:)'*r2d, 'r--', 'alpha');
    set(gca, 'LineWidth', axiswidth);
    set([b1 b2], 'LineWidth', linewidth);
    r0 = yline(0);
    set(r0,'LineWidth',1, 'LineStyle', '--', 'Color', 'black')
    if j == 1
        ylabel('Angle (deg)')
    end
    xlabel('% Stance')
    axis([0 100 -0.5*r2d 0.5*r2d])
end
hl = legendflex([b1 b2]', {'SINGLE', 'MULTI'}, 'Orientation','horizontal', ...
    'box', 'off','xscale', 0.6);
annotation(gcf,'textbox',...
    [0.18 0.93 0.2 0.055],...
    'String',{'Frontal (x-axis)'},...
    'EdgeColor','White', ...
     'FontSize', 14);
annotation(gcf,'textbox',...
    [0.46 0.93 0.2 0.055],...
    'String',{'Transverse (y-axis)'},...
     'EdgeColor','White', ...
     'FontSize', 14);
annotation(gcf,'textbox',...
    [0.74 0.93 0.2 0.05],...
    'String',{'Sagittal (z-axis)'},...
     'EdgeColor','White', ...
     'FontSize', 14);
set(findall(gcf,'type','text'),'FontSize',14)
set(findall(gcf,'type','axes'), 'FontSize',14, 'box','off');

%% x y z ankle angular velocity - group means single vs multi
figure;
set(gcf, 'Color', 'White');

for j = 1:3
    subplot(2,3,j)  % Angle
    b1 = boundedline(perc, groupMeans.ankleVelSingle(j,:)'*r2d, groupSD.ankleVelSingle(j,:)'*r2d, 'alpha');
    hold on;
    b2 = boundedline(perc, groupMeans.ankleVelMulti(j,:)'*r2d, groupSD.ankleVelMulti(j,:)'*r2d, 'r--', 'alpha');
    set(gca, 'LineWidth', axiswidth);
    set([b1 b2], 'LineWidth', linewidth);
%     r0 = yline(0);
%     set(r0,'LineWidth',1, 'LineStyle', '--', 'Color', 'black')
    if j == 1
        ylabel('Angular Velocity (deg/s)')
    end
    xlabel('% Stance')
%     axis([0 100 -0.5 0.5])
end
hl = legendflex([b1 b2]', {'SINGLE', 'MULTI'}, 'Orientation','horizontal', ...
    'box', 'off','xscale', 0.6);
annotation(gcf,'textbox',...
    [0.18 0.90 0.2 0.055],...
    'String',{'Frontal (x-axis)'},...
    'EdgeColor','White', ...
     'FontSize', 14);
annotation(gcf,'textbox',...
    [0.46 0.88 0.2 0.055],...
    'String',{'Transverse (y-axis)'},...
     'EdgeColor','White', ...
     'FontSize', 14);
annotation(gcf,'textbox',...
    [0.74 0.91 0.2 0.05],...
    'String',{'Sagittal (z-axis)'},...
     'EdgeColor','White', ...
     'FontSize', 14);
set(findall(gcf,'type','text'),'FontSize',14)
set(findall(gcf,'type','axes'), 'FontSize',14, 'box','off');


%% x y z ankle moments - single vs multi
figure;
set(gcf, 'Color', 'White');
for j = 1:3
    subplot(2,3,j)  % Angle
    b1 = boundedline(perc, groupMeans.ankleMomSingle_norm(:,j), groupSD.ankleMomSingle_norm(:,j), 'alpha');
    hold on;
    b2 = boundedline(perc, groupMeans.ankleMomMulti_norm(:,j), groupSD.ankleMomMulti_norm(:,j), 'r--', 'alpha');
    set(gca, 'LineWidth', axiswidth);
    set([b1 b2], 'LineWidth', linewidth);
    r0 = yline(0);
    set(r0,'LineWidth',1, 'LineStyle', '--', 'Color', 'black')
    if j == 1
        ylabel('Ankle Moment (N m/kg)')
    end
    xlabel('% Stance')
    axis([0 100 -3 0.5])
end
hl = legendflex([b1 b2]', {'SINGLE', 'MULTI'}, 'Orientation','horizontal', ...
    'box', 'off','xscale', 0.6);
% set(hl, 'box', 'off', 'XColor', 'White', 'YColor', 'White');
annotation(gcf,'textbox',...
    [0.18 0.90 0.2 0.055],...
    'String',{'Frontal (x-axis)'},...
    'EdgeColor','White', ...
     'FontSize', 14);
annotation(gcf,'textbox',...
    [0.46 0.88 0.2 0.055],...
    'String',{'Transverse (y-axis)'},...
     'EdgeColor','White', ...
     'FontSize', 14);
annotation(gcf,'textbox',...
    [0.74 0.91 0.2 0.05],...
    'String',{'Sagittal (z-axis)'},...
     'EdgeColor','White', ...
     'FontSize', 14);
set(findall(gcf,'type','text'),'FontSize',14)
set(findall(gcf,'type','axes'), 'FontSize',14, 'box','off');


%% x y z ankle powers - single vs multi
figure;
set(gcf, 'Color', 'White');
for j = 1:3
    subplot(2,3,j)
    b1 = boundedline(perc, groupMeans.anklePowVecSingle_norm(:,j), groupSD.anklePowVecSingle_norm(:,j), 'alpha');
    hold on;
    b2 = boundedline(perc, groupMeans.anklePowVecMulti_norm(:,j), groupSD.anklePowVecMulti_norm(:,j), 'r--', 'alpha');
    set(gca, 'LineWidth', axiswidth);
    set([b1 b2], 'LineWidth', linewidth);
    r0 = yline(0);
    set(r0,'LineWidth',1, 'LineStyle', '--', 'Color', 'black')
    if j == 1
        ylabel('Ankle Power (W/kg)')
    end
    xlabel('% Stance')
    axis([0 100 -5 15])
end
hl = legendflex([b1 b2]', {'SINGLE', 'MULTI'}, 'Orientation','horizontal', ...
    'box', 'off','xscale', 0.6);
annotation(gcf,'textbox',...
    [0.18 0.93 0.2 0.055],...
    'String',{'Frontal (x-axis)'},...
    'EdgeColor','White', ...
     'FontSize', 14);
annotation(gcf,'textbox',...
    [0.46 0.93 0.2 0.055],...
    'String',{'Transverse (y-axis)'},...
     'EdgeColor','White', ...
     'FontSize', 14);
annotation(gcf,'textbox',...
    [0.74 0.93 0.2 0.05],...
    'String',{'Sagittal (z-axis)'},...
     'EdgeColor','White', ...
     'FontSize', 14);
set(findall(gcf,'type','text'),'FontSize',14)
set(findall(gcf,'type','axes'), 'FontSize',14, 'box','off');




%% VMP chart - vel, mom, power
figure;
set(gcf,'Color','White')
subplot(3,1,1)
vs = boundedline(perc, groupMeans.ankleVelSingle(3,:), groupSD.ankleVelSingle(3,:), 'alpha');
hold on;
vm = boundedline(perc,groupMeans.ankleVelMulti(3,:), groupSD.ankleVelMulti(3,:), 'alpha','r:');
r0 = yline(0);
set(r0,'LineWidth',1, 'LineStyle', '--', 'Color', 'black')
set(gca, 'LineWidth', axiswidth);
ylabel('Angular Velocity (rad/s)')
legend([vs vm], 'SINGLE', 'MULTI');
legend('boxoff');
subplot(3,1,2)
ms = boundedline(perc, groupMeans.ankleMomSingle_norm(:,3), groupSD.ankleMomSingle_norm(:,3), 'alpha');
hold on;
mm = boundedline(perc, groupMeans.ankleMomMulti_norm(:,3), groupSD.ankleMomMulti_norm(:,3), 'alpha','r:');
r0 = yline(0);
set(r0,'LineWidth',1, 'LineStyle', '--', 'Color', 'black')
set(gca, 'LineWidth', axiswidth);
ylabel('Joint Moment (N m/kg)')
subplot(3,1,3)
ps = boundedline(perc, groupMeans.anklePowVecSingle_norm(:,3), groupSD.anklePowVecSingle_norm(:,3), 'alpha');
hold on;
pm = boundedline(perc, groupMeans.anklePowVecMulti_norm(:,3), groupSD.anklePowVecMulti_norm(:,3), 'alpha','r:');
r0 = yline(0);
set(r0,'LineWidth',1, 'LineStyle', '--', 'Color', 'black')
set([vs vm ms mm ps pm], 'LineWidth', linewidth);
set(gca, 'LineWidth', axiswidth);
ylabel('Joint Power (W/kg)')
xlabel('% Stance')
set(findall(gcf,'type','text'),'FontSize',14)
set(findall(gcf,'type','axes'), 'FontSize',12, 'box','off');



%% MSFM vs SSFM Ankle Power
figure;
subplot(2,1,1)
set(gcf,'Color','White')
b1 = boundedline(perc, groupMeans.anklePowVecSingle_norm(:,3), groupSD.anklePowVecSingle_norm(:,3), 'alpha');
hold on;
b2 = boundedline(perc, groupMeans.anklePowVecMulti_norm(:,3), groupSD.anklePowVecMulti_norm(:,3), 'alpha','r:');
set([b1 b2], 'LineWidth', linewidth);
set(gca, 'LineWidth', axiswidth);
xlabel('% Stance')
ylabel('Ankle Joint Power (W/kg)')
set(r0,'LineWidth',1, 'LineStyle', '--', 'Color', 'black')
set(findall(gcf,'type','text'),'FontSize',12)
set(findall(gcf,'type','axes'), 'FontSize',12, 'box','off');
hl = legendflex([b1 b2]', {'SINGLE', 'MULTI'}, 'Orientation','horizontal', ...
    'box', 'off','xscale', 0.6);

%% Ankle vs. Midfoot power comparison
figure;
subplot(2,2,1)
set(gcf,'Color','White')
b1 = boundedline(perc, groupMeans.anklePowVecSingle_norm(:,3), groupSD.anklePowVecSingle_norm(:,3), 'alpha');
hold on;
b2 = boundedline(perc, groupMeans.anklePowVecMulti_norm(:,3), groupSD.anklePowVecMulti_norm(:,3), 'alpha','r:');
set([b1 b2], 'LineWidth', linewidth);
set(gca, 'LineWidth', axiswidth);
xlabel('% Stance')
ylabel('Ankle Joint Power (W/kg)')
r0 = yline(0);
set(r0,'LineWidth',1, 'LineStyle', '--', 'Color', 'black')
set(findall(gcf,'type','text'),'FontSize',12)
set(findall(gcf,'type','axes'), 'FontSize',12, 'box','off');
hl = legendflex([b1 b2]', {'SINGLE', 'MULTI'}, 'Orientation','horizontal', ...
    'box', 'off','xscale', 0.6);

subplot(2,2,2);
set(gcf,'Color','White')
b3 = boundedline(perc, groupMeans.anklePowerMulti, groupSD.anklePowerMulti, 'alpha');
hold on;
b4 = boundedline(perc, groupMeans.powMF, groupSD.powMF, 'r:','alpha'); 
set([b3 b4], 'LineWidth', linewidth);
set(gca, 'LineWidth', axiswidth);
r0 = yline(0);
% xlabel('% Stance')
ylabel('Midfoot Joint Power (W/kg)')
legend([b3 b4], ' Ankle',' Midfoot', 'Location', 'northwest');
legend('boxoff');
set(findall(gcf,'type','text'),'FontSize',14)
set(findall(gcf,'type','axes'), 'FontSize',14, 'box','off');

%% bar chart - ankle PF: peak ang vel & mom
figure;
set(gcf,'Color','White')
pkmom(1) = mean(-min(groupMeans.ankleMomSingle_norm(:,3)));
pkmom(2) = mean(-min(groupMeans.ankleMomMulti_norm(:,3)));
pkmomSD(1) = std(-min(groupMeans.ankleMomSingle_norm(:,3)));
pkmomSD(2) = std(-min(groupMeans.ankleMomMulti_norm(:,3)));
pkangvel(1) = mean(-min(groupMeans.ankleVelSingle(3,:))); 
pkangvel(2) = mean(-min(groupMeans.ankleVelMulti(3,:))); 
pkangvelSD(1) = std(-min(groupMeans.ankleVelSingle(3,:))); 
pkangvelSD(2) = std(-min(groupMeans.ankleVelMulti(3,:))); 
h1 = barwitherr([pkmomSD; pkangvelSD],[pkmom; pkangvel]);
set(gca,'xticklabel',{'Peak ankle plantarflexion moment (N.m / kg)','Peak ankle angular velocity (rad/s)'})
set(gca, 'LineWidth', axiswidth);
legend('SINGLE', 'MULTI');
legend('boxoff');
box off;

%% work bar chart - MSFM ankle & MF
figure;
set(gcf,'Color','White')
total = sum([groupMeans.posWorkAnkleMulti groupMeans.posWorkMF]);
totalSD = sum([groupSD.posWorkAnkleMulti groupSD.posWorkMF]);
h1 = barwitherr([ totalSD groupSD.posWorkMF  groupSD.posWorkAnkleMulti ; 0 0 groupSD.posWorkAnkleSingle], ...
                [ total groupMeans.posWorkMF  groupMeans.posWorkAnkleMulti; 0 0 groupMeans.posWorkAnkleSingle]);
set(gca,'xticklabel',{'Multisegment foot model','Single segment foot model'});
ylabel('Positive Joint Work (W kg^-^1)')
set(gca, 'LineWidth', axiswidth);
legend('Total','Midfoot', 'Ankle');
legend('boxoff');
box off;


% % powers at midfoot, ankle,knee, hip
% figure;
% subplot(4,1,1)
% plot(perc,multiModel.midftj.power / subj.mass);
% r0 = yline(0);
% set(r0,'LineWidth',2, 'LineStyle', '--', 'Color', 'black')
% subplot(4,1,2)
% plot(perc,multiModel.anklejt.power / subj.mass);
% r0 = yline(0);
% set(r0,'LineWidth',2, 'LineStyle', '--', 'Color', 'black')
% subplot(4,1,3)
% plot(perc,multiModel.kneejt.power/ subj.mass);
% r0 = yline(0);
% set(r0,'LineWidth',2, 'LineStyle', '--', 'Color', 'black')
% subplot(4,1,4)
% plot(perc,multiModel.hipjt.power/ subj.mass);
% r0 = yline(0);
% set(r0,'LineWidth',2, 'LineStyle', '--', 'Color', 'black')
% 
% % pos work pie chart
% midft = sum(multiModel.midftjt.poswork,2);
% ankle = sum(multiModel.anklejt.poswork,2);
% knee = sum(multiModel.kneejt.poswork,2);
% hip = sum(multiModel.hipjt.poswork,2);
% figure;
% pie([midft ankle knee hip])
% legend('Midfoot', 'Ankle', 'Knee', 'Hip')

%%
set(findall(gcf,'type','text'),'FontSize',16)
set(findall(gcf,'type','axes'), 'FontSize',16, 'box','off');
