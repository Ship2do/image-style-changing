function adjusted_img = adjustSaturation(img, saturationValue)
    % ADJUSTSATURATION 调整图像颜色饱和度
    % 输入：
    %   img - 原始RGB图像（uint8或double）
    %   saturationValue - 饱和度倍数 (0.0-2.0)
    %       0: 完全去饱和（灰度图）
    %       1.0: 保持原始饱和度
    %       >1.0: 增强饱和度
    % 输出：
    %   adjusted_img - 调整后的图像（与输入类型相同）
    
    % 记录输入类型
    inputClass = class(img);
    
    % 转换为uint8类型进行处理
    if isfloat(img)
        img = im2uint8(img);
    end
    
    % 如果是灰度图，直接返回
    if size(img, 3) == 1
        adjusted_img = img;
        if strcmp(inputClass, 'double')
            adjusted_img = im2double(adjusted_img);
        end
        return;
    end
    
    % 转换到HSV空间
    hsvImg = rgb2hsv(img);
    
    % 调整饱和度通道
    hsvImg(:,:,2) = hsvImg(:,:,2) * saturationValue;
    
    % 确保饱和度不超过1
    hsvImg(:,:,2) = min(hsvImg(:,:,2), 1);
    
    % 转回RGB
    adjusted_img = hsv2rgb(hsvImg);
    adjusted_img = im2uint8(adjusted_img);
    
    % 转换回原始类型
    if strcmp(inputClass, 'double')
        adjusted_img = im2double(adjusted_img);
    end
end
