#!/usr/bin/python
import itertools as it
import linecache
import numpy as np

def bin16ToInt(s):
    return int(s[1:], 2) - int(s[0]) * (1 << 15)

def intToBin16(i):
    return (bin(((1 << 16) - 1) & i)[2:]).zfill(16)

def intToBin32(i):
    return (bin(((1 << 32) - 1) & i)[2:]).zfill(32)

num = 4  # 1-4
Coe = list(range(16))
Data = list(range(16))

BinaryNum = list(it.product(range(2), repeat=16))
file_w = open('/Users/xiaotiantang/Desktop/LUT_COE_4.txt', 'w')
file_r = open('/Users/xiaotiantang/Desktop/hw1B_rev.txt', 'r')



start = (num - 1) * 16 + 1
for x in range(start,start + 16):
    Coe[x-start] = bin16ToInt(intToBin16(int(linecache.getline('/Users/xiaotiantang/Desktop/hw1B_rev.txt', x), 2))) # Reading coeffcience

file_w.write("module DA_table_" + str(num) + "(table_in_" + str(num) + " , table_out_" + str(num) + ");\ninput [15:0]table_in_" + str(num) +
             ";\noutput [31:0]table_out_" + str(num) + "; \nreg [31:0]table_out_" + str(num) + "; \nalways@(table_in_" + str(num)
             + ")begin \n       case(table_in_" + str(num) + ")\n")

'''for i in range(len(BinaryNum)):
    mult = str(intToBin32(np.dot(BinaryNum[i][::-1], Coe)))
    file_w.write("          16'b" + ''.join(map(str, BinaryNum[i])) + ":table_out_" + str(num) + "=32'b" + mult + ";\n")'''
for i in range(len(BinaryNum)):
    mult = str(np.dot(BinaryNum[i][::-1], Coe))
    file_w.write("          16'b" + ''.join(map(str, BinaryNum[i])) + ":table_out_" + str(num) + "=32'b" + mult + ";\n")

file_w.write("          default:table_out_" + str(num) + "=0;\n       endcase\n       end\nendmodule")

print(np.dot(Coe, Data))
print(Data)
print(Coe)


