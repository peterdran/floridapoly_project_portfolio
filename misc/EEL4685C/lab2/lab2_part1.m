%part 1

%sky is "blue" if 
% 69 <= r <= 98
% 91 <= g <= 120
% 141 <= b <= 169

%replace those pixels with rgb: 0,255,0

y = imread('f18.jpg');
%image(y); axis off;
len = size(y);

for i=[1:len(1)] %rows
    for j=[1:len(2)] %columns
        pix_temp = y(i,j,[1:3]);
        sky_blue = ((pix_temp(1) >= 69 && pix_temp(1) <= 98) && (pix_temp(2) >= 91 && pix_temp(2) <= 120) && (pix_temp(3) >= 141 && pix_temp(3) <= 169));
        if sky_blue
            y(i,j,1) = 0; %red
            y(i,j,2) = 255; %green
            y(i,j,3) = 0; %blue
        end
    end
end
figure
image(y); axis off;