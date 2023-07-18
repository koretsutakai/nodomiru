close all;
clear;

for i = 1:5
    filename = sprintf('%d.xlsx', i);
    data = readmatrix(filename, 'Range', 'A130000:G150000');

    % 指定した秒数の範囲
    start_time = 0;  % 最初の秒数
    end_time = 1.9;  % 最後の秒数

    % 時刻データの変換と経過時間の計算
    sampling_freq = 10000;  % サンプリング周波数 (Hz)
    time = (0:size(data, 1)-1)' / sampling_freq;  % 時間軸 (秒)
    AD_MMG = data(:, 2);
    SN_MMG = data(:, 5);
    AD_SSW = data(:, 3);
    SN_SSW = data(:, 6);
    AD_LE = data(:, 4);
    SN_LE = data(:, 7);

    % 指定した範囲内のデータインデックスを取得
    start_index = find(time >= start_time, 1);
    end_index = find(time >= end_time, 1);

    % 指定した範囲のAD_MMGとSN_MMGの絶対値の最大値を取得
    max_AD_MMG = max(abs(AD_MMG(start_index:end_index)));
    max_SN_MMG = max(abs(SN_MMG(start_index:end_index)));


    % 指定した範囲のAD_MMGとSN_MMGの絶対値の最大値を取得
    max_AD_SSW = max(abs(AD_SSW(start_index:end_index)));
    max_SN_SSW = max(abs(SN_SSW(start_index:end_index)));


    % 指定した範囲のAD_MMGとSN_MMGの絶対値の最大値を取得
    max_AD_LE = max(abs(AD_LE(start_index:end_index)));
    max_SN_LE = max(abs(SN_LE(start_index:end_index)));

    figure
    hold on
    plot(time, SN_MMG, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
    plot(time, AD_MMG, 'LineWidth', 0.5, 'Color', "blue");
    legend('SN\_MMG', 'AD\_MMG');
    xlabel('Time');
    ylabel('MMG');

    figure
    hold on
    plot(time, SN_SSW, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
    plot(time, AD_SSW, 'LineWidth', 0.5, 'Color', "blue");
    legend('SN\_SSW', 'AD\_SSW');
    xlabel('Time');
    ylabel('SSW');

    figure
    hold on
    plot(time, SN_LE, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
    plot(time, AD_LE, 'LineWidth', 0.5, 'Color', "blue");
    legend('SN\_LE', 'AD\_LE');
    xlabel('Time');
    ylabel('LE');


    result{i, 1} = filename;
    result{i, 2} = max_AD_MMG;
    result{i, 3} = max_SN_MMG;
    result{i, 4} = max_AD_SSW;
    result{i, 5} = max_SN_SSW;
    result{i, 6} = max_AD_LE;
    result{i, 7} = max_SN_LE;

end

header = {'File', 'Max_AD_MMG', 'Max_SN_MMG','Max_AD_SSW','Max_SN_SSW','Max_AD_LE','Max_SN_LE'};
result = [header; result];
writecell(result, 'sinpuku.csv');