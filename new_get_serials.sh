TMP1=tmp.1
TMP2=tmp.2
#TMP3=tmp.3
lfrss="http://www.lostfilm.tv/rssdd.xml"
lfcookie="Cookie: _ga=GA1.2.1172720830.1460950075; _gat=1; _ym_isad=2; _ym_uid=1460950075248392930; _ym_visorc_5681512=w; lnk_uid=95d4f4b893a5be0fd044052e4ab61dad; pass=c1590eb43b93eef263dbbb18bff69adc; phpbb2mysql_data=a%3A2%3A%7Bs%3A11%3A%22autologinid%22%3Bs%3A32%3A%22b129187c8bc7e421477dcd2c578bdda0%22%3Bs%3A6%3A%22userid%22%3Bs%3A7%3A%224721761%22%3B%7D; uid=4762870"
ua="Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)"
# Каталог, который наблюдает transmission
WDIR=~/Downloads/torrents_lostfilm_tv
# Качаем RSS
/usr/bin/wget -O $TMP1 $lfrss
# Качать только avi
cat $TMP1 | grep -ioe 'http.*torrent'| grep -ie '1080p' > $TMP2
##########
#update 1

declare -a sc
sc=(`cat $TMP2 | grep -ie '\(Fear.the.Walking.Dead\|Penny.Dreadful\|Mr.Robot\|The.Walking.Dead\|The.X-Files\|Person.of.Interest\)' | tr '\n' ' '`)

# Определяем номер созона и номер серии.

for one_of in ${sc[@]} ; do

cur_sc=`echo $one_of | grep -oE '\S[[:digit:]]{1,2}\E[[:digit:]]{1,2}'`

ser_s_1_2=$(echo $cur_sc | cut -c 2-3)
ser_s_1=$(echo $cur_sc | cut -c 2-2)
ser_s_2=$(echo $cur_sc | cut -c 3-3)
ser_e_1_2=$(echo $cur_sc | cut -c 5-6)
ser_e_1=$(echo $cur_sc | cut -c 5-5)
ser_e_2=$(echo $cur_sc | cut -c 6-6)

echo "[DEBUG] ser_s_1_2= $ser_s_1_2" #отдадка
echo "[DEBUG] ser_s_1= $ser_s_1" #отдадка
echo "[DEBUG] ser_s_2= $ser_s_2" #отдадка
echo "[DEBUG] ser_e_1_2= $ser_e_1_2" #отладка
echo "[DEBUG] ser_e_1= $ser_e_1" #отдадка
echo "[DEBUG] ser_e_2= $ser_e_2" #отдадка



null_eq=0
if [ "$ser_s_1" = "$null_eq" ]; then
	ser_s_post=$ser_s_2
else
	ser_s_post=$ser_s_1_2
fi

#echo "[DEBUG] ser_s_post= $ser_s_post" #отладка

ser_s_selected=0
if [ -e "$ser_s_post" ]; then
	echo "[ERROR] Ошибка (Код:3). Переменная ser_s_post не назначена."
else
	ser_s_selected=1
	echo "[OK] Определение номера сезона сериала: ser_s_post = $ser_s_post"
fi


if [ "$ser_e_1" = "$null_eq" ]; then
	ser_e_post=$ser_e_2
else
	ser_e_post=$ser_e_1_2
fi

#echo "[DEBUG] ser_e_post= $ser_e_post"

ser_e_selected=0
if [ -e "$ser_e_post" ]; then
        echo "[ERROR] Ошибка (Код:4). Переменная ser_e_post не назначена."
else
        ser_e_selected=1
        echo "[OK] Определение номера серии сериала: ser_e_post = $ser_e_post"
fi


# Определяем наименование сериала и его порядковый номер на lostfilm.tv
ser_name=`echo $one_of | grep -oie '\(Fear.the.Walking.Dead\|Penny.Dreadful\|Mr.Robot\|The.Walking.Dead\|The.X-Files\|Person.of.Interest\)'`

ser_name_c_252="Fear.the.Walking.Dead"
ser_name_c_210="Penny.Dreadful"
ser_name_c_245="Mr.Robot"
ser_name_c_134="The.Walking.Dead"
ser_name_c_270="The.X-Files"
ser_name_c_159="Person.of.Interest"

if [ "$ser_name" = "$ser_name_c_252" ]; then
	ser_c=252
	ser_name_rus="Бойтесь.ходячих.мертвецов"
elif [ "$ser_name" = "$ser_name_c_210" ]; then
        ser_c=210
        ser_name_rus="Бульварные.ужасы"
elif [ "$ser_name" = "$ser_name_c_245" ]; then
	ser_c=245
	ser_name_rus="Мистер.Робот"
elif [ "$ser_name" = "$ser_name_c_134" ]; then
	ser_c=134
	ser_name_rus="Ходячие.мертвецы"
elif [ "$ser_name" = "$ser_name_c_270" ]; then
	ser_c=270
	ser_name_rus="Секретные.материалы"
