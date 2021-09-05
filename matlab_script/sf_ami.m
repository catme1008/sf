sum=0;
% for i=1:length(node_list20)
%     if find(node_list30==node_list20(i))
%         sum=sum+1;
%     end
% end
set(gcf,'Position',[100 100 1100 960]);
MarkerSize=50;
NodeSize=15;
Shape=['o','^','s','d'];
%Color=['b','g','r','m'];
Color=[[247,86,172];[147,62,183];[98,112,238];[94,201,240]]/255;
%画两个五角星点
pl1=[116.504565196836;116.745277190378];
pl2=[40.3326115331110;40.2765035331110];
scatter(pl1(1),pl2(1),150,'k','p','MarkerFaceColor','k');
hold on
scatter(pl1(2),pl2(2),150,'k','p','MarkerFaceColor','k');
hold on

%输入点集
p1=table2array(nodedata(:,2));
p2=table2array(nodedata(:,3));

%初始化，同时画出所有节点
si=size(nodedata);
l=si(1)-2;
sum=0;

for i=1:l
        scatter(p1(i),p2(i),15,[0.75,0.75,0.75],'o');
        hold on
end
%定义选取列表
nodeLists={node_list1,node_list10,node_list20,node_list30};
%依照顺序画图
for cur=1:4
    for i=1:l
        if ismember(i,nodeLists{1,cur})
            [inn,index]=find(i==nodeLists{1,cur});
            scatter(p1(i),p2(i),MarkerSize,Color(cur,:),Shape(cur));
            hold on
        end
    end
end