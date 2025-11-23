function sketchImage = applyPencilSketch(img, lineThreshold, saturationValue, brightnessValue)
    % APPLYPENCILSKETCH 应用彩色铅笔素描效果（基于向量梯度方法）
    % 输入参数:
    %   img - 原始彩色图像
    %   lineThreshold - 线条阈值 (0-255，默认200) 值越大线条越多
    %   saturationValue - 颜色饱和度 (0.0-2.0，默认1.0) 值越大颜色越鲜艳
    %   brightnessValue - 明度调整 (0-1，默认0.5) 0=最暗，0.5=原始，1=最亮
    % 输出:
    %   sketchImage - 处理后的素描图像（double类型，0-1范围）
    
    % 验证输入参数
    if nargin < 4
        brightnessValue = 0.5;
    end
    if nargin < 3
        saturationValue = 1.0;
    end
    if nargin < 2
        lineThreshold = 200;
    end
    
    % 转换为uint8类型
    if isfloat(img)
        img = im2uint8(img);
    end
    
    % 如果是灰度图，转换为RGB
    if size(img, 3) == 1
        img = repmat(img, [1, 1, 3]);
    end
    
    %% 步骤1: 明度调整
    img = adjustBrightness(img, brightnessValue);
    
    %% 步骤2: 饱和度调整
    img = adjustSaturation(img, saturationValue);
    
    %% 步骤3: 线条提取
    sketchImage = extractLines(img, lineThreshold);
end