function [sum] = express(ini)
load('./matlabc.mat')
load('./matlaba.mat')
load('./matlabdemand.mat')
sum=0;
pos=find(ini==1);
posd=zeros(length(pos),1);
for i=1:2021
    %输入待比较的数据点
    points=ceil(demand(i)/40)*cMatrix(pos,i);
    sum=sum+min(points);
    [ll,len]=min(points);
    posd(len)=posd(len)+demand(i);
end

for i=1:length(pos)
    points=ceil(posd(i)/800)*aMatrix(pos(i),:);
    sum=sum+min(points);
end
sum=sum+20*length(pos);