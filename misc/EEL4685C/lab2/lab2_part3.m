%part 3
clear  % good habit to wipe out old varaibles from the workspace

dim = 800;      % height and width of image in pixels
redx = 400;     % x pixpos of red circle's center
redy = 400;    % y pixpos of red circle's center
redr = 300;    % radius of red circle in pixels

% each color channel ranges from 0-255. 
% Use constants below to affect circle's appearance
REDMAX = 255;   %  choose from REDMIN < REDMAX <=255 
REDMIN = 0;         % choose from 0 <= REDMIN < REDMAX
REDRANGE = REDMAX-REDMIN+1;  % Don't change this

pic = uint8(zeros(dim,dim,3)); % black image gen
%tic;

for x = 1:1:size(pic,2)    % for every row in the image...  Note, could use "dim", but this demos size()
    for y = 1:1:size(pic,1)    % for every pixel in a row...
        dist_from_red =sqrt((redx-x)^2 + (redy-y)^2);
        if dist_from_red < redr %point lies within circle
            normalized_red = (redr^2 - dist_from_red^2)/redr^2;
            scaled_red = normalized_red*REDRANGE+REDMIN;   % scale to desired range of red 
            pic(y,x,1) = uint8(scaled_red);  % pay attention to order!!!  
        end
    end
end
%toc
image(pic)
axis square