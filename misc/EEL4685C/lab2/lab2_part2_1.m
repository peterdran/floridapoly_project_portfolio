%part 2.1
%using vector multiplication
%increase red columnwise left to right
%increase green rowwise top to bottom
%decrease blue columnwise left to right

x = uint8(zeros(250,250,3)); %black image
x(:,:,1) = ones(1,250)'*[1:250]; %red
x(:,:,2) = [1:250]'*ones(1,250); %green
x(:,:,3) = ones(1,250)'*[250:-1:1];%blue

image(x); axis square; axis off;