%% 主程序 - 图像彩色铅笔素描效果
% 此脚本用于精细化逐张调整效果

clear; clc;

% 添加必要的路径
currentPath = fileparts(mfilename('fullpath'));
addpath(genpath(currentPath));

% 创建并显示图形用户界面
hFig = PencilSketchGUI();
movegui(hFig, 'center');

fprintf('图像彩色铅笔素描效果程序已启动\n');
fprintf('版本: 1.3\n');
fprintf('使用说明:\n');
fprintf('1. 点击"上传图像"按钮选择要处理的图片\n');
fprintf('2. 调整参数滑块以改变效果\n');
fprintf('3. 点击"应用效果"查看结果\n');
fprintf('4. 点击"保存图像"保存处理后的图片\n\n');
