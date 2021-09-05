function [node,capacity,weight]=readvrpfile(filename)
fid=fopen(filename,'r');
i=1;
while feof(fid) == 0
    raw_data{i,1} = fgetl(fid);
    i=i+1;
end
%读取节点数目
str=raw_data{4,1};
a = regexp(str,':');%找到开始位置
b = str(a+1:end);
node_num = str2double(b)';
%读取容量
str=raw_data{6,1};
a = regexp(str,':');%找到开始位置
b = str(a+1:end);
capacity = str2double(b)';
%读取坐标
for i=1:node_num
str=raw_data{7+i,1};
b=regexp(str,' ','split');%通过空格把数据取出来
buffer = str2double(b);
node(i,1)=buffer(3);
node(i,2)=buffer(4);
buffer
end
%读取需求
pin=8+node_num;%定位重量系数起始位置
for i=1:node_num
str=raw_data{pin+i,1};
b=regexp(str,' ','split');%通过空格把数据取出来
buffer = str2double(b);
weight(i,1)=buffer(2);
end
end