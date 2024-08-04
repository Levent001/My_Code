from dataclasses import dataclass
import os, re, struct
import numpy as np

dir1 = open("D:/Desktop/edges0.2_1000.txt","r")
dir2 = open("D:/Desktop/num_sum_nodes.txt","r")
lines1 = dir1.readlines()
lines2 = dir2.readlines()

data2 = []
data1 = []
i=0

for line2 in lines2:
    data2.append(int(line2))#得到第二个文件的数据，存在一个一维数组里面
print(data2)


for line1 in lines1:
    dataline = []
    # line1 = line1.replace(","," ")
    line1 = line1.replace("  "," ")
    line_num = line1.count(" ") + 1 #得到每一行数字的个数
    for j in range(line_num):
        data = int(line1.split()[j]) + data2[i] #将读取到的数据变成int型
        dataline.append(data)

    i=i+1
    data1.append(dataline)
print(data1)
