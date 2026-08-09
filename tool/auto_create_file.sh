TOOL_DIR=`pwd`
WORK_DIR=`cd ..;echo $(pwd)`
echo TOOL_DIR: $TOOL_DIR
echo WORK_DIR: $WORK_DIR
FILE_NAME=`find $WORK_DIR -name "$1*" -printf "%f\n"`
"$SAKURA_EXE" "$FILE_NAME"

