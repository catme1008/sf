function [node,capacity,weight]=readvrpfile(filename)
fid=fopen(filename,'r');
i=1;
while feof(fid) == 0
    raw_data{i,1} = fgetl(fid);
    i=i+1;
end
%��ȡ�ڵ���Ŀ
str=raw_data{4,1};
a = regexp(str,':');%�ҵ���ʼλ��
b = str(a+1:end);
node_num = str2double(b)';
%��ȡ����
str=raw_data{6,1};
a = regexp(str,':');%�ҵ���ʼλ��
b = str(a+1:end);
capacity = str2double(b)';
%��ȡ����
for i=1:node_num
str=raw_data{7+i,1};
b=regexp(str,' ','split');%ͨ���ո������ȡ����
buffer = str2double(b);
node(i,1)=buffer(3);
node(i,2)=buffer(4);
buffer
end
%��ȡ����
pin=8+node_num;%��λ����ϵ����ʼλ��
for i=1:node_num
str=raw_data{pin+i,1};
b=regexp(str,' ','split');%ͨ���ո������ȡ����
buffer = str2double(b);
weight(i,1)=buffer(2);
end
end