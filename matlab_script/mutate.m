function [ini] = mutate(ini)
inside_rate=0.01;
inside_p=rand(1);
for i=1:2021
    if inside_p<inside_rate
        ini(i)=~ini(i);
    end
end
end

