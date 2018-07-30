#!/bin/bash
# Assumptions:
# 1: The sample record given is a list of event of a customer. This can be a huge datadump in JSON format.
# 2: To Writing this script to split the file into multple splits and then process upto 500 files.

# input_files:  /Users/tonys/PycharmProjects/shutterfly/input/input.txt
# landing_files:  /Users/tonys/PycharmProjects/shutterfly/split_files/segment
# No_of_splits: eg: 500


if [ -z $1 ] || [ -z $2 ]
   then
     echo "No arguments supplied; please pass number of splits  and input filename as arg1, arg2"
 else
     echo "The script started processing at "`date +"%d/%m/%Y %H:%M:%S"`
fi

export project_dir='/Users/tonys/PycharmProjects/shutterfly'
export split_file=${project_dir}'/split_files'
export no_of_splits=$1
export input_file=${project_dir}'/input/'$2
export landing_files=${split_file}/'segment'
export python_job=${project_dir}'/src/json_parser.py'
export land_dir=${project_dir}'/land/'
export output_dir=${project_dir}'/output/'


#remove the previous day files:

rm -f  ${landing_files}*
rm -f ${output_dir}*

#split files with number of lines

split -l ${no_of_splits} ${input_file} ${landing_files}

#rename the splits to *.txt
for each  in `ls ${landing_files}*`
do
mv $each $each.txt
done

#passthe json parson job to  parse the input data; 500 is the number of parallel execution

find ${split_file} -type f -name "*.txt" -print0 | xargs -0 -L1 -P 500 python ${python_job}

#Merge each process files into single output data feeds for loading into hive/ rdbms
find ${land_dir} -type f -name "*cust*" -exec cat {} + > ${output_dir}customers.txt
find ${land_dir} -type f -name "*clck*" -exec cat {} + > ${output_dir}/click.txt
find ${land_dir} -type f -name "*ordr*" -exec cat {} + > ${output_dir}/orders.txt

