for i in `ls`; do
    if [ -d $i ]
    then 
	echo $i
        cp  $i/img/* img
    else
        echo "haha"
    fi  
done
