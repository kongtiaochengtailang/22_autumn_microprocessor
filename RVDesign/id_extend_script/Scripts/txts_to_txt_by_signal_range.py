import os
import sys
import csv

#Acquire Input Arguments
opts=sys.argv[1:]
if len(opts)==0:
    print "Option Error"
    print "Please input: python txts_to_txt_by_signal_range.py --signal_name_i xx --file_postfix_i xx --in_dir_o xx --start_i xx --end_i xx"
    sys.exit()

in_dir_o=""
signal_name_i=""
end_i=""
start_i=""
file_postfix_i=""

for i in range(len(opts)):
    opt=opts[i]
    if opt=="--signal_name_i":
        signal_name_i=opts[i+1]
    elif opt=="--in_dir_o":
        in_dir_o=opts[i+1]
        if in_dir_o[-1]=="/":
            in_dir_o=in_dir_o[:-1]
    elif opt=="--start_i":
        start_i=int(opts[i+1])
    elif opt=="--end_i":
        end_i=int(opts[i+1])
    elif opt=="--file_postfix_i":
        file_postfix_i=opts[i+1]

def read_file(file_path):
    f=open(file_path,"r")
    readlines=f.readlines()
    f.close()
    return readlines

def write_file(file_path,write_content):
    f=open(file_path,"w")
    for line in write_content:
        f.write(line)
    f.close()

def merge_ins_by_range(signal_name_i,start_i,end_i):
    if start_i==0 and end_i==0:
        pass
    elif start_i<end_i: #gen *[i].txt
        range_i=range(start_i,end_i+1)
        range_i=range_i[::-1] #reverse list
        merge_in_content=[]

        print "-----------------------------------------------------------------------------------------"
        print "Begin to merge files to a file." 
        for i in range_i:
            bit_name_i=signal_name_i+"["+str(i)+"]"
            tmp_in_file_name=bit_name_i+file_postfix_i
            tmp_in_file_path=in_dir_o+"/"+tmp_in_file_name
            in_bit_content=read_file(tmp_in_file_path)
            #merge_in_content=merge_in_content+in_bit_content+["\n"]
            merge_in_content=merge_in_content+in_bit_content

        in_file_name=signal_name_i+"["+str(end_i)+":"+str(start_i)+"]"+file_postfix_i
        in_file_path=in_dir_o+"/"+in_file_name
        write_file(in_file_path, merge_in_content)
        print "gen "+in_file_path
        print "Done\n"
    else:
        print "Error: output signal range is [end_i:start_i], but start_i must less than end_i."
        sys.exit()

#if signal_name_i+str(start_i)+str(end_i)=="": #default
#    merge_ins_by_range("rv64_to_t32p",0,28)
#    merge_ins_by_range("rv64_a64_only",0,0)
#    merge_ins_by_range("rv64_ccbit_sf",0,0)
#    merge_ins_by_range("rv64_ccbit_m",0,0)
#    merge_ins_by_range("rv64_ccbit_n",0,0)
#    merge_ins_by_range("rv64_ccbit_d",0,0)
#    merge_ins_by_range("rv64_mop_cnt",0,1)
#    merge_ins_by_range("rv64_def",0,0)
#else:
#    merge_ins_by_range(signal_name_i,start_i,end_i)

merge_ins_by_range(signal_name_i,start_i,end_i)
