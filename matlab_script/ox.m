function [ini1,ini2] = ox(ini1,ini2)
pos=randi(2021);
ex=ini1(pos:2021);
ini1(pos:2021)=ini2(pos:2021);
ini2(pos:2021)=ex;
end

