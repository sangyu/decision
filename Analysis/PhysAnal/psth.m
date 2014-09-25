function psth(s, r, front, back)
    figure
    hold on
%     xlim([-front, back])
    plot([0 0], [0 length(s)], 'r')
    for i=1:length(s)
        
            response= r(find(r>s(i)-front & r<s(i)+back));
            plot(s(i)-response, i*ones(1, length(response)), '.');

        
    end

    return
end