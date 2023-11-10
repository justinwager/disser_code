linewidth = 3;
axiswidth = 2;

% SUBJ = [];
% for i = 1:7
%     SUBJ = [SUBJ; repmat(i,3,1)];
% end
% for i = 1:7
%     SUBJ = [SUBJ; repmat(i,3,1)];
% end
% 
% A = repmat([1 2 3]', 14, 1); % trial
% B = [repmat([0 0 0]', 7, 1); repmat([1 1 1]', 7, 1)] % model
% %view [Y A B SUBJ]

%% for 1D subj means data - paired ttest
%(e.g. 101 x 1 x nsubjs)
% z only power: anklePowerSingle
% dat1 = permute(anklePowVecSingle(:,3,:), [2 1 3]);
% dat2 =  permute(anklePowVecMulti(:,3,:), [2 1 3]);
% if ndims(dat1) == 3
%     for i = 1:7
%         for j = 1:2
%             Y(i,:) = dat1(:,:,i);
%             Y(i+7,:) = dat2(:,:,i);
%         end
%     end
% end
clear Y;
Y(1:7,:) = subjMeans.anklePowerMulti';
Y(8:14,:) = subjMeans.powMF';
T = spm1d.stats.ttest_paired(Y(1:7,:), Y(8:14, :));
Ti = T.inference(0.05)

subplot(2,2,3)
Ti.plot;
Ti.plot_p_values;
ht = Ti.plot_threshold_label;
yl = ylim;
xlabel('% Stance')
set(ht, 'Position', [ht.Position(1) yl(2) ht.Position(3)]);
set(gcf,'Color','White')
set(findall(gcf,'type','text'),'FontSize',12)
set(findall(gcf,'type','text'),'BackgroundColor','White')
set(findall(gcf,'type','axes'), 'FontSize',12, 'box','off');
set(gca, 'LineWidth', 1.5);

%% for 3d data w/ all trials - anova1rm
% all trials:
    %power anklePowVecSingle_raw
    %angle ankleAngleSingle_raw
    %vel
    %mom  
sing = anklePowVecSingle_raw;
mult = anklePowVecMulti_raw;
if (size(sing,2) > 3)
    sing = permute(sing, [2 1 3]);
    mult = permute(mult, [2 1 3]);
end

figure;
for comp = 1:3;
    dat = [sing(:,comp,:) mult(:,comp,:)];  % 101x2x21
    for i = 1:21
        for j = 1:2
            Y(i,:) = dat(:,1,i)';
            Y(i+21,:) = dat(:,2,i)';  % Y = 42 x 101
        end
    end

    % roi = false( 1, 101 );
    % roi(30:50) = true;
    F  = spm1d.stats.anova1rm( Y, B, SUBJ);
    Fi = F.inference(0.05)
    subplot(2,3,comp+3)
        f1 = Fi.plot;
        Fi.plot_p_values;
        ht = Fi.plot_threshold_label;
        yl = ylim;
        xlabel('% Stance')
        set(ht, 'Position', [ht.Position(1) yl(2)*1.05 ht.Position(3)]);
        set(gcf,'Color','White')
        set(findall(gcf,'type','text'),'FontSize',14)
        set(findall(gcf,'type','text'),'BackgroundColor','White')
        set(findall(gcf,'type','axes'), 'FontSize',14, 'box','off');
        set(gca, 'LineWidth', 2);
        set(f1(1), 'LineWidth', 3);
        
    clear Y
end
%% for 1d data w/ all trials - anova1rm 
% [101 x 3 x ntrials]
    %power anklePowVecSingle_norm(:,comp,:)
    %angle ankleAngleSingle_norm(:,comp,:)
    %vel
    %mom
sing = subjMeans.anklePowVecSingle_norm(:,3,:);  % 101 x 1 x 21
mult = subjMeans.anklePowVecMulti_norm(:,3,:);
if (size(sing,2) > 3)
    sing = permute(sing, [2 1 3]);
    mult = permute(mult, [2 1 3]);
end

dat = [sing(:,comp,:) mult(:,comp,:)];  % 101x2x21
for i = 1:21
    for j = 1:2
        Y(i,:) = dat(:,1,i)';
        Y(i+21,:) = dat(:,2,i)';
    end
end

% roi = false( 1, 101 );
% roi(30:50) = true;
F  = spm1d.stats.anova1rm( Y, B, SUBJ);  % all inputs 42 x 101
Fi = F.inference(0.05)
figure;
Fi.plot;
Fi.plot_p_values;
ht = Fi.plot_threshold_label;
yl = ylim;
xlabel('% Stance')
set(ht, 'Position', [ht.Position(1) yl(2)*1.05 ht.Position(3)]);
set(gcf,'Color','White')
set(findall(gcf,'type','text'),'FontSize',16)
set(findall(gcf,'type','text'),'BackgroundColor','White')
set(findall(gcf,'type','axes'), 'FontSize',16, 'box','off');


%% for 3d paired data - hotellings_paired
% input data for each cond (2 vars) should be nsubj x 101 x ndim, e.g. 7 x 101 x 3

[YA,YB]    = deal(permute(subjMeans.ankleVelSingle, [3 2 1]), ...
                  permute(subjMeans.ankleVelMulti, [3 2 1]));

roi = false( 1, 101 );
roi(50:100) = true;

T2       = spm1d.stats.hotellings_paired(YA, YB);
T2i      = T2.inference(0.05);
disp(T2i)
%plot
figure;
T2i.plot();
ht = T2i.plot_threshold_label();
T2i.plot_p_values();
yl = ylim;
xlabel('% Stance');
ylabel('SPM \{T^2\}');
set(ht, 'Position', [ht.Position(1) yl(2) ht.Position(3)]);
set(gcf,'Color','White')
set(findall(gcf,'type','text'),'FontSize',12)
set(findall(gcf,'type','text'),'BackgroundColor','White')
set(findall(gcf,'type','axes'), 'FontSize',12, 'box','off');
set(gca, 'LineWidth', 1.5);

% post hoc paired ttests
figure;
m        = size(YA, 3);
sidak    = 1 - (1 - 0.05)^(1/3);
for comp = 1:3
    name = ['comp' num2str(comp)];
    T = spm1d.stats.ttest_paired( YA(:,:,comp), YB(:,:,comp));
    Ti = T.inference(sidak, 'two_tailed', true);
    Ti_post.(name) = Ti;
    
    subplot(2,3,comp+3)
    Ti.plot;
    Ti.plot_p_values;
    ht = Ti.plot_threshold_label;
    yl = ylim;
    xlabel('% Stance')
    set(ht, 'Position', [ht.Position(1) yl(2) ht.Position(3)]);
    set(gcf,'Color','White')
    set(findall(gcf,'type','text'),'FontSize',14)
    set(findall(gcf,'type','text'),'BackgroundColor','White')
    set(findall(gcf,'type','axes'), 'FontSize',16, 'box','off');
    set(gca, 'LineWidth', axiswidth);
end
