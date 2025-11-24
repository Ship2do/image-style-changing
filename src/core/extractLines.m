function sketchImage = extractLines(img, lineThreshold)
    % EXTRACTLINES 使用向量梯度方法提取图像线条
    % 输入：
    %   img - 原始RGB图像（uint8或double）
    %   lineThreshold - 线条阈值 (0-255)
    %       值越大，线条越多；值越小，线条越少
    % 输出：
    %   sketchImage - 线条图像（double类型，0-1范围）
    
    % 转换为uint8类型
    if isfloat(img)
        img = im2uint8(img);
    end
    
    % 如果是灰度图，转换为RGB
    if size(img, 3) == 1
        img = repmat(img, [1, 1, 3]);
    end
    
    %% 计算每个颜色通道的向量梯度
    % 对R、G、B三个通道分别计算
    R = colorGradient(double(img(:,:,1)));
    G = colorGradient(double(img(:,:,2)));
    B = colorGradient(double(img(:,:,3)));
    
    % 转换为8位无符号整数
    uR = im2uint8(R);
    uG = im2uint8(G);
    uB = im2uint8(B);

    %% 反转颜色梯度（白底黑线）
    fR = 255 - uR;
    fG = 255 - uG;
    fB = 255 - uB;

    %% 阈值处理
    % 获取图像大小
    [M, N] = size(fR);

    % 限制阈值在合理范围
    T = max(0, min(255, lineThreshold));
    
    % 向量化处理
    % 像素值低于阈值的变为0（白色背景）
    % 高于阈值的映射到[0, 235]范围（模拟真实铅笔效果）
    maxPencilValue = 235;
    
    % R通道
    f1_R = zeros(M, N);
    mask_R = fR >= T;
    if T < 255
        f1_R(mask_R) = maxPencilValue/(255-T) * (double(fR(mask_R)) - T);
    end
    
    % G通道
    f1_G = zeros(M, N);
    mask_G = fG >= T;
    if T < 255
        f1_G(mask_G) = maxPencilValue/(255-T) * (double(fG(mask_G)) - T);
    end
    
    % B通道
    f1_B = zeros(M, N);
    mask_B = fB >= T;
    if T < 255
        f1_B(mask_B) = maxPencilValue/(255-T) * (double(fB(mask_B)) - T);
    end
    
    %% 合并三个颜色通道
    f1_R = uint8(f1_R);
    f1_G = uint8(f1_G);
    f1_B = uint8(f1_B);
    sketchImage = cat(3, f1_R, f1_G, f1_B);
    
    % 转换为double类型输出（0-1范围）
    sketchImage = im2double(sketchImage);
end


function PPG = colorGradient(f)
    % COLORGRADIENTSINGLE 计算单个颜色通道的向量梯度
    % 输入:
    %   f - 单个颜色通道（double类型）
    % 输出:
    %   PPG - 每通道梯度
    
    % 使用Sobel算子计算x和y方向的导数
    sh = fspecial('sobel');
    sv = sh';
    Fx = imfilter(double(f), sh, 'replicate');
    Fy = imfilter(double(f), sv, 'replicate');
    
    % 计算每通道梯度
    FG = sqrt(Fx.^2 + Fy.^2);
    PPG = mat2gray(FG);
end
