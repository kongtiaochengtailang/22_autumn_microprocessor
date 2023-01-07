import csv
import os
import sys

def chk_list_len(listi,lent):
    leni=len(listi)
    if leni==lent:
        return listi
    else:
        print "Error: "+str(listi)+" does not meet the correct length "+str(lent)
        sys.exit()

def str_to_bin(stri,stri_system,bin_bits):
    stri=str(stri)
    if stri!="-":
        if stri.isdigit():
            inti=int(stri,stri_system)
            bini=str(bin(inti))[2:]
            len_bini=len(bini)
         
            bino=(bin_bits-len_bini)*"0"+bini
        else:
            bino=stri
    else:
        bino=bin_bits*"-"
    return bino

def list_to_str(list_i):
    stro=""
    for i in list_i:
        stro=stro+str(i).strip()
    return stro

def print_list_by_line(list_i):
    for i in list_i:
        print i
    print "\n"
    return

def find_dic_nearest_key(stri,dici):
    nearest_keys=[]
    match_keys=""
    for key in dici.keys():
        if stri in key:
           nearest_keys=nearest_keys+[key]

    if len(nearest_keys)==0:
        print "Error: Not find nearest key in dir.keys() completely, error key is "+stri
        print "Dir Keys have "+dici.keys()
        sys.exit()
    else:
        len_stri=len(stri)
        for near_key in nearest_keys:
            if stri==near_key[0:(len_stri)]:
                match_keys=near_key
                break
    if match_keys=="":
        print "Error: Find some similar key in dir.keys(), error key is "+stri
        print "Similar dir Keys have ",nearest_keys
        sys.exit()
    return match_keys

def print_dic_by_key_val(dic_i):
    for key in dic_i.keys():
        print key+":"
        for val in dic_i[key]:
            print val
        print "\n" 
    return


#return list,input str
def read_text(text_path):
    f=open(text_path,'r')
    text_allines=f.readlines()
    f.close()
    return text_allines

#--------------------------------CSV Operation--------------------------------------
#return list[x][y],input str
def read_csv(csv_path):
    f=open(csv_path,'r')
    csv_alllines=[]
    tmp_csv_alllines=csv.reader(f)
    for i in tmp_csv_alllines:
        csv_alllines.append(i)
    f.close()
    
    return csv_alllines


#return list,input list
def process_merged_cell(list_i):
    list_o=list_i
    merged_cells=[]
    for i in range(len(list_i)):
        entry=list_i[i]
        if entry=="":
            merged_cells.append(i)

        if (entry!="") or (i==(len(list_i)-1) and entry==""):
            num_m1=len(merged_cells)

            if num_m1!=0:
                num=num_m1+1
                start_i=merged_cells[0]-1
                content=list_i[start_i]
                merged_cells=[start_i]+merged_cells

                for n in range(num):
                    new_content=content+"_"+str(num-n-1)
                    list_o[merged_cells[n]]=new_content

            merged_cells=[]

    return list_o

def identify_and_fill_merged_cells(list_i,start_col,end_col,start_row,end_row):
    rows=len(list_i)
    list_o=list_i

    for row in range(start_row,end_row+1):
        #print  "Before:\n",row,list_o[row][start_col:(end_col+1)]
        list_o[row][start_col:(end_col+1)]=process_merged_cell(list_o[row][start_col:(end_col+1)])
        #print "After:\n",row,list_o[row][start_col:(end_col+1)]
        #print "\n"
    return list_o

#return list[x][y],input list[x][y]
def fill_empty_cells_with_nonempty_cells_in_previous_row(list_i,start_col,end_col,start_row,end_row):
    rows=len(list_i)
    list_o=list_i

    for row in range(start_row,end_row+1):
        line=list_o[row]
        line_str=list_to_str(line[start_col:(end_col+1)])

        if line_str=="":
             #print  "Before:\n",row,line[start_col:(end_col+1)]
             list_o[row][start_col:(end_col+1)]=list_o[row-1][start_col:(end_col+1)]
             #print "After:\n",row,list_o[row][start_col:(end_col+1)]
             #print "\n"
    return list_o

def deal_tag_val(tag_val):
    if "," in tag_val:
        list_tmp=tag_val.split(",")
        listo=[]
        for i in list_tmp:
            i=i.strip()
            if i in ["0","1"]:
                listo.append(i)
            else:
                i=i.replace("["," ")
                i=i.replace(":"," ")
                i=i.replace("]","")
                list_i=i.split(" ")
                if len(list_i)==2:
                   listo.append(list_i[0])
                else:
                   range_start_end=range(int(list_i[2]),(int(list_i[1])+1))
                   range_end_start=list(reversed(range_start_end))
                   for x in range_end_start:
                       listo.append(list_i[0]+"_"+str(x))
    else:
        listo=list(tag_val)
    return  listo

