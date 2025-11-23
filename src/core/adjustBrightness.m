function adjusted_img = adjustBrightness(img, brightnessValue)
    % ADJUSTBRIGHTNESS 调整图像明度（HSV空间的V通道）
    % 输入：
    %   img - 原始图像（RGB或灰度，uint8或double）
    %   brightnessValue - 明度参数 [0,1]
    %       0: 最暗（黑色）
    %       0.5: 原始明度
    %       1: 最亮
    % 输出：
    %   adjusted_img - 调整后的图像（与输入类型相同）
    
    % 记录输入类型
    inputClass = class(img);
    
    % 转换为uint8类型进行处理
    if isfloat(img)
        img = im2uint8(img);
    end
    
    % 如果是灰度图，直接调整亮度
    if size(img, 3) == 1
        img_double = im2double(img);
        if abs(brightnessValue - 0.5) < eps
            adjusted_img = img;
        elseif brightnessValue < 0.5
            % 变暗：线性缩放
            scale = 2 * brightnessValue;
            adjusted_img = im2uint8(img_double * scale);
        else
            % 变亮：线性拉伸
            scale = 2 * (brightnessValue - 0.5);
            adjusted_img = im2uint8(img_double + (1 - img_double) * scale);
        end
    else
        % RGB图像：转换到HSV空间调整V通道
        hsvImg = rgb2hsv(img);
        
        if abs(brightnessValue - 0.5) < eps
            % brightnessValue=0.5时保持原图
            adjusted_img = img;
        elseif brightnessValue < 0.5
            % 变暗：缩放V通道
            scale = 2 * brightnessValue;
            hsvImg(:,:,3) = hsvImg(:,:,3) * scale;
        else
            % 变亮：拉伸V通道
            scale = 2 * (brightnessValue - 0.5);
            hsvImg(:,:,3) = hsvImg(:,:,3) + (1 - hsvImg(:,:,3)) * scale;
        end
        
        % 确保V通道在[0,1]范围内
        hsvImg(:,:,3) = max(min(hsvImg(:,:,3), 1), 0);
        
        % 转回RGB
        adjusted_img = hsv2rgb(hsvImg);
        adjusted_img = im2uint8(adjusted_img);
    end
    
    % 转换回原始类型
    if strcmp(inputClass, 'double')
        adjusted_img = im2double(adjusted_img);
    end
end
