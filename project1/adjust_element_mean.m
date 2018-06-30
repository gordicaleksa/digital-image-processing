function [ element_img ] = adjust_element_mean( element_img, target_mean_value )
%ADJUST_ELEMENT_MEAN adjusts the mean of the element_img so that it's equal to
% target_mean_value and also the range remains [0,255]

current = mean(element_img(:));

% dumm algorithm this could be improved using some binary strategy
while (abs(target_mean_value-current) > 0.5)
	if ((target_mean_value- current) > 0)
		element_img = element_img + 1;
	else
		element_img = element_img - 1;
	end
	% because of the saturation arithmetic we cannot simply add (-/+)1
	current = mean(element_img(:));
end

end

