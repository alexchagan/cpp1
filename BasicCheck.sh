#!/bin/bash

#script arguments
dirpath=$1
program=$2
args=$3
#trash="/dev/null"
currentLocation='pwd'
tests=(1 1 1)




cd "$dirpath"

make &> /dev/null

#check if the program compiles

if [[ $? -gt 0 ]]; then
   COMPILATION="FAIL"
   MEMLEAK="FAIL"
   THREADS="FAIL"



echo "$COMPILATION $MEMLEAK $THREADS"

exit 7
fi



  COMPILATION="PASS"
   tests[0]=0


#valgring  memleak check

valgrind --leak-check=full --error-exitcode=1 ./$program $args &> /dev/null
valgrind_out=$?
if [[ $valgrind_out -eq 0 ]]; then
MEMLEAK="PASS"
tests[1]=0
else
   MEMLEAK="FAIL"
   fi

#helgrind check

valgrind --tool=helgrind --error-exitcode=1 ./$program $args &> /dev/null
helgrind_out=$?
if [[ $helgrind_out -eq 0 ]]; then
THREADS="PASS"
tests[2]=0
else
   THREADS="FAIL"
   fi

#print the results

echo "$COMPILATION $MEMLEAK $THREADS"

exit_value=$((tests[1]*2+tests[2]))

exit $exit_value


