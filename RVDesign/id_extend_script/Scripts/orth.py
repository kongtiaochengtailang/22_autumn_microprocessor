#!/bin/python 

import sys 
inpu=str(sys.argv[1])

file1 = open(inpu)
alllines1 = file1.readlines()
file1.close()

alllines2 = alllines1


def compared(x,y):
    for i in xrange(len(x)):
        if (x[i]=="1" and y[i]=="0") or (x[i]=="0" and y[i]=="1"):
            return "1"
    return "0"

list1 = []
for eachline1 in alllines1:
    stt1 = eachline1.strip().split()
    if(len(stt1)==2 and len(stt1[0])>=30):
        for eachline2 in alllines2:
            stt2 = eachline2.strip().split()
            if (len(stt2)==2 and len(stt2[0])>30):
                if stt1==stt2:
                    continue
                elif((compared(stt1[0],stt2[0])=="0") and stt1[1]!=stt2[1]):
                    print stt1,stt1[0][0:32]
                    print stt2,stt2[0][0:32]
                    print " "
                    if stt1 not in list1:
                        list1.append(stt1)
                    if stt2 not in list1:
                        list1.append(stt2)
for l in list1:
    print l

