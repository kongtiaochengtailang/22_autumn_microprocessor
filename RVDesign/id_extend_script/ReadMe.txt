step1：在Tables/Decode.xls中添加新增指令在译码阶段的输入-输出对应关系,每个信号的可能值含义参考自AdamRiscv/ctrl.v模块；
step2：将上表保存，并另存一份csv格式的到目录Tables/下，即Tables/Decode.csv；
step3：运行脚本，将表格内容转换成RTL，并插入到代码中。其中，脚本运行命令为“sh run.sh xx_dir/micro-processor-course-2022/RVDesign/AdamRiscv”
