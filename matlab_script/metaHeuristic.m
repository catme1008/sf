ini1=zeros(1,2021);
for i=1:2021
    if rand(1)<(150/2021)
        ini1(i)=1;
    end
end
ini2=zeros(1,2021);
for i=1:2021
    if rand(1)<(150/2021)
        ini2(i)=1;
    end
end
max_iter=100;
max_population=100;
iter=0;
cross_rate=0.6;
mutate_rate=0.01;
population=cell(max_population,1);
parent=[ini1;ini2];
son=[];
res=[];
aver=express(ini1);
for i=1:(max_population/2)
    population{2*i-1,1}=parent(1,:);
    population{2*i,1}=parent(2,:);
end
tic
while(iter<max_iter)
    iter=iter+1;  %迭代次数+1
    %种群随机交配
    p=length(population);
    parents=population;
    for i=1:(max_population/2)
        if randi([1,100])<cross_rate*100
            par1=parents{randi(p),1};
            par2=parents{randi(p),1};
            [son1,son2]=ox(par1,par2);
            population{2*i-1,1}=son1;
            population{2*i,1}=son2;
        else
            population{2*i-1,1}=parents{randi(p),1};
            population{2*i,1}=parents{randi(p),1};
        end
    end
    %进行突变
    for i=1:max_population
        mu=rand(1);
        if mu<(1-(iter)/100) 
            population{i,1}=mutate(population{i,1});
        end
    end
    %进行自然选择
    score=zeros(1,max_population);
    for i=1:max_population
       score(i)=express(population{i,1});
    end
    aver=median(score)
    res=[res,aver];
    %进行淘汰
    die=[];
    for i=1:max_population
        if express(population{i,1})>aver
            die=[die,i];
        end
    end
    population(die)=[];
    iter
end
toc
min(score)
sum(population{i,1})