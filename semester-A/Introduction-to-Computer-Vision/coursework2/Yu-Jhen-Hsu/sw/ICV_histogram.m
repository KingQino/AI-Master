function ICV_histogram(frequency, index, windowNum, isGlobal)

    if isGlobal
        x = 0: 256*windowNum-1;
        plot(x,frequency);
        title('Histogram of global lDescription');
        xlim([-5 256*windowNum+4]);
    else
        x = 0:255;
        frequency = frequency(:, index);
        plot(x,frequency);
        title('Histogram in window # ' + string(index));  
        xlim([-5 260]);
    end
   
    xlabel('Value');
    ylabel('Count'); 
end

