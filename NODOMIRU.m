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

    % 時刻データの変換と経過時間の計算
    n_sampling_freq = 100;  % サンプリング周波数 (Hz)
    n_time = (0:size(n_data, 1)-1)' / n_sampling_freq;  % 時間軸 (秒)
    nodomiru = n_data(:, 36);
    time_diff = diff(n_time);
    nodomiru_diff = diff(nodomiru);
    nodomiru_velocity = nodomiru_diff ./ time_diff;
    nodomiru_acceleration = diff(nodomiru_velocity) ./ time_diff(2:end);
    n_time_v = (0:size(n_data, 1)-2)' / n_sampling_freq;

    % データの平滑化

    nodomiru_velocity_smoothed = movmean(nodomiru_velocity, window_size_v);
    nodomiru_acceleration_smoothed1 = movmean(nodomiru_acceleration, window_size_a1);
    nodomiru_acceleration_smoothed2 = movmean(nodomiru_acceleration_smoothed1, window_size_a2);

    figure
    subplot(3,1,1);
    title(i);
    ax = gca;
    ax.YColor = 'black';
    yyaxis left
    plot(asset_time, PVDF, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
    ylim(ax, [-2 2]);
    ylabel('PVDF[V]');
    ax.YColor = 'black';
    hold on
    yyaxis right
    plot(n_time, nodomiru, 'LineWidth', 0.5, 'Color', [0 0.5 1]);
    ylim(ax, [-30 30]);
    ylabel('nodomiru[mm]');
    ax.YColor = 'black';
    legend('PVDF','nodomiru');
    xlabel('time[s]');
    xlim(ax, [0 5]);

    subplot(3,1,2);
    title(i);
    ax = gca;
    ax.YColor = 'black';
    yyaxis left
    plot(asset_time, PVDF, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
    ylim(ax, [-2 2]);
    ylabel('PVDF[V]');
    ax.YColor = 'black';
    hold on
    yyaxis right
    plot(n_time_v, nodomiru_velocity_smoothed, 'LineWidth', 0.5, 'Color', [0 0.5 1]);
    ylim(ax, [-200 200]);
    ylabel('nodomiru[mm/s]');
    ax.YColor = 'black';
    legend('PVDF','nodomiru');
    xlabel('time[s]');
    xlim(ax, [0 5]);

    subplot(3,1,3);
    title(i);
    ax = gca;
    ax.YColor = 'black';
    yyaxis left
    plot(asset_time, PVDF, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
    ylim(ax, [-2 2]);
    ylabel('PVDF[V]');
    ax.YColor = 'black';
    hold on
    yyaxis right
    plot(n_time_v(1:end-1), nodomiru_acceleration_smoothed2, 'LineWidth', 0.5, 'Color', [0 0.5 1]);
    ylim(ax, [-1000 1000]);
    ylabel('nodomiru[mm/s^2]');
    ax.YColor = 'black';
    legend('PVDF','nodomiru');
    xlabel('time[s]');
    xlim(ax, [0 5]);

    index = index + 1;
end
