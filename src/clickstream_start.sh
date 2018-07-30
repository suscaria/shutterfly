#!/bin/bash
# Assumptions:
# 1: The sample record given is a list of event of a customer. This can be a huge datadump in JSON format.
# 2: To Writing this script to split the file into multple splits and then process upto 500 files.

# input_files:  /Users/tonys/PycharmProjects/shutterfly/input/input.txt 
# landing_files:  /Users/tonys/PycharmProjects/shutterfly/land/
# No_of_splits: eg: 500


if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]
   then
     echo "No arguments supplied; please pass filename and number of splits as arg1 and arg2"
 else
     echo "The script started processing at "`date +"%d/%m/%Y %H:%M:%S"`
 fi

export input_file=$1
export landing_files=$2
export no_of_splits=$3
export archive_dir=${landing_files}'/archive/'

# find ${landing_files} -name "*txt*" -print0 | xargs -0 -I {} mv {} $archive_dir

split -l $no_of_splits $input_file $output_files

for each  in `ls $output_files*`
do
mv $each $each.txt
done

find /Users/tonys/PycharmProjects/shutterfly/land/ -type f -name "*.txt" -print0 | xargs -0 -L1 -P 500 python /Users/tonys/PycharmProjects/shutterfly/src/json_parser.py

find /Users/tonys/PycharmProjects/shutterfly/land/ -type f -name "*cust*" -exec cat {} + > /Users/tonys/PycharmProjects/shutterfly/output/customers.txt
find /Users/tonys/PycharmProjects/shutterfly/land/ -type f -name "*clck*" -exec cat {} + > /Users/tonys/PycharmProjects/shutterfly/output/click.txt
find /Users/tonys/PycharmProjects/shutterfly/land/ -type f -name "*ordr*" -exec cat {} + > /Users/tonys/PycharmProjects/shutterfly/output/orders.txt