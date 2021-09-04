from gurobipy import *
import numpy as np
import pandas as pd
cost_construct=150
d = pd.read_csv('demand.csv').values
c = pd.read_csv('cMatrix.txt',header=None,index_col=False).values
a = pd.read_csv('aMatrix.txt',header=None,index_col=False).values
#yyF=pd.read_csv('yyFout.txt',sep = "\s|\(|\,|\)",header=None,index_col=False).values

V=500000
M=5000000
for j in range(1,2022):
  c[j-1,2020]=c[j-1,2020]*6

model = Model('code')
model.setParam('TimeLimit', 180*60)
x = {}
z = {}
y = {}
v = {}
u_c = {}
u_a = {}
#定义决策变量
for j in range(1,2022):
    name = 'x_' + str(j)
    x[j] = model.addVar(0
                              , 1
                              , vtype=GRB.BINARY
                              , name=name)

for j in range(1,2022):
    for k in range(1,3):
        name = 'y_' + str(j) + '_' + str(k)
        y[j,k] = model.addVar(0
                              , 1
                              , vtype= GRB.BINARY
                              , name= name)

for i in range(1,2022):
    for j in range(1,2022):
        name = 'z_' + str(i) + '_' + str(j)
        z[i,j] = model.addVar(0
                              , 1
                              , vtype= GRB.BINARY
                              , name= name)


for i in range(1,2022):
    for j in range(1,2022):
        name = 'u_c_' + str(i) + '_' + str(j)
        u_c[i,j] = model.addVar(0
                              ,1000
                              , vtype= GRB.INTEGER
                              , name= name)

for j in range(1,2022):
    for k in range(1,3):
        name = 'u_a_' + str(j) + '_' + str(k)
        u_a[j,k] = model.addVar(0
                              ,1000
                              , vtype= GRB.INTEGER
                              , name= name)
for j in range(1,2022):
    name = 'v_'  + str(j)
    v[j] = model.addVar(0
                              , GRB.INFINITY
                              , vtype= GRB.INTEGER
                              , name= name)
#更新模型
model.update()


#定义目标函数
obj = LinExpr(0)
for j in range(1,2022):
    obj.addTerms(cost_construct, x[j])
model.setObjective(obj, GRB.MINIMIZE)
obj1 = LinExpr(0)
for i in range(1,2022):
    for j in range(1,2022):
        w1 = c[i-1,j-1]
        obj1.addTerms(w1, u_c[i,j])
obj2 = LinExpr(0)
for j in range(1,2022):
    for k in range(1,3):
        w2 = a[j-1,k-1]
        obj2.addTerms(w2, u_a[j,k])
model.setObjective(obj+obj1+obj2, GRB.MINIMIZE)

#定义约束一(2-2)
for i in range(1,2022):
    lhs = LinExpr(0)
    for j in range(1,2022):
        lhs.addTerms(1, z[i,j])
    model.addConstr(lhs == 1, name= 'customerServe_' + str(i))

#定义约束二
for i in range(1,2022):
    for j in range(1,2022):
        lhs = LinExpr(0)
        lhs.addTerms(1, z[i,j])
        lhs.addTerms(-1, x[j])
        model.addConstr(lhs <= 0, name= 'customerServe2_' + str(i))

#定义约束三
for j in range(1,2022):
    lhs = LinExpr(0)
    for k in range(1, 3):
        lhs.addTerms(1, y[j,k])
    lhs.addTerms(-1, x[j])
    model.addConstr(lhs == 0, name= 'rdc_' + str(j))

#定义约束四
for j in range(1, 2022):
    lhs = LinExpr(0)
    for i in range(1, 2022):
        lhs.addTerms(d[i-1,1], z[i,j])
    lhs.addTerms(-1,v[j])
    model.addConstr(lhs == 0, name= 'yueshu4_' + str(i))


#定义约束五
#time windows
for j in range(1,2022):
    lhs = LinExpr(0)
    lhs.addTerms(1, v[j])
    model.addConstr(lhs <= V , name= 'yueshu5_' + str(j))

#定义约束六
for i in range(1,2022):
    for j in range(1,2022):
        lhs = LinExpr(0)
        lhs.addTerms(1, u_c[i,j])
        lhs.addTerms(-M,z[i,j])
        model.addConstr(lhs <= 0, name='yueshu6_' + str(i) + '_' + str(j))

#定义约束戚
for i in range(1,2022):
    lhs = LinExpr(0)
    for j in range(1,2022):
        lhs.addTerms(40, u_c[i,j])
    model.addConstr(lhs >= d[i-1,1], name='yueshu7_' + str(i))

#定义约束八
for j in range(1,2022):
    lhs = LinExpr(0)
    for k in range(1,3):
        lhs.addTerms(800, u_a[j,k])
    model.addConstr(lhs >= v[j], name='yueshu8_' + str(j))
#定义约束2-8
for j in range(1,2022):
    for k in range(1, 3):
        lhs = LinExpr(0)
        lhs.addTerms(1, u_a[j,k])
        lhs.addTerms(-M, y[j,k])
        model.addConstr(lhs <= 0, name= 'rdc_' + str(j))
#导出模型
model.write('w.lp')
#求解
model.optimize()

#打印结果
print("\n\n-----optimal value-----")
print(model.ObjVal)
'''
f=open('xout1.txt','w')
for key in x.keys():
    if(x[key].x > 0 ):
        print(x[key].VarName + ' = ', x[key].x,file=f)
f.close

g=open('yout1.txt','w')
count=0

for key in y.keys():
    if(y[key].x > 0 ):
        print(y[key].VarName + ' = ', y[key].x,file=g)
        count=count+1
print(count)
g.close
w=open('ucout1.txt','w')
for key in u_c.keys():
    if (u_c[key].x > 0):
        print(u_c[key].VarName + ' = ', u_c[key].x,file=w)
w.close
'''
yy=open('yyFout150.txt','w')
for key in y.keys():
    if(y[key].x > 0 ):
        print(key,file=yy)
yy.close