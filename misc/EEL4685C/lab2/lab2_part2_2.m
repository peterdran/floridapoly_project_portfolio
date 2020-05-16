%part 2.2
%using nested loops
%increase red columnwise left to right
%increase green rowwise top to bottom
%decrease blue columnwise left to right

y = uint8(zeros(250,250,3)); %black image
for i=[1:250] %rows
    for j=[1:250] %columns
        y(i,j,1) = j; %red
        y(i,j,2) = i; %green
        y(i,j,3) = 250 - j; %blue
    end
end

image(y); axis square; axis off;