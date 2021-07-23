function [cutPlate] = Cut_Plate(Image) 
    % call createMask function to get the mask and the filtered image
    [maskedRGBImage,BW] = Find_Yellow(Image);

    [row,col] = size(BW);
    [minRow,minCol] = find(BW,1,'first');
    [maxRow,maxCol] = find(BW,1,'last');
    
    for i = 1:row
        for j = 1:col
            if(BW(i,j) ~= 0)
                if(i < minRow)
                    minRow = i;
                elseif(i > maxRow)
                    maxRow = i;
                end
                if(j < minCol)
                    minCol = j;
                elseif(j > maxCol)
                    maxCol = j;
                end
            end
        end
    end
    
    width = abs(maxCol - minCol);
    height = abs(maxRow - minRow);
    cutPlate = imcrop(Image,[min(minCol,maxCol) min(minRow,maxRow) width height]);
    cutPlate = imresize(cutPlate,[40 160]);
end
