#!/bin/bash

function txt_to_vfile(){
    vfile_path=$1
    inserted_signal=$2
    txt_path=$3

    echo "-----------------------------------------------------------------------------------------"
    echo "Begin to insert RTL logic(*.txt) to RTL code file(*.v/sv)"
    echo "insert "${txt_path}" to "$vfile_path "in the specific position "

    sed -i "/\/\/begin ${inserted_signal}/,/\/\/end ${inserted_signal}/{/\/\/begin ${inserted_signal}/!{/\/\/end ${inserted_signal}/!d}}" ${vfile_path}
    sed -i "/\/\/begin ${inserted_signal}/r ${txt_path}" $vfile_path

    sed "s/$//g" $vfile_path > tmp_vfile
    mv tmp_vfile $vfile_path

    echo "Done"
    echo ""
}


#main
args=`getopt -o "" -l vfile_path_i:,inserted_signal_i:,txt_path_i: -- "$@"`
eval set -- "$args"

while true
do
    case "$1" in
        --vfile_path_i)
            case $2 in
                "")
                    vfile_path_i=""
                    shift
                    ;;
                *)
                    vfile_path_i=$2
                    shift
                    ;;
            esac
            ;;
        --inserted_signal_i)
            case $2 in
                "")
                    inserted_signal_i=""
                    shift
                    ;;
                *)
                    inserted_signal_i=$2
                    shift
                    ;;
            esac
            ;;
        --txt_path_i)
            case $2 in
                "")
                    txt_path_i=""
                    shift
                    ;;
                *)
                    txt_path_i=$2
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
            exit
            ;;
    esac
    shift
done

txt_to_vfile $vfile_path_i $inserted_signal_i $txt_path_i
