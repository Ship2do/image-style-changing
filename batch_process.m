%% 批处理脚本 - 图像彩色铅笔素描效果
% 此脚本用于批量处理多张图像

clear; clc;

%% 添加路径
currentPath = fileparts(mfilename('fullpath'));
addpath(genpath(currentPath));

fprintf('=== 批量图像处理脚本 ===\n\n');

%% 配置参数
% 输入输出文件夹
inputFolder = fullfile(pwd, 'examples', 'input');
outputFolder = fullfile(pwd, 'examples', 'output');

% 处理参数
lineThreshold = 200;        % 线条阈值 (0-255)
saturationValue = 1.0;      % 颜色饱和度 (0.0-2.0)
brightnessValue = 0.5;      % 明度调整 (0-1, 0=最暗, 0.5=原始, 1=最亮)

% 支持的图像格式
supportedFormats = {'*.jpg', '*.jpeg', '*.png', '*.bmp'};

fprintf('配置:\n');
fprintf('  输入文件夹: %s\n', inputFolder);
fprintf('  输出文件夹: %s\n', outputFolder);
fprintf('  参数: 线条=%.0f, 饱和度=%.1f, 明度=%.1f\n\n', ...
        lineThreshold, saturationValue, brightnessValue);

%% 检查输入文件夹
if ~exist(inputFolder, 'dir')
    fprintf('警告: 输入文件夹不存在，将创建示例文件夹\n');
    mkdir(inputFolder);
    fprintf('请将要处理的图像放入: %s\n', inputFolder);
    return;
end

%% 创建输出文件夹
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
    fprintf('已创建输出文件夹: %s\n\n', outputFolder);
end

%% 获取所有图像文件
imageFiles = [];
for i = 1:length(supportedFormats)
    files = dir(fullfile(inputFolder, supportedFormats{i}));
    imageFiles = [imageFiles; files];
end

numFiles = length(imageFiles);

if numFiles == 0
    fprintf('错误: 未找到任何图像文件\n');
    fprintf('请确保以下文件夹中有图像: %s\n', inputFolder);
    return;
end

fprintf('找到 %d 个图像文件\n\n', numFiles);

%% 批量处理
successCount = 0;
failCount = 0;
totalTime = 0;

fprintf('开始批量处理...\n');
fprintf('----------------------------------------\n');

for i = 1:numFiles
    fileName = imageFiles(i).name;
    inputPath = fullfile(inputFolder, fileName);
    
    % 生成输出文件名
    [~, baseName, ext] = fileparts(fileName);
    outputFileName = sprintf('%s_sketch%s', baseName, ext);
    outputPath = fullfile(outputFolder, outputFileName);
    
    fprintf('[%d/%d] 处理: %s\n', i, numFiles, fileName);
    
    try
        % 加载图像
        img = loadImage(inputPath);
        
        % 应用素描效果
        tic;
        sketch = applyPencilSketch(img, lineThreshold, saturationValue, brightnessValue);
        processTime = toc;
        totalTime = totalTime + processTime;
        
        % 保存结果
        saveImage(sketch, outputPath);
        
        fprintf('  ✓ 完成 (%.2f秒) -> %s\n', processTime, outputFileName);
        successCount = successCount + 1;
        
    catch ME
        fprintf('  ✗ 失败: %s\n', ME.message);
        failCount = failCount + 1;
    end
end

%% 总结
fprintf('----------------------------------------\n');
fprintf('批处理完成！\n\n');
fprintf('统计:\n');
fprintf('  总文件数: %d\n', numFiles);
fprintf('  成功: %d\n', successCount);
fprintf('  失败: %d\n', failCount);
fprintf('  总耗时: %.2f秒\n', totalTime);
if successCount > 0
    fprintf('  平均处理时间: %.2f秒/张\n', totalTime/successCount);
end
fprintf('\n输出文件夹: %s\n', outputFolder);
