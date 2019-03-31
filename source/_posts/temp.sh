for i in `ls`; do
    if [ -d $i ]
    then 
	echo $i
        rm -rf  $i
    else
        echo "haha"
    fi  
done
