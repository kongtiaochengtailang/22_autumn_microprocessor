#!/bin/bash

function orth_check(){
    in_path=$1
    basename=${in_path##*/}
    prename=${basename%.*}

    python ./orth.py $in_path > log_${prename}_orth
    
    if test -s log_${prename}_orth; then
         echo "ORTH FALSE ---- file: "$1" ON-set and OFF-set are not orthogonal."
         exit
    else 
         echo "ORTH TRUE  ---- file: "$1" orth check done"
         rm log_${prename}_orth
    fi
}

function in_to_txt(){
    in_path_i=$1
    txt_dir_o=$2
    in_file_basename=${in_path_i##*/}
    in_file_prename=${in_file_basename%.*}
    txt_path=${txt_dir_o}/${in_file_prename}.txt

    echo "-----------------------------------------------------------------------------------------"
    if [ ! -d $txt_dir_o ]; then
        echo "The dir $txt_dir_o is not exist."
        exit
    fi

    if [ ! -f $in_path_i ]; then
        echo "The file $in_path_i is not exist."
        exit
    fi

    echo "Begin orthogonal check"
    orth_check $in_path_i
    echo "Done"
    echo ""
    
    echo "Begin to generate RTL(*.txt)"
    ./espresso -o eqntott $in_path_i > $txt_path
    echo "gen ${txt_path}"

    all_out_signal_names=(`cat ${in_path_i} | sed -n 5p`)
    all_out_signal_names=${all_out_signal_names[@]:1}
    for out_signal_name in $all_out_signal_names
    do
        out_signal_name=${out_signal_name%\[*}
        sed -i "s/^${out_signal_name}/assign ${out_signal_name}/g" $txt_path
    done

    sed -i "s/= ;$/= 1'b0 ;/g" $txt_path
    echo "Done"
    echo ""
}


#main
args=`getopt -o "" -l in_path_i:,txt_dir_o: -- $@`
eval set -- "$args"

while true
do
    case $1 in
        "--in_path_i")
            case $2 in
                "")
                    in_path_i=""
                    shift
                    ;;
                *)
                    in_path_i=$2
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
            echo "Please Input: sh in_to_txt.sh --in_path_i xx --txt_dir_o xx"
            exit
            ;;
    esac
    shift
done

in_to_txt $in_path_i $txt_dir_o
