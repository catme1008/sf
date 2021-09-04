from gurobipy import *
import numpy as np
import pandas as pd

d = pd.read_csv('demand.csv').values
bmat = pd.read_csv('bMatrix.txt',header=None,index_col=False).values
amat = pd.read_csv('aMatrix.txt',header=None,index_col=False).values
#yyF=pd.read_csv('yyFout.txt',sep = "\s|\(|\,|\)",header=None,index_col=False).values
yyF=pd.read_csv('yychuli.txt',header=None,index_col=False).values
uc=pd.read_csv('ucoutchuli.txt',header=None,index_col=False).values
#print(d.shape)
#print(uc)
#print(uc[0,0])
connect = {}
nm=[]
nodecount = yyF.shape[0]
v = [0 for i in range(yyF.shape[0])]

for i in range(0,yyF.shape[0]):
    connect[yyF[i,0]] = yyF[i,1]
    nm.append(yyF[i,0])
print(nm)
for i in range(0,uc.shape[0]):
    v[nm.index(uc[i,1])]=v[nm.index(uc[i,1])]+d[int(uc[i,0])-1,1]
print(v)


'''
M=5000000
model = Model('code')
model.setParam('TimeLimit', 10*60)
p = {}
f = {}
T = {}
ub = {}
ua = {}
z={}
#定义决策变量
for a in range(1, nodecount):
    for b in range(1, nodecount):
        name = 'p_' + str(a)+ '_' + str(b)
        p[a,b] = model.addVar(0
                              , 1
                              , vtype=GRB.BINARY
                              , name=name)
        name = 'f_' + str(a) + '_' + str(b)
        f[a, b] = model.addVar(0
                               , GRB.INFINITY
                               , vtype=GRB.INTEGER
                               , name=name)

for j in range(1, nodecount):
    for k in range(1,3):
        name = 'T_' + str(j) + '_' + str(k)
        T[j,k] = model.addVar(0
                              , GRB.INFINITY
                              , vtype= GRB.INTEGER
                              , name= name)
        name = 'ua_' + str(j) + '_' + str(k)
        ua[j, k] = model.addVar(0
                               , GRB.INFINITY
                               , vtype=GRB.INTEGER
                               , name=name)
        name = 'z_' + str(j) + '_' + str(k)
        z[j, k] = model.addVar(0
                                , 1
                                , vtype=GRB.BINARY
                                , name=name)


for j in range(1, nodecount):
    for b in range(1, nodecount):
        name = 'ub_' + str(j) + '_' + str(b)
        ub[j,b] = model.addVar(0
                              , GRB.INFINITY
                               , vtype=GRB.INTEGER
                              , name= name)

#更新模型
model.update()

#定义目标函数
obj1 = LinExpr(0)
print(nm[0])
for i in range(1, nodecount):
    for j in range(1, nodecount):
        obj1.addTerms(bmat[nm[i-1],nm[j-1]], ub[i,j])
for j in range(1, nodecount):
    for k in range(1,3):
         obj1.addTerms(amat[nm[j-1],k-1], ua[j,k])
model.setObjective(obj1, GRB.MINIMIZE)

#定义约束一
for b in range(1, nodecount):
    for j in range(1, nodecount):
        lhs = LinExpr(0)
        lhs.addTerms(M,p[j,b])
        for a in range(1, nodecount):
            lhs.addTerms(1, p[a,j])
        model.addConstr(lhs <= M, name= 'customerServe2_' + str(i))
#定义约束二
for b in range(1, nodecount):
    for j in range(1, nodecount):
        lhs = LinExpr(0)
        lhs.addTerms(1, ub[j,b])
        lhs.addTerms(-M,p[j,b])
        model.addConstr(lhs <= 0, name= 'customerServe_' + str(i))

#定义约束三
for b in range(1, nodecount):
    for j in range(1, nodecount):
        lhs = LinExpr(0)
        lhs.addTerms(200, ub[j,b])
        lhs.addTerms(-1,f[j,b])
        lhs.addTerms(-M,p[j,b])
        model.addConstr(lhs >= -M, name= 'customerServe_' + str(i))

#定义约束四
for j in range(1, nodecount):
    for b in range(1, nodecount):
        lhs = LinExpr(0)
        lhs.addTerms(1,f[j,b])
        lhs.addTerms(-M,p[j,b])
        model.addConstr(lhs <= 0, name= 'yueshu4_' + str(i))
#定义约束五
for j in range(1, nodecount):
    lhs = LinExpr(0)
    for b in range(1, nodecount):
        lhs.addTerms(1,f[j,b])
    model.addConstr(lhs <= v[j], name= 'yueshu4_' + str(i))

#定义约束六
for j in range(1,nodecount):
    lhs = LinExpr(0)
    for a in range(1,nodecount):
        lhs.addTerms(1, f[a, j])
    for b in range(1, nodecount):
        lhs.addTerms(-1, f[j, b])
    for k in range(1, 3):
        lhs.addTerms(-1, T[j, k])
    model.addConstr(lhs == -v[j], name='yueshu6_' + str(i) + '_' + str(j))

#定义约束戚
for j in range(1, nodecount):
    for k in range(1,3):
        lhs = LinExpr(0)
        lhs.addTerms(-M, z[j,k])
        lhs.addTerms(1,ua[j,k])
        model.addConstr(lhs <= 0, name='daddy_qi' + str(i))

#定义约束八
for j in range(1, nodecount):
    for k in range(1,3):
        lhs = LinExpr(0)
        lhs.addTerms(800, ua[j,k])
        lhs.addTerms(-1, T[j, k])
        lhs.addTerms(-M, z[j, k])
        model.addConstr(lhs >= -M, name='yueshu8_' + str(j))
#约束就
for j in range(1, nodecount):
    for k in range(1,3):
        lhs = LinExpr(0)
        lhs.addTerms(-M, z[j,k])
        lhs.addTerms(1,T[j,k])
        model.addConstr(lhs <= 0, name='_qi' + str(i))
#导出模型
model.write('w.lp')
#求解
model.optimize()
#打印结果
print("\n\n-----optimal value-----")
file = open("result.txt",'w')
print(model.objVal,file=file)
for key in ua.keys():
    if(ua[key].x == 0 ):
        print(key,file=file)
file.close
print(model.ObjVal)
for key in ub.keys():
    if(ub[key].x != 0 ):
        print(ub[key].VarName)
for key in ua.keys():
    if(ua[key].x != 0 ):
        print(ua[key].VarName)

file=open('fffffout.txt','w')
for key in f.keys():
    if(f[key].x > 0 ):
        print(f[key].VarName + ' = ', f[key].x,file=file)
file.close
file=open('uaout.txt','w')
for key in ua.keys():
    if(ua[key].x > 0 ):
        print(ua[key].VarName + ' = ', ua[key].x,file=file)
file.close

f=open('xout.txt','w')
for key in x.keys():
    if(x[key].x > 0 ):
        print(x[key].VarName + ' = ', x[key].x,file=f)
f.close
g=open('yout.txt','w')
count=0
for key in y.keys():
    if(y[key].x > 0 ):
        print(y[key].VarName + ' = ', y[key].x,file=g)
        count=count+1
print(count)
g.close
w=open('ucout.txt','w')
for key in u_c.keys():
    if (u_c[key].x > 0):
        print(u_c[key].VarName + ' = ', u_c[key].x,file=w)
w.close

yy=open('yyFout.txt','w')
for key in y.keys():
    if(y[key].x > 0 ):
        print(key,file=yy)
g.close
'''
