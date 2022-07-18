installSoftware(){
    yum install $1 -y
    systemctl enable $1
    systemctl start $1
}

checkUser(){
    USER_ID=$(id -u)
echo $USER_ID
if [ $USER_ID -ne 0 ] ; then
    echo "You need to be a root user"
    exit 1
fi
}

checkStatus(){
    if [ $1 eq 0] ; them
        echo "Success"
    else
        echo "Failure"
    fi
}