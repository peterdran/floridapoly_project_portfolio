% Author:  Prof. Foster
% Date: 1/23/2018
% Input: hard-coded dimension “dim” in pixels, same for height and width
%	x and y location of the center of a spherish circle, “redx” and “redy”, in pixels
%	radius of the red sphere in pixels, “redr”	
% Output: Figure window with the red sphere
% Purpose:  Creates a picture of size “dim” by “dim” and creates a red sphere at 
% position (redx,redy) with radius “redr”. The red channel of each pixel’s color is 
% scaled by the square of the distance from the center for a 3D effect, with pixels 
% outside the sphere set to black.
% Notes: Minimal error checking implemented

clear  % good habit to wipe out old varaibles from the workspace

dim = 800;      % height and width of image in pixels
redx = 400;     % x position of red circle's center in pixels
redy = 400;    % y position of red circle's center in pixels
redr = 300;    % radius of red circle in pixels

% each color channel ranges from 0-255. Use constants below to affect
% circle's appearance
REDMAX = 255;   %  choose from REDMIN < REDMAX <=255 
REDMIN = 0;         % choose from 0 <= REDMIN < REDMAX
REDRANGE = REDMAX-REDMIN+1;  % Don't change this

pic = uint8(zeros(dim,dim,3));          % create a new blank image, setting all pixels to black
tic;

for x = 1:1:size(pic,2)    % for every row in the image...  Note, could use "dim", but this demos size()
    for y = 1:1:size(pic,1)    % for every pixel in a row...
        dist_from_red =sqrt((redx-x)^2 + (redy-y)^2);
        if dist_from_red < redr                                                                 % point lies within circle
            normalized_red = (redr^2 - dist_from_red^2)/redr^2;  % using square gives 3D-ish look
            %...  and normalized means that red content is within range of 0.0 to 1.0....so next
            scaled_red = normalized_red*REDRANGE+REDMIN;   % scale to desired range of red 
            pic(y,x,1) = uint8(scaled_red);  % pay attention to the order!!!  
        end
    end
end
toc
image(pic)
axis square