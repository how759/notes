TRASH_DIR="/home/ssg-test/.trash"  
  
for i in $*; do  
    STAMP=`date +%N`  
    fileName=`basename $i`  
    mv $i $TRASH_DIR/$fileName.$STAMP 
    # echo $fileName 
done  
