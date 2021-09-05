file='./A_VRP_txt/A-n32-k5.txt';
[node,capacity,weight]=readvrpfile(file);
tic;
depot=node(1,:);
dx=depot(1);
dy=depot(2);
customer=(2:length(node));
RouteMap=cell(100,1);
ri=0;
RouteWeight=[];
%主循环开始
while(length(customer)>0)
  ri=ri+1;
  current_route(1)=1;
  vload=0;
  %遍历仍然未被服务的顾客列表，寻找第一个起点
  for ci=1:length(customer)
        customer_id=customer(ci);
        cx=node(customer_id,1);
        cy=node(customer_id,2);
        dis=sqrt((cx-dx)^2+(cy-dy)^2);
        if (ci==1||dis<min_dis)
            min_dis=dis;
            min_id=customer_id;
            d_loc=ci;
        end
  end
  current_route(2)=min_id;%确定路径
  vload=rweight(current_route,weight);%更新路径负载
  customer(d_loc)=[];%将已经加入的路径点从待服务名单除名
  %从以下部分开始，循环求解路径生成问题,请注意，每一步都务必小心谨慎
  flag=0;
  while(flag==0&&(length(customer)>0))%判断是否满载或者已经完成
      for ci=1:length(customer)%对于顾客中的每一个顾客点
          customer_id=customer(ci);%读取该点对应的顾客id
          for ins_loc=1:length(current_route)%在当前路径中遍历插入点，本部分路径为无尾路径
              rfw=current_route(1:ins_loc);%提取插入点前路径
              rbw=current_route(ins_loc+1:length(current_route));%提取插入点后路径
              rtmp=[rfw,customer_id,rbw];%生成新的路径
              r_dis=rdistance(rtmp,node);%计算新路径的距离
              %这里不删除原来的代码，只添加新的代码进入
              x1=node(current_route(ins_loc),1);
              y1=node(current_route(ins_loc),2);
              if isempty(rbw)
                 x2=node(current_route(1),1);
                 y2=node(current_route(1),2);
              else
                 x2=node(current_route(ins_loc+1),1);
                 y2=node(current_route(ins_loc+1),2);
              end
              x3=node(customer_id,1);
              y3=node(customer_id,2);
              %delta=sqrt((x3-x1)^2+(y3-y1)^2)+sqrt((x3-x2)^2+(y3-y2)^2)-sqrt((x1-x2)^2+(y1-y2)^2);
              is_first=(ci==1&&ins_loc==1);%判断是否为大循环第一次或为当前最优
              if(is_first==1||r_dis<min_rdis)
              %if(is_first==1||delta<min_delta)%r_dis<min_rdis
                  min_rdis=r_dis;%若是，则给出最小值
                  %min_delta=delta;
                  min_rtmp=rtmp;%最小值
                  min_ci=ci;
              end
          end
      end
      %遍历结束
      if rweight(min_rtmp,weight)>capacity
          flag=1;
      else
          current_route=min_rtmp;
          customer(min_ci)=[];
      end
  end
  RouteMap{ri,1}=current_route;
  RouteWeight=[RouteWeight,rweight(current_route,weight)];
  current_route=[];
end
lasttime=toc;
cost=0;
for i=1:ri
    cr=RouteMap{i,1};
    cost=cost+rdistance(cr,node);
     for p=1:length(cr)
         plx(p)=node(cr(p),1);
         ply(p)=node(cr(p),2);
     end
     hold on;
     plot(plx,ply);
     plot(plx,ply,'*');

end





