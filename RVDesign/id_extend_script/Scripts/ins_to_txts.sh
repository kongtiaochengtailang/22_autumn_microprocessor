#!/bin/bash


#main
args=`getopt -o "" -l in_dir_i:,txt_dir_o: -- $@`
eval set -- "$args"

while true
do
    case $1 in
        "--in_dir_i")
            case $2 in
                "")
                    in_dir_i=""
                    shift
                    ;;
                *)
                    in_dir_i=$2
                    shift
                    ;;
            esac
            ;;
        "--txt_dir_o")
            case $1 in
                "")
                    txt_dir_o=""
                    shift
                    ;;
                *)
                    txt_dir_o=$2
                    shift
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Option Input Error!!!"
            echo "Please Input: sh ins_to_txts.sh --in_dir_i xx --txt_dir_o xx"
            exit
            ;;
    esac
    shift
done

for in_path_i in `ls ${in_dir_i}/*.in`
do
    sh ./in_to_txt.sh --in_path_i=$in_path_i --txt_dir_o=$txt_dir_o
done
