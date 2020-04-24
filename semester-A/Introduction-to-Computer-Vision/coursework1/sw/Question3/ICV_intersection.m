function [intersection] = ICV_intersection(his_matrix1,his_matrix2)
%ICV_intersection 
%   Input: two histogram matrices
%   Output: The intersection of the two histograms
%   Return: The intersection matrix (1,3)

Histogram1 = ICV_normalization(his_matrix1);
Histogram2 = ICV_normalization(his_matrix2);

[M, N] = size(his_matrix1);

intersection = zeros(1,3);

% calculate the intersection of each colour channel in a loop
for i = 1:N
    for j = 1:M
        if Histogram1(j,i) >= Histogram2(j,i)
            intersection(1,i) = intersection(1,i) + Histogram2(j,i);
        else
            intersection(1,i) = intersection(1,i) + Histogram1(j,i);
        end
    end
end

% visualizing the intersection value
figure();
hold on
for i = 1:length(intersection)
    h=bar(i,intersection(1,i));
    if i == 1
        set(h,'FaceColor','r');
    elseif i == 2
        set(h,'FaceColor','g');
    else
        set(h,'FaceColor','b');
    end
end
set(gca,'xtick',[1 2 3]); 
set(gca,'xticklabel',{'Red','Green','Blue'});
xlabel('Channel');
ylabel('Intersection');
hold off



end

