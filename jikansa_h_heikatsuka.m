close all;
clear;
raw_data = cell(100, 8);
result = cell(100, 8);
sampling_freq = 10000;  % サンプリング周波数 (Hz)
index = 1;

window_size_MMG = 600;  % Smoothing window size
window_size_BA = 1000;  % Smoothing window size
window_size_LE = 300;
coefficient_AD_MMG = 2;
coefficient_SN_MMG = 2;
coefficient_AD_BA = 2;
coefficient_SN_BA = 2;
coefficient_AD_LE = 2;
coefficient_SN_LE = 2;

for m = 1:1


    foldername = sprintf('%d', m);
    for i = 1:1
        filename = fullfile(foldername, sprintf('%d.xlsx', i));

        if m == 4
            data = readmatrix(filename, 'Range', 'A24:G130000');
            % 指定した秒数の範囲
            start_time = 0;  % 最初の秒数
            end_time = 12.99;  % 最後の秒数
            end_rest_time = 2.5;
        elseif m == 5
            data = readmatrix(filename, 'Range', 'A130000:G150000');
            % 指定した秒数の範囲
            start_time = 0;  % 最初の秒数
            end_time = 2.999;  % 最後の秒数
            end_rest_time = 0.5;
        else
            data = readmatrix(filename, 'Range', 'A24:G50000');
            % 指定した秒数の範囲
            start_time = 0;  % 最初の秒数
            end_time = 4.999;  % 最後の秒数
            end_rest_time = 2.5;
        end

        endi_RT_AD_MMG = round(end_rest_time * sampling_freq) + 1;
        endi_RT_SN_MMG = round(end_rest_time * sampling_freq) + 1;
        endi_RT_AD_BA = round(end_rest_time * sampling_freq) + 1;
        endi_RT_SN_BA = round(end_rest_time * sampling_freq) + 1;
        endi_RT_AD_LE = round(end_rest_time * sampling_freq) + 1;
        endi_RT_SN_LE = round(end_rest_time * sampling_freq) + 1;

        % 時刻データの変換と経過時間の計算

        time = (0:size(data, 1)-1)' / sampling_freq;  % 時間軸 (秒)
        AD_MMG = data(:, 2);
        SN_MMG = data(:, 5);
        AD_BA = data(:, 3);
        SN_BA = data(:, 6);
        AD_LE = data(:, 4);
        SN_LE = data(:, 7);
        AD_MMG_envelope = envelope(AD_MMG);
        SN_MMG_envelope = envelope(SN_MMG);
        AD_BA_envelope = envelope(AD_BA,150,'peak');
        SN_BA_envelope = envelope(SN_BA,150,'peak');
        AD_LE_envelope = envelope(AD_LE);
        SN_LE_envelope = envelope(SN_LE);

        % データの平滑化
        AD_MMG_smoothed = movmean(AD_MMG_envelope, window_size_MMG);
        SN_MMG_smoothed = movmean(SN_MMG_envelope, window_size_MMG);
        AD_BA_smoothed = movmean(AD_BA_envelope, window_size_BA);
        SN_BA_smoothed = movmean(SN_BA_envelope, window_size_BA);
        AD_LE_smoothed = movmean(AD_LE_envelope, window_size_LE);
        SN_LE_smoothed = movmean(SN_LE_envelope, window_size_LE);

        raw_data{index, 1} = m;
        raw_data{index, 2} = i;
        raw_data{index, 3} = AD_MMG;
        raw_data{index, 4} = SN_MMG;
        raw_data{index, 5} = AD_BA;
        raw_data{index, 6} = SN_BA;
        raw_data{index, 7} = AD_LE;
        raw_data{index, 8} = SN_LE;

        enveloped_data = raw_data;
        enveloped_data(: ,3:8) = envelope(enveloped_data(: ,3:8));




        RT_data_AD_MMG = AD_MMG_smoothed(1:endi_RT_AD_MMG);
        mean_RT_AD_MMG = mean (RT_data_AD_MMG);
        std_RT_AD_MMG = std (RT_data_AD_MMG);
        border_AD_MMG = mean_RT_AD_MMG + std_RT_AD_MMG * coefficient_AD_MMG ;

        RT_data_SN_MMG = SN_MMG_smoothed(1:endi_RT_SN_MMG);
        mean_RT_SN_MMG = mean (RT_data_SN_MMG);
        std_RT_SN_MMG = std (RT_data_SN_MMG);
        border_SN_MMG = mean_RT_SN_MMG + std_RT_SN_MMG * coefficient_SN_MMG ;

        RT_data_AD_BA = AD_BA_smoothed(1:endi_RT_AD_BA);
        mean_RT_AD_BA = mean (RT_data_AD_BA);
        std_RT_AD_BA = std (RT_data_AD_BA);
        border_AD_BA = mean_RT_AD_BA + std_RT_AD_BA * coefficient_AD_BA ;

        RT_data_SN_BA = SN_BA_smoothed(1:endi_RT_SN_BA);
        mean_RT_SN_BA = mean (RT_data_SN_BA);
        std_RT_SN_BA = std (RT_data_SN_BA);
        border_SN_BA = mean_RT_SN_BA + std_RT_SN_BA * coefficient_SN_BA ;

        RT_data_AD_LE = AD_LE_smoothed(1:endi_RT_AD_LE);
        mean_RT_AD_LE = mean (RT_data_AD_LE);
        std_RT_AD_LE = std (RT_data_AD_LE);
        border_AD_LE = mean_RT_AD_LE + std_RT_AD_LE * coefficient_AD_LE ;

        RT_data_SN_LE = SN_LE_smoothed(1:endi_RT_SN_LE);
        mean_RT_SN_LE = mean (RT_data_SN_LE);
        std_RT_SN_LE = std (RT_data_SN_LE);
        border_SN_LE = mean_RT_SN_LE + std_RT_SN_LE * coefficient_SN_LE ;



        if m == 4
            border_AD_MMG_ = border_AD_MMG;
            border_SN_MMG_5 = border_SN_MMG;
            border_AD_BA_5 = border_AD_BA;
            border_SN_BA_5 = border_SN_BA;
            border_AD_LE_5 = border_AD_LE;
            border_SN_LE_5 = border_SN_LE;
        end

        if m ==5
            border_AD_MMG = border_AD_MMG_5;
            border_SN_MMG = border_SN_MMG_5;
            border_AD_BA = border_AD_BA_5;
            border_SN_BA = border_SN_BA_5;
            border_AD_LE = border_AD_LE_5;
            border_SN_LE = border_SN_LE_5;
        end

        % 閾値を連続して超える区間を取得
        AD_MMG_over_threshold = AD_MMG_smoothed > border_AD_MMG;
        SN_MMG_over_threshold = SN_MMG_smoothed > border_SN_MMG;

        AD_BA_over_threshold = AD_BA_smoothed > border_AD_BA;
        SN_BA_over_threshold = SN_BA_smoothed > border_SN_BA;

        AD_LE_over_threshold =  AD_LE_smoothed > border_AD_LE;
        SN_LE_over_threshold = SN_LE_smoothed > border_SN_LE;

        % 閾値を連続して超える区間の開始時間と終了時間を計算
        start_times_AD_MMG = find(diff([0; AD_MMG_over_threshold]) == 1) / sampling_freq + start_time;
        end_times_AD_MMG = find(diff([AD_MMG_over_threshold; 0]) == -1) / sampling_freq + start_time;
        start_times_SN_MMG = find(diff([0; SN_MMG_over_threshold]) == 1) / sampling_freq + start_time;
        end_times_SN_MMG = find(diff([SN_MMG_over_threshold; 0]) == -1) / sampling_freq + start_time;

        start_times_AD_BA = find(diff([0; AD_BA_over_threshold]) == 1) / sampling_freq + start_time;
        end_times_AD_BA = find(diff([AD_BA_over_threshold; 0]) == -1) / sampling_freq + start_time;
        start_times_SN_BA = find(diff([0; SN_BA_over_threshold]) == 1) / sampling_freq + start_time;
        end_times_SN_BA = find(diff([SN_BA_over_threshold; 0]) == -1) / sampling_freq + start_time;

        start_times_AD_LE = find(diff([0; AD_LE_over_threshold]) == 1) / sampling_freq + start_time;
        end_times_AD_LE = find(diff([AD_LE_over_threshold; 0]) == -1) / sampling_freq + start_time;
        start_times_SN_LE = find(diff([0; SN_LE_over_threshold]) == 1) / sampling_freq + start_time;
        end_times_SN_LE = find(diff([SN_LE_over_threshold; 0]) == -1) / sampling_freq + start_time;

        % 閾値を超える区間の数を計算
        num_intervals_AD_MMG = numel(start_times_AD_MMG);
        num_intervals_SN_MMG = numel(start_times_SN_MMG);
        num_intervals_AD_BA = numel(start_times_AD_BA);
        num_intervals_SN_BA = numel(start_times_SN_BA);
        num_intervals_AD_LE = numel(start_times_AD_LE);
        num_intervals_SN_LE = numel(start_times_SN_LE);

        acctive_AD_MMG = end_times_AD_MMG-start_times_AD_MMG;
        max_acctive_AD_MMG = max(acctive_AD_MMG);
        acctive_SN_MMG = end_times_SN_MMG-start_times_SN_MMG;
        max_acctive_SN_MMG = max(acctive_SN_MMG);
        acctive_AD_BA = end_times_AD_BA-start_times_AD_BA;
        max_acctive_AD_BA = max(acctive_AD_BA);
        acctive_SN_BA = end_times_SN_BA-start_times_SN_BA;
        max_acctive_SN_BA = max(acctive_SN_BA);
        acctive_AD_LE = end_times_AD_LE-start_times_AD_LE;
        max_acctive_AD_LE = max(acctive_AD_LE);
        acctive_SN_LE = end_times_SN_LE-start_times_SN_LE;
        max_acctive_SN_LE = max(acctive_SN_LE);

        result{index, 1} = m;
        result{index, 2} = i;
        result{index, 3} = max_acctive_AD_MMG;
        result{index, 4} = max_acctive_SN_MMG;
        result{index, 5} = max_acctive_AD_BA;
        result{index, 6} = max_acctive_SN_BA;
        result{index, 7} = max_acctive_AD_LE;
        result{index, 8} = max_acctive_SN_LE;

        % グラフの描画処理
        figure
        subplot(3,1,1);
        title(m)
        plot(time, SN_MMG_envelope,'LineWidth', 1.0, 'Color',  [1 0.5 0]);
        hold on
        plot(time, AD_MMG_envelope, 'LineWidth', 1.0, 'Color', [0 0 1]);
        plot(time, SN_MMG_smoothed,'LineWidth', 2.0, 'Color',  [1 0.5 0]);
        plot(time, AD_MMG_smoothed, 'LineWidth', 2.0, 'Color', [0 0 1]);
        yline(border_SN_MMG,"magenta");
        yline(border_AD_MMG,"cyan");
        xlabel('Time');
        ylabel('MMG');


        subplot(3,1,2);
        title(m)
        hold on
        plot(time, SN_BA_envelope,'LineWidth', 1.0, 'Color',  [1 0.5 0]);
        hold on
        plot(time, AD_BA_envelope, 'LineWidth', 1.0, 'Color', [0 0 1]);
        plot(time, SN_BA_smoothed,'LineWidth', 2.0, 'Color',  [1 0.5 0]);
        plot(time, AD_BA_smoothed, 'LineWidth', 2.0, 'Color', [0 0 1]);
        yline(border_SN_BA,"magenta");
        yline(border_AD_BA,"cyan");
        xlabel('Time');
        ylabel('BA');

        subplot(3,1,3);
        title(m)
        plot(time, SN_LE_envelope,'LineWidth', 1.0, 'Color',  [1 0.5 0]);
        hold on
        plot(time, AD_LE_envelope, 'LineWidth', 1.0, 'Color', [0 0 1]);
        plot(time, SN_LE_smoothed,'LineWidth', 2.0, 'Color',  [1 0.5 0]);
        plot(time, AD_LE_smoothed, 'LineWidth', 2.0, 'Color', [0 0 1]);
        yline(border_SN_LE,"magenta");
        yline(border_AD_LE,"cyan");
        xlabel('Time');
        ylabel('LE');

        figure;

        subplot('Position', [0.1, 6/7-0.04, 0.8, 1/7]);
        title(m)
        hold on;
        for k = 1:length(start_times_AD_MMG)
            patch([start_times_AD_MMG(k), end_times_AD_MMG(k), end_times_AD_MMG(k), start_times_AD_MMG(k)], [0, 0, 1, 1], [0.3 0.3 0.7], 'EdgeColor', 'none');
        end
        ylim([0, 1]);
        xlim([start_time, end_time]);
        ylabel('AD\_MMG');
        yticks([]);
        xticks([]);
        xticklabels([]);

        subplot('Position', [0.1, 5/7-0.04, 0.8, 1/7]);
        hold on;
        for k = 1:length(start_times_SN_MMG)
            patch([start_times_SN_MMG(k), end_times_SN_MMG(k), end_times_SN_MMG(k), start_times_SN_MMG(k)], [0, 0, 1, 1], [0.8 0.4 0.2], 'EdgeColor', 'none');
        end
        ylim([0, 1]);
        xlim([start_time, end_time]);
        ylabel('SN\_MMG');
        yticks([]);
        yticklabels([]);
        xticks([]);
        xticklabels([]);

        subplot('Position', [0.1, 4/7-0.04, 0.8, 1/7]);
        hold on;
        for k = 1:length(start_times_AD_BA)
            patch([start_times_AD_BA(k), end_times_AD_BA(k), end_times_AD_BA(k), start_times_AD_BA(k)], [0, 0, 1, 1], [0.3 0.3 0.7], 'EdgeColor', 'none');
        end
        ylim([0, 1]);
        xlim([start_time, end_time]);
        ylabel('AD\_BA');
        yticks([]);
        yticklabels([]);
        xticks([]);
        xticklabels([]);

        subplot('Position', [0.1, 3/7-0.04, 0.8, 1/7]);
        hold on;
        for k = 1:length(start_times_SN_BA)
            patch([start_times_SN_BA(k), end_times_SN_BA(k), end_times_SN_BA(k), start_times_SN_BA(k)], [0, 0, 1, 1], [0.8 0.4 0.2], 'EdgeColor', 'none');
        end
        ylim([0, 1]);
        xlim([start_time, end_time]);
        ylabel('SN\_BA');
        yticks([]);
        yticklabels([]);
        xticks([]);
        xticklabels([]);

        subplot('Position', [0.1, 2/7-0.04, 0.8, 1/7]);
        hold on;
        for k = 1:length(start_times_AD_LE)
            patch([start_times_AD_LE(k), end_times_AD_LE(k), end_times_AD_LE(k), start_times_AD_LE(k)], [0, 0, 1, 1], [0.3 0.3 0.7], 'EdgeColor', 'none');
        end
        ylim([0, 1]);
        xlim([start_time, end_time]);
        ylabel('AD\_LE');
        yticks([]);
        yticklabels([]);
        xticks([]);
        xticklabels([]);

        subplot('Position', [0.1, 1/7-0.04, 0.8, 1/7]);
        hold on;
        for k = 1:length(start_times_SN_LE)
            patch([start_times_SN_LE(k), end_times_SN_LE(k), end_times_SN_LE(k), start_times_SN_LE(k)], [0, 0, 1, 1], [0.8 0.4 0.2], 'EdgeColor', 'none');
        end
        ylim([0, 1]);
        xlim([start_time, end_time]);
        ylabel('SN\_LE');
        yticks([]);
        yticklabels([]);
        xticks('auto');
        xticklabels('auto');
        xlabel('Time');
        index = index + 1;

    end
end

header = {'folder', 'File', 'max_acctive_AD_MMG', 'max_acctive_SN_MMG' 'max_acctive_AD_BA' 'max_acctive_SN_BA' 'max_acctive_AD_LE' 'max_acctive_SN_LE'};
headerResult = [header; result];
writecell(headerResult, 'AcctiveTime_RT_0725.csv');