rm ../Decode/*

#generate .in file that includes truth-value table message
python csv_to_ins_dec.py --csv_path_i ../Tables/Decode.csv --in_dir_o ../Decode

#convert .in file to .txt file that includes assign logic
sh ins_to_txts.sh --in_dir_i ../Decode --txt_dir_o ../Decode

#merge .txt files to a .txt file
python txts_to_txt_by_signal_range.py --signal_name_i src1_sel --file_postfix_i .txt --in_dir_o ../Decode --start_i 0 --end_i 1
python txts_to_txt_by_signal_range.py --signal_name_i src2_sel --file_postfix_i .txt --in_dir_o ../Decode --start_i 0 --end_i 1

python txts_to_txt_by_signal_range.py --signal_name_i id_imm   --file_postfix_i .txt --in_dir_o ../Decode --start_i 0 --end_i 31

python txts_to_txt_by_signal_range.py --signal_name_i op_ctl   --file_postfix_i .txt --in_dir_o ../Decode --start_i 0 --end_i 31

#insert .txt file to specific .v file that includes Verilog code
sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i br              --txt_path_i ../Decode/br.txt
sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i mem_write       --txt_path_i ../Decode/mem_write.txt
sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i mem_read        --txt_path_i ../Decode/mem_read.txt
sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i regs_write      --txt_path_i ../Decode/regs_write.txt
sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i mem2reg         --txt_path_i ../Decode/mem2reg.txt

sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i br_addr_mode    --txt_path_i ../Decode/br_addr_mode.txt
sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i src1_sel        --txt_path_i ../Decode/src1_sel[1:0].txt
sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i src2_sel        --txt_path_i ../Decode/src2_sel[1:0].txt

sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i id_imm          --txt_path_i ../Decode/id_imm[31:0].txt

sh txt_to_vfile.sh --vfile_path_i ${1}/stage_id.v --inserted_signal_i op_ctl          --txt_path_i ../Decode/op_ctl[31:0].txt