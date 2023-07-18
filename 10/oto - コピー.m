close all;
clear;

for i = 1:1
    filename = sprintf('%d.xlsx', i);
    data = readmatrix(filename, 'Range', 'A24:G50000');

    % 時刻データの変換と経過時間の計算
    sampling_freq = 10000;  % サンプリング周波数 (Hz)
    time = (0:size(data, 1)-1)' / sampling_freq;  % 時間軸 (秒)
    AD_SSW = data(:, 3);
    SN_SSW = data(:, 6);

    % 周波数スペクトルの計算
    L_AD = length(AD_SSW);  % データ点の数
    Y_AD = fft(AD_SSW);  % フーリエ変換
    P2_AD = abs(Y_AD/L_AD);  % 2倍した振幅スペクトル
    P1_AD = P2_AD(1:L_AD/2+1);  % 片側のスペクトル
    P1_AD(2:end-1) = 2*P1_AD(2:end-1);  % 片側のスペクトルを2倍する

    % 周波数軸の作成
    f_AD = sampling_freq*(0:(L_AD/2))/L_AD;

    % 周波数スペクトルの計算
    L_SN = length(SN_SSW);  % データ点の数
    Y_SN = fft(SN_SSW);  % フーリエ変換
    P2_SN = abs(Y_SN/L_SN);  % 2倍した振幅スペクトル
    P1_SN = P2_SN(1:L_SN/2+1);  % 片側のスペクトル
    P1_SN(2:end-1) = 2*P1_SN(2:end-1);  % 片側のスペクトルを2倍する

    % 周波数軸の作成
    f_SN = sampling_freq*(0:(L_SN/2))/L_SN;



    % グラフの描画
    figure
    hold on
    plot(time, SN_SSW, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
    plot(time, AD_SSW, 'LineWidth', 0.5, 'Color', "blue");
    legend('SN\_SSW', 'AD\_SSW');
    xlabel('Time');
    ylabel('SSW');


    % グラフの描画

    figure
    hold on
    subplot(2,1,1);
    plot(f_SN, P1_SN, 'LineWidth', 0.5, 'Color', [1 0.5 0]);
    legend('SN\_LE');
    xlabel('Frequency [V]');
    ylabel('Amplitude [Hz]');

    subplot(2,1,2);
    plot(f_AD, P1_AD, 'LineWidth', 0.5, 'Color', "blue");
    legend('AD\_LE');
    xlabel('Frequency [V]');
    ylabel('Amplitude [Hz]');



end
%
% header = {'File', 'Max_AD_MMG', 'Max_SN_MMG','Max_AD_SSW','Max_SN_SSW','Max_AD_LE','Max_SN_LE'};
% result = [header; result];
% writecell(result, 'sinpuku.csv');