elif [ "$ser_name" = "$ser_name_c_159" ]; then
	ser_c=159
	ser_name_rus="Подозреваемый"
else
	echo "[ERROR] Ошибка (Код:1). Некорректное значение переменной ser_name."
fi



ser_c_selected=0

if [ -e "$ser_c" ]; then
	echo "[ERROR] Ошибка (Код:2). Переменная ser_c не назначена."
else
	ser_c_selected=1
	echo "[OK] Определение порядкового номера сериала: ser_c = $ser_c ($ser_name)"
fi

ready_to_gen_link=0
true_argument=1
false_argument=0

if [ "$ser_c_selected" = "$true_argument" ]; then
	if [ "$ser_s_selected" = "$true_argument" ]; then
		if [ "$ser_e_selected" = "$true_argument" ]; then
			ready_to_gen_link=1
			echo "[OK] Все переменные назначены."
		else
			echo "[ERROR] Ошибка (Код:8). Переменная ser_e_selected не удовлетворяет требованиям."
		fi
	else
		echo "[ERROR] Ошибка (Код:7). Переменная ser_s_selected не удовлетворяет требованиям."
	fi
else
	echo "[ERROR] Ошибка (Код:6). Переменная ser_c_selected не удовлетворяет требованиям."
fi

# Формируем ссылку на страницу для загрузки торрент-файлов, передавая атрибуты: c, s и e.
if [ "$ready_to_gen_link" = "$true_argument" ]; then
	link_to_dl_page_stage="https://lostfilm.tv/nrdr2.php?c=$ser_c&s=$ser_s_post&e=$ser_e_post"
	echo "[OK] Определение страницы с ссылками для загрузки: $link_to_download_page"
else
	echo "Ошибка (Код:5). Неопредены необходимые переменные."
fi

/usr/bin/wget -O dl_page_stage.tmp $link_to_dl_page_stage --user-agent="$ua" --no-cookies --header="$lfcookie" $l

link_to_dl_page_final=$(cat dl_page_stage.tmp | grep -ie 'location.replace("http://retre.org' | grep -ioe '(".*")' | cut -c 3- | rev | cut -c 3- | rev)

#echo "[DEBUG] link_to_dl_page_final=$link_to_dl_page_final" # Отладка

if [ -e "$link_to_dl_page_final" ]; then
	echo "[ERROR] Ошибка (Код:9). Переменная link_to_dl_page_final не назначена."
else
	echo "[OK] Определение ссылки: link_to_dl_page_final=$link_to_dl_page_final"
fi

lfrss1=$link_to_dl_page_final

/usr/bin/wget -O dl_page_final.tmp $lfrss1 --user-agent="$ua" --no-cookies --header="$lfcookie" $l

if [ "$ser_name" = "$ser_name_c_210" ];then
link_to_dl_torrent=$(cat dl_page_final.tmp | grep -m1 -ie '1080p WEBRip.' -A 1 | grep -ioe '<a href=".*" ' | cut -c 10- | rev | cut -c 3- | rev)
else
link_to_dl_torrent=$(cat dl_page_final.tmp | grep -ie '1080p WEB-DLRip\.' -A 1 | grep -ioe '<a href=".*" ' | cut -c 10- | rev | cut -c 3- | rev)
fi
#echo "[DEBUG] link_to_dl_torrent=$link_to_dl_torrent" # Отладка


echo "$link_to_dl_torrent"";""$ser_name""-""$ser_c""-""$ser_s_post""-""$ser_e_post"".torrent"";""$ser_name_rus"".(cезон.""$ser_s_post"".серия.""$ser_e_post"")" >> list_to_download.tmp
rm dl_page_stage.tmp
rm dl_page_final.tmp
done


##########

for l in `cat list_to_download.tmp`
do
tor_link=`echo $l | cut -d';' -f1`
tor_name=`echo $l | cut -d';' -f2`
tor_name_msg=`echo $l | cut -d';' -f3`
if [ ! -f $WDIR/$tor_name ]
then
echo !!! download $tor_name
/usr/bin/wget -nc -O $tor_name $tor_link
echo $tor_name_msg >> downloaded_to_mail
mv $tor_name $WDIR

else
echo "Файл $tor_name уже существует в $WDIR"
fi
done

if [ -f downloaded_to_mail ]
then
ser_col=`wc -l downloaded_to_mail | cut -d ' ' -f1`
SERVER="followmortimer.com:25"
FROM="alert@followmortimer.com"
TO="vladimir.rabtsun@gmail.com"
MSG=`cat downloaded_to_mail`
SUB="Новые серии: ""$ser_col"
xu=alert@followmortimer.com
xp=lostfilmalert

sendEmail -xu $xu -xp $xp -f $FROM -t $TO -u $SUB -m $MSG -s $SERVER
fi

rm list_to_download.tmp
rm downloaded_to_mail
