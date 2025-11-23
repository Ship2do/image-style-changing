function saveImage(img, filepath, quality)
    % SAVEIMAGE 保存图像文件
    % 输入参数:
    %   img - 要保存的图像
    %   filepath - 保存路径
    %   quality - JPEG质量 (可选, 默认95)
    
    if nargin < 3
        quality = 95;
    end
    
    try
        % 确保图像在有效范围内
        if isfloat(img)
            img = im2uint8(img);
        end
        
        % 获取文件扩展名
        [~, ~, ext] = fileparts(filepath);
        
        % 根据文件类型保存
        if strcmpi(ext, '.jpg') || strcmpi(ext, '.jpeg')
            imwrite(img, filepath, 'Quality', quality);
        else
            imwrite(img, filepath);
        end
        
        fprintf('Image saved successfully: %s\n', filepath);
        
    catch ME
        error('Failed to save image: %s\nError: %s', filepath, ME.message);
    end
end