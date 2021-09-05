i=1;
filename='1.txt';
fid=fopen(filename,'r');
node_list=[];
tr_list=[];
while feof(fid) == 0
    raw_data{i,1} = fgetl(fid);
    i=i+1;
end
node_num=i-1;
for i=1:node_num
 str=raw_data{i,1};
 str=str(2:length(str)-1);
 b=regexp(str,',','split');%通过空格把数据取出来
 node_list=[node_list,str2double(b(1))];
 tr_list=[tr_list,str2double(b(2))];
end
% buffer = str2double(b);
% node(i,1)=buffer(3);
% node(i,2)=buffer(4);
% buffer
% end