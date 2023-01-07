import os
import sys
import csv
import comm_lib

#Acquire Input Arguments
opts=sys.argv[1:]
if len(opts)==0:
    print "Option Error"
    print "Please input: python csv_to_ins_dec.py --csv_path_i xx --in_dir_o xx"
    sys.exit()

for i in range(len(opts)):
    opt=opts[i]
    if opt=="--csv_path_i":
        csv_path_i=opts[i+1]
    elif opt=="--in_dir_o":
        in_dir_o=opts[i+1]

#Read Input Files
csv_alllines=comm_lib.read_csv(csv_path_i)

#Parse CSV File Content Line By Line
dic={}

##input
dic["id_inst_i32"]=[]

##output
dic["br_i1"]=[]
dic["mem_write_i1"]=[]
dic["mem_read_i1"]=[]
dic["regs_write_i1"]=[]
dic["mem2reg_i1"]=[]

dic["br_addr_mode_i1"]=[]
dic["src1_sel_i2"]=[]
dic["src2_sel_i2"]=[]

dic["id_imm_i32"]=[]
dic["op_ctl_i32"]=[]


start_row=2

end_row=0
if len(csv_alllines)>0:
    end_row=len(csv_alllines)-1

input_start_col=3
input_len=32

output_start_col=36
output_len=74


csv_alllines=comm_lib.identify_and_fill_merged_cells(csv_alllines,input_start_col,input_start_col+input_len-1,start_row,end_row)
csv_alllines=comm_lib.identify_and_fill_merged_cells(csv_alllines,output_start_col,output_start_col+output_len-1,start_row,end_row)
comm_lib.print_list_by_line(csv_alllines)

for row in range(len(csv_alllines)):
    if row in range(start_row):
        continue

    line=csv_alllines[row]

    #get signal values from specific column
    ##input signals
    dic["id_inst_i32"].append(line[input_start_col:input_start_col+input_len])

    ##output signals
    dic["br_i1"].append(line[output_start_col])
    dic["mem_write_i1"].append(line[output_start_col+1])
    dic["mem_read_i1"].append(line[output_start_col+2])
    dic["regs_write_i1"].append(line[output_start_col+3])
    dic["mem2reg_i1"].append(line[output_start_col+4])

    dic["br_addr_mode_i1"].append(line[output_start_col+5])
    dic["src1_sel_i2"].append(line[output_start_col+6:output_start_col+6+2])
    dic["src2_sel_i2"].append(line[output_start_col+8:output_start_col+8+2])

    dic["id_imm_i32"].append(line[output_start_col+10:output_start_col+10+32])

    dic["op_ctl_i32"].append(line[output_start_col+42:output_start_col+42+32])

comm_lib.print_dic_by_key_val(dic)

#Generate Truth Table
input_list=["id_inst"]

comm_lib.gen_signal_by_range(dic,in_dir_o,"br",0,0,input_list)
comm_lib.gen_signal_by_range(dic,in_dir_o,"mem_write",0,0,input_list)
comm_lib.gen_signal_by_range(dic,in_dir_o,"mem_read",0,0,input_list)
comm_lib.gen_signal_by_range(dic,in_dir_o,"regs_write",0,0,input_list)
comm_lib.gen_signal_by_range(dic,in_dir_o,"mem2reg",0,0,input_list)

comm_lib.gen_signal_by_range(dic,in_dir_o,"br_addr_mode",0,0,input_list)
comm_lib.gen_signal_by_range(dic,in_dir_o,"src1_sel",0,1,input_list)
comm_lib.gen_signal_by_range(dic,in_dir_o,"src2_sel",0,2,input_list)

comm_lib.gen_signal_by_range(dic,in_dir_o,"id_imm",0,31,input_list)

comm_lib.gen_signal_by_range(dic,in_dir_o,"op_ctl",0,31,input_list)
    
