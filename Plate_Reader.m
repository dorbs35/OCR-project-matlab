function [finalOutput] = Plate_Reader(cutPlate)
    finalOutput = [];    
    plate = rgb2gray(cutPlate);
    threshold = graythresh(plate);
    pic = ~im2bw(plate,threshold);

    % Remove all object containing fewer than 50 pixels
    pic = bwareaopen(pic,50);
    [Label CountOfLabel] = bwlabel(pic);
    pic = ~pic;

    folder = '.\templateOfNumbers';
    filePattern = fullfile(folder, '*.jpg');
    folderDir = dir(filePattern);
    images = {folderDir.name};

    for i = 1 : numel(images)
      fullFileName = fullfile(folder, images{i});
      Inums{i} = imread(fullFileName);
      Inums{i} = rgb2gray(Inums{i});
      Inums{i} = imresize(Inums{i},[40,160]); 
    end

    for i = 1:CountOfLabel
        [row,col] = find(Label == i); 
        
        % picture command crops nth object from L
        number = pic(min(row):max(row),min(col):max(col)); 
        
        [rowNumber,colNumber] = size(number);
        if(colNumber < 30)
            number = imresize(number,[40,160]);       
            corArray = [ ];

            for j = 1:numel(images)
                cor = corr2(Inums{j},number);
                corArray = [corArray cor];
            end

            peak = find(corArray == max(corArray));

            if peak > 0.3
                finalOutput = [finalOutput Inums{peak}];
            end
        end
    end
    finalOutput = imresize(finalOutput,[100,800]);
end