p1=table2array(nodedata(:,2));
p2=table2array(nodedata(:,3));
pl1=[116.504565196836;116.745277190378];
pl2=[40.3326115331110;40.2765035331110];

%进行文件读取
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


%进行文件10读取
i
i=1;
filename='10.txt';
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
si=size(nodedata);
l=si(1)-2;
sum=0;
for i=1:l
    if ismember(i,node_list)
        sum=sum+1;
        [inn,index]=find(i==node_list);
        if tr_list(index)==1
            scatter(p1(i),p2(i),'y','o');
            hold on
        else
            scatter(p1(i),p2(i),'g','o');
            hold on
        end
    else
        scatter(p1(i),p2(i),15,[0.75,0.75,0.75],'o');
        hold on
    end
end




%%%%%20
i
i=1;
filename='20.txt';
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
si=size(nodedata);
l=si(1)-2;
sum=0;
for i=1:l
    if ismember(i,node_list)
        sum=sum+1;
        [inn,index]=find(i==node_list);
        if tr_list(index)==1
            scatter(p1(i),p2(i),'m','o');
            hold on
        else
            scatter(p1(i),p2(i),'c','o');
            hold on
        end
    else
        scatter(p1(i),p2(i),15,[0.75,0.75,0.75],'o');
        hold on
    end
end


%%%%%30
i
i=1;
filename='30.txt';
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
si=size(nodedata);
l=si(1)-2;
sum=0;
for i=1:l
    if ismember(i,node_list)
        sum=sum+1;
        [inn,index]=find(i==node_list);
        if tr_list(index)==1
            scatter(p1(i),p2(i),30,[0.98,0.98,0.60],'o');
            hold on
        else
            scatter(p1(i),p2(i),30,[0.75,0.00,1.00],'o');
            hold on
        end
    else
        scatter(p1(i),p2(i),15,[0.75,0.75,0.75],'o');
        hold on
    end
end
