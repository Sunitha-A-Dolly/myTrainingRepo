installSoftware(){
    yum install $1 -y &>> $LOGFILE
    systemctl enable $1 &>> $LOGFILE
    systemctl start $1 &>> $LOGFILE
}

checkUser(){
    USER_ID=$(id -u)
echo $USER_ID
if [ $USER_ID -ne 0 ] ; then
    echo "You need to be a root user"
    exit 1
fi
}

stat(){
    if [ $1 -eq 0 ] ; then
        echo "Success"
    else
        echo "Failure"
    fi
}