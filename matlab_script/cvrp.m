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
%��ѭ����ʼ
while(length(customer)>0)
  ri=ri+1;
  current_route(1)=1;
  vload=0;
  %������Ȼδ������Ĺ˿��б�Ѱ�ҵ�һ�����
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
  current_route(2)=min_id;%ȷ��·��
  vload=rweight(current_route,weight);%����·������
  customer(d_loc)=[];%���Ѿ������·����Ӵ�������������
  %�����²��ֿ�ʼ��ѭ�����·����������,��ע�⣬ÿһ�������С�Ľ���
  flag=0;
  while(flag==0&&(length(customer)>0))%�ж��Ƿ����ػ����Ѿ����
      for ci=1:length(customer)%���ڹ˿��е�ÿһ���˿͵�
          customer_id=customer(ci);%��ȡ�õ��Ӧ�Ĺ˿�id
          for ins_loc=1:length(current_route)%�ڵ�ǰ·���б�������㣬������·��Ϊ��β·��
              rfw=current_route(1:ins_loc);%��ȡ�����ǰ·��
              rbw=current_route(ins_loc+1:length(current_route));%��ȡ������·��
              rtmp=[rfw,customer_id,rbw];%�����µ�·��
              r_dis=rdistance(rtmp,node);%������·���ľ���
              %���ﲻɾ��ԭ���Ĵ��룬ֻ����µĴ������
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
              is_first=(ci==1&&ins_loc==1);%�ж��Ƿ�Ϊ��ѭ����һ�λ�Ϊ��ǰ����
              if(is_first==1||r_dis<min_rdis)
              %if(is_first==1||delta<min_delta)%r_dis<min_rdis
                  min_rdis=r_dis;%���ǣ��������Сֵ
                  %min_delta=delta;
                  min_rtmp=rtmp;%��Сֵ
                  min_ci=ci;
              end
          end
      end
      %��������
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





