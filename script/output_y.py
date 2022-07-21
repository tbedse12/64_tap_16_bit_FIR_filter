#!/usr/bin/python
import itertools as it
import linecache
import numpy as np

def bin16ToInt(s):
    return int(s[1:], 2) - int(s[0]) * (1 << 15)

def intToBin16(i):
    return (bin(((1 << 16) - 1) & i)[2:]).zfill(16)

def intToBin38(i):
    return (bin(((1 << 38) - 1) & i)[2:]).zfill(38)

file_r = open('/Users/xiaotiantang/Desktop/hw1B.txt', 'r')
file_x = open('/Users/xiaotiantang/Desktop/hw1X.txt', 'r')
file_w = open('/Users/xiaotiantang/Desktop/hw1Y.txt', 'w')
Coe = list(range(64))
Data = list(range(16000))
output = list(range(250))

for x in range(1, 65):
    Coe[x-1] = bin16ToInt(intToBin16(int(linecache.getline('/Users/xiaotiantang/Desktop/hw1B_rev.txt', x), 2)))  # Reading coeffcience
for x in range(1, 16000):
    Data[x-1] = bin16ToInt(intToBin16(int(linecache.getline('/Users/xiaotiantang/Desktop/hw1X.txt', x), 2)))  # Reading input data
for x in range(1,250):
    output[x-1]= np.dot(Coe, Data[(x - 1) * 64 : (x - 1) * 64 + 64])
    file_w.write(''.join(map(str, intToBin38(output[x-1]))) + "\n")


print(Coe)
print(Data[0:64])
print(output)