#---------------------------------------------gen *.in by bit------------------------------------------
def gen_signal_by_bit(dic,in_path,signal_name,position,input_args):
    print "-----------------------------------------------------------------------------------------"
    print "Begin to generate truth table(*.in)"
    print "gen "+in_path

    head_inputs=[]
    head_outputs=[]

    signal_name_key=find_dic_nearest_key(signal_name+"_i",dic)
    signal_vals=dic[signal_name_key]
    print "Signal Name Key:",signal_name_key

    if signal_name+"_i1"==signal_name_key:
        head_outputs.append(signal_name)
    else:
        head_outputs.append(signal_name+"["+str(position)+"]")

    for input_arg_name in input_args:
         input_arg_name_key=find_dic_nearest_key(input_arg_name+"_i",dic)

         len_in=int(input_arg_name_key.replace(input_arg_name+"_i",""))
         for in_bit in range(len_in):
             if len_in==1:
                 head_inputs.append(input_arg_name)
                 break
             head_inputs.append(input_arg_name+"["+str(len_in-in_bit-1)+"]")           

    head_alllines=[]
    head_alllines.append(".i")
    len_inputs=len(head_inputs)
    head_alllines[0]=head_alllines[0]+" "+str(len_inputs)+"\n"

    head_alllines.append(".o 1\n")
    head_alllines.append(".type fd\n")

    head_alllines.append(".ilb")
    for in_i in head_inputs:
        head_alllines[3]=head_alllines[3]+" "+in_i
    head_alllines[3]=head_alllines[3]+"\n"

    head_alllines.append(".ob")
    for out_i in head_outputs:
        head_alllines[4]=head_alllines[4]+" "+out_i
    head_alllines[4]=head_alllines[4]+"\n"

    f=open(in_path,'w') #write *.in

    for eachline in head_alllines: #read *.head
        f.write(eachline)

    rows=len(signal_vals)
    for row in range(rows):
        inp1=[]
        inp2=[]

        input_comb=[]  #input is list and output is list  in database
        for input_arg_name in input_args:
             input_arg_name_key=find_dic_nearest_key(input_arg_name+"_i",dic)
             #print input_arg_name,input_arg_name_key,row
             input_comb=input_comb+dic[input_arg_name_key][row]

        inp1=inp1+input_comb
        inp2=inp2+inp1

        val=signal_vals[row]
        val_len=len(val)
        print row,inp1,val

        out_str1=str(val[val_len-position-1])
        out_str2=""

        #if out_str1 not in ["0","1"]:
        if out_str1 not in ["0","1","-"]:
            if out_str1 in inp1: #map field disassemble
                i=inp1.index(out_str1)
                inp1[i]="1"
                inp2[i]="0"
                out_str1="1"
                out_str2="0"
            #elif out_str1=="-":
            #    out_str1="0" #output signal converts "x" value to "0" value 
            else:
                print "Error: ouput signal "+signal_name+" value "+out_str1+" is not valid." 
                sys.exit()   

        #list inp1/2 to str in_str1/2
        in_str1=""
        in_str2=""
        for n in range(len(inp1)):
            if inp1[n] not in  ["0","1","-"]:
                inp1[n]="-"
            in_str1=in_str1+inp1[n]

            if inp2[n] not in  ["0","1","-"]:
                inp2[n]="-"
            in_str2=in_str2+inp2[n]

        out1=in_str1+" "+out_str1
	print row,out1
        f.write(out1+"\n")

        if out_str2!="":
            out2=in_str2+" "+out_str2
            f.write(out2+"\n")
            print row,out2

    f.write(".e\n")
    f.close()
    print "Done\n"

 
def gen_signal_by_range(dic,in_dir_o,signal_name,start,end,input_args):
    range1=range(start,end+1) 
 
    for i in range1:
        if start==0 and end==0:
            new_signal_name=signal_name
        else: 
            new_signal_name=signal_name+"["+str(i)+"]" 
 
        if in_dir_o[-1]=="/":
            in_dir_o=in_dir_o[:-1]
        in_path=in_dir_o+"/"+new_signal_name+".in"

 
        gen_signal_by_bit(dic,in_path,signal_name,i,input_args) 


