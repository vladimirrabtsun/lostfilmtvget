for l in `cat list_to_download.tmp`
do

tor=`echo $l`

echo $tor | cut -d'*' -f1
echo $tor | cut -d'*' -f2
echo $tor | cut -d'*' -f3
#tor_link=`echo $l | cut -d';' -f1`
#tor_name=`echo $l | cut -d';' -f2`
#tor_name_msg=`echo $l | cut -d';' -f3`

#echo $tor_link
#echo $tor_name
#echo $tor_name_msg

done
