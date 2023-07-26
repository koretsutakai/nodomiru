close all;
clear;
result = cell(100, 8);
index = 1;
foldername = 'data';
pvdf_start_1 = 4.04;
pvdf_start_2 = 3.96;
pvdf_start_3 = 3.19;
pvdf_start_4 = 3.07;
pvdf_start_5 = 3.13;
window_size_v = 5;  % 平滑化の窓サイズ
window_size_a1 = 40;  % 平滑化の窓サイズ
window_size_a2 = 10;  % 追加の平滑化の窓サイズ
f1 = figure;
f2 = figure;
f3 = figure;
f4 = figure;
f5 = figure;
f6 = figure;



pvdf_start = [pvdf_start_1, pvdf_start_2, pvdf_start_3, pvdf_start_4, pvdf_start_5];

for i = 1:1

    filename = fullfile(foldername, ['l', num2str(i), '.xlsx']);
    PVDF_data = readmatrix(filename, 'Range', 'A2:G100000');

    % 時刻データの変換と経過時間の計算
    sampling_freq = 10000;  % サンプリング周波数 (Hz)
    time = (0:size(PVDF_data, 1)-1)' / sampling_freq;  % 時間軸 (秒)
    asset_time = time - pvdf_start(i);
    PVDF = PVDF_data(:, 4);
    SN_SSW = PVDF_data(:, 3);


    filename = fullfile(foldername, ['n', num2str(i), '.csv']);
    n_data = readmatrix(filename, 'Range', 'A3:AJ100000');
    for j = 1:16
        nodomiru = n_data(:, j);

        % Calculate displacement from the initial position
        nodomiru_displacement = nodomiru - nodomiru(1);

        % 時刻データの変換と経過時間の計算
        n_sampling_freq = 100;  % サンプリング周波数 (Hz)
        n_time = (0:size(n_data, 1)-1)' / n_sampling_freq;  % 時間軸 (秒)
        time_diff = diff(n_time);
        nodomiru_diff = diff(nodomiru_displacement);
        nodomiru_velocity = nodomiru_diff ./ time_diff;
        nodomiru_acceleration = diff(nodomiru_velocity) ./ time_diff(2:end);
        n_time_v = (0:size(n_data, 1)-2)' / n_sampling_freq;

        % データの平滑化
        nodomiru_velocity_smoothed = movmean(nodomiru_velocity, window_size_v);
        nodomiru_acceleration_smoothed1 = movmean(nodomiru_acceleration, window_size_a1);
        nodomiru_acceleration_smoothed2 = movmean(nodomiru_acceleration_smoothed1, window_size_a2);

        if j<=8
            figure(f1);
            subplot('Position', [0.1, 1-(j/9+0.02), 0.8, 1/9]);
            ax = gca;
            ax.YColor = 'black';
            yyaxis left
            plot(asset_time, PVDF, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
            max_value = max(abs(PVDF)) * 1.1;
            ylim(ax, [-max_value max_value]);
            yticks([]);
            yticklabels([]);
            ax.YColor = 'black';
            hold on
            yyaxis right
            plot(n_time, nodomiru_displacement, 'LineWidth', 1.5, 'Color', [0 0.5 1]);
            max_value = max(abs(nodomiru_displacement)) * 1.1;
            ylim(ax, [-max_value max_value]);
            ax.YColor = 'black';
            xlabel('time[s]');
            xlim(ax, [0 3]);
            yticks([]);
            yticklabels([]);
            text(-0.05, 0.5, sprintf('%d', j), 'Units', 'normalized', 'Color', 'k', 'FontSize', 10);

            figure(f2);
            subplot('Position', [0.1, 1-(j/9+0.02), 0.8, 1/9]);
            ax = gca;
            ax.YColor = 'black';
            yyaxis left
            plot(asset_time, PVDF, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
            max_value = max(abs(PVDF)) * 1.1;
            ylim(ax, [-max_value max_value]);
            yticks([]);
            yticklabels([]);
            ax.YColor = 'black';
            hold on
            yyaxis right
            plot(n_time_v,  nodomiru_velocity_smoothed, 'LineWidth', 1.5, 'Color', [0 0.5 1]);
            max_value = max(abs(nodomiru_velocity_smoothed)) * 1.1;
            ylim(ax, [-max_value max_value]);
            ax.YColor = 'black';
            xlabel('time[s]');
            xlim(ax, [0 3]);
            yticks([]);
            yticklabels([]);
            text(-0.05, 0.5, sprintf('%d', j), 'Units', 'normalized', 'Color', 'k', 'FontSize', 10);

            figure(f3);
            subplot('Position', [0.1, 1-(j/9+0.02), 0.8, 1/9]);
            ax = gca;
            ax.YColor = 'black';
            yyaxis left
            plot(asset_time, PVDF, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
            max_value = max(abs(PVDF)) * 1.1;
            ylim(ax, [-max_value max_value]);
            yticks([]);
            yticklabels([]);
            ax.YColor = 'black';
            hold on
            yyaxis right
            plot(n_time_v(1:end-1), nodomiru_acceleration_smoothed2, 'LineWidth', 1.5, 'Color', [0 0.5 1]);
            max_value = max(abs(nodomiru_acceleration_smoothed2)) * 1.1;
            ylim(ax, [-max_value max_value]);
            ax.YColor = 'black';
            xlabel('time[s]');
            xlim(ax, [0 3]);
            yticks([]);
            yticklabels([]);
            text(-0.05, 0.5, sprintf('%d', j), 'Units', 'normalized', 'Color', 'k', 'FontSize', 10);

            if j~=8
                figure(f1);
                xticklabels([]);
                yticklabels([]);
                figure(f2);
                xticklabels([]);
                yticklabels([]);
                figure(f3);
                xticklabels([]);
                yticklabels([]);
            end
        else
            figure(f4);
            subplot('Position', [0.1, 1-((j-8)/9+0.02), 0.8, 1/9]);
            ax = gca;
            ax.YColor = 'black';
            yyaxis left
            plot(asset_time, PVDF, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
            max_value = max(abs(PVDF)) * 1.1;
            ylim(ax, [-max_value max_value]);
            yticks([]);
            yticklabels([]);
            ax.YColor = 'black';
            hold on
            yyaxis right
            plot(n_time,  nodomiru_displacement, 'LineWidth', 1.5, 'Color', [0 0.5 1]);
            max_value = max(abs(nodomiru_displacement)) * 1.1;
            ylim(ax, [-max_value max_value]);
            ax.YColor = 'black';
            xlabel('time[s]');
            xlim(ax, [0 3]);
            yticks([]);
            yticklabels([]);
            text(-0.05, 0.5, sprintf('%d', j), 'Units', 'normalized', 'Color', 'k', 'FontSize', 10);


            figure(f5);
            subplot('Position', [0.1, 1-((j-8)/9+0.02), 0.8, 1/9]);
            ax = gca;
            ax.YColor = 'black';
            yyaxis left
            plot(asset_time, PVDF, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
            max_value = max(abs(PVDF)) * 1.1;
            ylim(ax, [-max_value max_value]);
            yticks([]);
            yticklabels([]);
            ax.YColor = 'black';
            hold on
            yyaxis right
            plot(n_time_v,  nodomiru_velocity_smoothed, 'LineWidth', 1.5, 'Color', [0 0.5 1]);
            max_value = max(abs(nodomiru_velocity_smoothed)) * 1.1;
            ylim(ax, [-max_value max_value]);
            ax.YColor = 'black';
            xlabel('time[s]');
            xlim(ax, [0 3]);
            yticks([]);
            yticklabels([]);
            text(-0.05, 0.5, sprintf('%d', j), 'Units', 'normalized', 'Color', 'k', 'FontSize', 10);

            figure(f6);
            subplot('Position', [0.1, 1-((j-8)/9+0.02), 0.8, 1/9]);
            ax = gca;
            ax.YColor = 'black';
            yyaxis left
            plot(asset_time, PVDF, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
            max_value = max(abs(PVDF)) * 1.1;
            ylim(ax, [-max_value max_value]);
            yticks([]);
            yticklabels([]);
            ax.YColor = 'black';
            hold on
            yyaxis right
            plot(n_time_v(1:end-1), nodomiru_acceleration_smoothed2, 'LineWidth', 1.5, 'Color', [0 0.5 1]);
            max_value = max(abs(nodomiru_acceleration_smoothed2)) * 1.1;
            ylim(ax, [-max_value max_value]);
            ax.YColor = 'black';
            xlabel('time[s]');
            xlim(ax, [0 3]);
            yticks([]);
            yticklabels([]);
            text(-0.05, 0.5, sprintf('%d', j), 'Units', 'normalized', 'Color', 'k', 'FontSize', 10);

            if j~=16
                figure(f4);
                xticklabels([]);
                yticklabels([]);
                figure(f5);
                xticklabels([]);
                yticklabels([]);
                figure(f6);
                xticklabels([]);
                yticklabels([]);


            end
        end
        index = index + 1;
    end
end
