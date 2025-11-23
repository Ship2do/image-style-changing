function img = loadImage(filepath)
    % LOADIMAGE 加载图像文件
    % 输入参数:
    %   filepath - 图像文件路径
    % 输出:
    %   img - 加载的图像
    
    try
        % 检查文件是否存在
        if ~exist(filepath, 'file')
            error('File does not exist: %s', filepath);
        end
        
        % 读取图像
        img = imread(filepath);
        
        % 如果图像太大，调整大小以提高处理速度
        maxSize = 4096;
        [rows, cols, ~] = size(img);
        
        if max(rows, cols) > maxSize
            scale = maxSize / max(rows, cols);
            img = imresize(img, scale);
            fprintf('Image resized to %dx%d for better performance\n', ...
                size(img, 1), size(img, 2));
        end
        
    catch ME
        error('Failed to load image: %s\nError: %s', filepath, ME.message);
    end
end