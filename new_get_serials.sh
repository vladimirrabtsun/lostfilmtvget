# Переменные TMP1 и TMP2 участвуют при скрепинге.
TMP1=tmp.1
TMP2=tmp.2
# Вспомогательные переменные.
null_eq=0
true_argument=1
false_argument=0
# Переменные для логов.
llast=last_get.log
lall=all_get.log
# Ссылка на RSS-ку.
lfrss="http://www.lostfilm.tv/rssdd.xml"
# Куки для запроса RSS-ки.
lfcookie="Cookie: _ga=GA1.2.1172720830.1460950075; _gat=1; _ym_isad=2; _ym_uid=1460950075248392930; _ym_visorc_5681512=w; lnk_uid=95d4f4b893a5be0fd044052e4ab61dad; pass=c1590eb43b93eef263dbbb18bff69adc; phpbb2mysql_data=a%3A2%3A%7Bs%3A11%3A%22autologinid%22%3Bs%3A32%3A%22b129187c8bc7e421477dcd2c578bdda0%22%3Bs%3A6%3A%22userid%22%3Bs%3A7%3A%224721761%22%3B%7D; uid=4762870"
ua="Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)"
# Директория, которую наблюдает Transmission-Daemon, на наличие новых *.torrent-файлов.
WDIR=~/Downloads/torrents_lostfilm_tv
# Чистим последний лог.
if [ -f $llast ]; then
        rm $llast
fi
# Качаем RSS.
# [LOG] Логирование события.
ls1t=`date`
ls1ts=`date +%s`
ls1m="Загрузка RSS с адреса: $lfrss"
echo $ls1m
echo "$ls1t"" (""$ls1ts""): ""$ls1m" > $llast
/usr/bin/wget -O $TMP1 $lfrss
# Проверяем, состоялась ли загрузка RSS-ки.
if [ ! -f $TMP1 ]; then
	# [LOG] Логирование события.
	ls2t=`date`
	ls2ts=`date +%s`
	ls2m="[ERROR] Ошибка (Код ). Загрузка RSS не состоялась ($lfrss)"
	echo $ls2m
	echo "$ls2t"" (""$ls2ts""): ""$ls2m" >> $llast
	echo "----------------------------------------" >> $lall
	cat $llast >> $lall
	# Выход из программы.
	exit
else
	# [LOG] Логирование события.
	ls2t=`date`
	ls2ts=`date +%s`
	ls2m="[OK] Загрузка RSS состоялась успешно ($lfrss)"
	echo $ls2m
	echo "$ls2t"" (""$ls2ts""): ""$ls2m" >> $llast
fi
# Ищем ссылки в RSS-ке, берем только те, в которых присутсвует обозначение: 1080p.
cat $TMP1 | grep -ioe 'http.*torrent'| grep -ie '1080p' > $TMP2
# Вносим результат в массив, берем только те ссылки, в которых присутсвуют названия только определенных сериалов.
declare -a sc
sc=(`cat $TMP2 | grep -ie '\(Fear.the.Walking.Dead\|Penny.Dreadful\|Mr.Robot\|The.Walking.Dead\|The.X-Files\|Person.of.Interest\)' | tr '\n' ' '`)
qty_of_listed=`echo ${#sc[@]}`
if [ $qty_of_listed -eq 0 ]; then
	# [LOG] Логирование события.
	ls3t=`date`
	ls3ts=`date +%s`
	ls3m="[OK] Искомых сериалов среди новых не найдено (qty_of_listed="$qty_of_listed")"
	echo $ls3m
	echo "$ls3t"" (""$ls3ts""): ""$ls3m" >> $llast
	echo "----------------------------------------" >> $lall
	cat $llast >> $lall
	# Выход из программы.
	exit
else
	# [LOG] Логирование события.
	ls3t=`date`
	ls3ts=`date +%s`
	ls3m="[OK] Среди новых сериалов найдены искомые (qty_of_listed=""$qty_of_listed"")"
	echo $ls3m
	echo "$ls3t"" (""$ls3ts""): ""$ls3m" >> $llast
fi
# Т.к. количество найденных ссылок может быть более одной, запускаем цикл, для каждой.
for one_of in ${sc[@]} ; do
# Определяем номер созона и номер серии.
cur_sc=`echo $one_of | grep -oE '\S[[:digit:]]{1,2}\E[[:digit:]]{1,2}'`
ser_s_1_2=$(echo $cur_sc | cut -c 2-3)
ser_s_1=$(echo $cur_sc | cut -c 2-2)
ser_s_2=$(echo $cur_sc | cut -c 3-3)
ser_e_1_2=$(echo $cur_sc | cut -c 5-6)
ser_e_1=$(echo $cur_sc | cut -c 5-5)
ser_e_2=$(echo $cur_sc | cut -c 6-6)
if [ "$ser_s_1" = "$null_eq" ]; then
	ser_s_post=$ser_s_2
else
	ser_s_post=$ser_s_1_2
fi
ser_s_selected=0
if [ -e "$ser_s_post" ]; then
	# [LOG] Логирование события.
	ls4t=`date`
	ls4ts=`date +%s`
	ls4m="[ERROR] Ошибка (Код ). Переменная ser_s_post не назначена."
	echo $ls4m
	echo "$ls4t"" (""$ls4ts""): ""$ls4m" >> $llast
else
	ser_s_selected=1
	# [LOG] Логирование события.
	ls4t=`date`
        ls4ts=`date +%s`
        ls4m="[OK] Определение номера сезона сериала: ser_s_post = $ser_s_post"
	echo $ls4m
        echo "$ls4t"" (""$ls4ts""): ""$ls4m" >> $llast
fi
if [ "$ser_e_1" = "$null_eq" ]; then
	ser_e_post=$ser_e_2
else
	ser_e_post=$ser_e_1_2
fi
ser_e_selected=0
if [ -e "$ser_e_post" ]; then
	# [LOG] Логирование события.
	ls5t=`date`
	ls5ts=`date +%s`
	ls5m="[ERROR] Ошибка (Код:4). Переменная ser_e_post не назначена."
        echo $ls5m
        echo "$ls5t"" (""$ls5ts""): ""$ls5m" >> $llast
else
        # [LOG] Логирование события.
	ser_e_selected=1
        ls5t=`date`
        ls5ts=`date +%s`
        ls5m="[OK] Определение номера серии сериала: ser_e_post = $ser_e_post"
	echo $ls5m
        echo "$ls5t"" (""$ls5ts""): ""$ls5m" >> $llast
fi
# Определяем наименование сериала и его порядковый номер на lostfilm.tv.
ser_name=`echo $one_of | grep -oie '\(Fear.the.Walking.Dead\|Penny.Dreadful\|Mr.Robot\|The.Walking.Dead\|The.X-Files\|Person.of.Interest\)'`
# [LOG] Логирование события.
ls6t=`date`
ls6ts=`date +%s`
ls6m="[OK] Определение наименования сериала: ser_name = $ser_name"
echo $ls6m
echo "$ls6t"" (""$ls6ts""): ""$ls6m" >> $llast
# Список соответствия номера категории и наименования сериала.
ser_name_c_252="Fear.the.Walking.Dead"
ser_name_c_210="Penny.Dreadful"
ser_name_c_245="Mr.Robot"
ser_name_c_134="The.Walking.Dead"
ser_name_c_270="The.X-Files"
ser_name_c_159="Person.of.Interest"
# Назначение номера категории и наименования на русском языке для сериала.
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
	# [LOG] Логирование события.
	ls7t=`date`
	ls7ts=`date +%s`
	ls7m=echo "[ERROR] Ошибка (Код:1). Некорректное значение переменной ser_name."
	echo $ls7m
	echo "$ls7t"" (""$ls7ts""): ""$ls7m" >> $llast
fi
# [LOG] Логирование события.
ls7t=`date`
ls7ts=`date +%s`
ls7m="[OK] Определение наименования (рус.) и порядкового номера сериала: ser_name_rus = $ser_name_rus , ser_c=$ser_c"
echo $ls7m
echo "$ls7t"" (""$ls7ts""): ""$ls7m" >> $llast
ser_c_selected=0
if [ -e "$ser_c" ]; then
	# [LOG] Логирование события.
	ls8t=`date`
	ls8ts=`date +%s`
	ls8m="[ERROR] Ошибка (Код:2). Переменная ser_c не назначена."
	echo $ls8m
	echo "$ls8t"" (""$ls8ts""): ""$ls8m" >> $llast
else
	ser_c_selected=1
	# [LOG] Логирование события.
	ls8t=`date`
        ls8ts=`date +%s`
        ls8m="[OK] Определение порядкового номера сериала: ser_c = $ser_c ($ser_name)"
        echo $ls8m
        echo "$ls8t"" (""$ls8ts""): ""$ls8m" >> $llast
fi
# Проверка на наличие агрументов для формировании ссылки.
ready_to_gen_link=0
if [ "$ser_c_selected" = "$true_argument" ]; then
	if [ "$ser_s_selected" = "$true_argument" ]; then
		if [ "$ser_e_selected" = "$true_argument" ]; then
			ready_to_gen_link=1
			# [LOG] Логирование события.
        		ls8t=`date`
        		ls8ts=`date +%s`
        		ls8m="[OK] Все переменные назначены."
			echo $ls8m
        		echo "$ls8t"" (""$ls8ts""): ""$ls8m" >> $llast
		else
			# [LOG] Логирование события.
                        ls8t=`date`
                        ls8ts=`date +%s`
                        ls8m="[ERROR] Ошибка (Код:8). Переменная ser_e_selected не удовлетворяет требованиям."
                        echo $ls8m
                        echo "$ls8t"" (""$ls8ts""): ""$ls8m" >> $llast
		fi
	else
		# [LOG] Логирование события.
                ls8t=`date`
                ls8ts=`date +%s`
                ls8m="[ERROR] Ошибка (Код:7). Переменная ser_s_selected не удовлетворяет требованиям."
                echo $ls8m
                echo "$ls8t"" (""$ls8ts""): ""$ls8m" >> $llast
	fi
else
	# [LOG] Логирование события.
        ls8t=`date`
        ls8ts=`date +%s`
        ls8m="[ERROR] Ошибка (Код:6). Переменная ser_c_selected не удовлетворяет требованиям."
        echo $ls8m
        echo "$ls8t"" (""$ls8ts""): ""$ls8m" >> $llast
fi
# Формируем ссылку на промежуточную страницу для загрузки торрент-файлов, передавая атрибуты: c, s и e.
if [ "$ready_to_gen_link" = "$true_argument" ]; then
	link_to_dl_page_stage="https://lostfilm.tv/nrdr2.php?c=$ser_c&s=$ser_s_post&e=$ser_e_post"
	# [LOG] Логирование события.
        ls9t=`date`
        ls9ts=`date +%s`
        ls9m="[OK] Определение страницы с ссылками для загрузки: $link_to_download_page"
        echo $ls9m
        echo "$ls9t"" (""$ls9ts""): ""$ls9m" >> $llast
else
	# [LOG] Логирование события.
        ls9t=`date`
        ls9ts=`date +%s`
        ls9m="Ошибка (Код:5). Неопредены необходимые переменные."
        echo $ls9m
        echo "$ls9t"" (""$ls9ts""): ""$ls9m" >> $llast
fi
# Загружаем промежуточную страницу.
/usr/bin/wget -O dl_page_stage.tmp $link_to_dl_page_stage --user-agent="$ua" --no-cookies --header="$lfcookie" $l
if [ ! -f dl_page_stage.tmp ]; then
	# [LOG] Логирование события.
	ls10t=`date`
        ls10ts=`date +%s`
        ls10m="[ERROR] Ошибка (Код:) Не найден файл dl_page_stage.tmp."
        echo $ls10m
        echo "$ls10t"" (""$ls10ts""): ""$ls10m" >> $llast
else
	# [LOG] Логирование события.
	ls10t=`date`
        ls10ts=`date +%s`
        ls10m="[OK] Файл dl_page_stage.tmp успешно загружен."
        echo $ls10m
        echo "$ls10t"" (""$ls10ts""): ""$ls10m" >> $llast
fi
# Формируем ссылку на финальную страницу.
link_to_dl_page_final=$(cat dl_page_stage.tmp | grep -ie 'location.replace("http://retre.org' | grep -ioe '(".*")' | cut -c 3- | rev | cut -c 3- | rev)
# Проверяем наличие финальной ссылки.
if [ -e "$link_to_dl_page_final" ]; then
        # [LOG] Логирование события.
        ls11t=`date`
        ls11ts=`date +%s`
        ls11m="[ERROR] Ошибка (Код:9). Переменная link_to_dl_page_final не назначена."
        echo $ls11m
        echo "$ls11t"" (""$ls11ts""): ""$ls11m" >> $llast
else
        # [LOG] Логирование события.
        ls11t=`date`
        ls11ts=`date +%s`
        ls11m="[OK] Определение ссылки: link_to_dl_page_final=$link_to_dl_page_final"
        echo $ls11m
        echo "$ls11t"" (""$ls11ts""): ""$ls11m" >> $llast
fi
# Загружаем финальную страницу.
/usr/bin/wget -O dl_page_final.tmp $link_to_dl_page_final --user-agent="$ua" --no-cookies --header="$lfcookie" $l
if [ ! -f page_final.tmp ]; then
        # [LOG] Логирование события.
        ls12t=`date`
        ls12ts=`date +%s`
        ls12m="[ERROR] Ошибка (Код:) Не найден файл page_final.tmp."
        echo $ls12m
        echo "$ls12t"" (""$ls12ts""): ""$ls12m" >> $llast
else
        # [LOG] Логирование события.
        ls12t=`date`
        ls12ts=`date +%s`
        ls12m="[OK] Файл page_final.tmp успешно загружен."
        echo $ls12m
        echo "$ls12t"" (""$ls12ts""): ""$ls12m" >> $llast
fi
# Определяем ссылку для загрузки торрент-файла.
if [ "$ser_name" = "$ser_name_c_210" ];then
link_to_dl_torrent=$(cat dl_page_final.tmp | grep -m1 -ie '1080p WEBRip.' -A 1 | grep -ioe '<a href=".*" ' | cut -c 10- | rev | cut -c 3- | rev)
else
link_to_dl_torrent=$(cat dl_page_final.tmp | grep -ie '1080p WEB-DLRip\.' -A 1 | grep -ioe '<a href=".*" ' | cut -c 10- | rev | cut -c 3- | rev)
fi
if [ -e $link_to_dl_torrent ]; then
        # [LOG] Логирование события.
        ls13t=`date`
        ls13ts=`date +%s`
        ls13m="[ERROR] Ошибка (Код:) Не определена переменная link_to_dl_torrent"
        echo $ls13m
        echo "$ls13t"" (""$ls13ts""): ""$ls13m" >> $llast
else
        # [LOG] Логирование события.
        ls13t=`date`
        ls13ts=`date +%s`
        ls13m="[OK] Определена переменная link_to_dl_torrent=$link_to_dl_torrent"
        echo $ls13m
        echo "$ls13t"" (""$ls13ts""): ""$ls13m" >> $llast
fi
# Формируем файл с информацией о ссылке и наименовании торрент-файла, а также о наименовании, сезоне и серии сериала.
echo "$link_to_dl_torrent"";""$ser_name""-""$ser_c""-""$ser_s_post""-""$ser_e_post"".torrent"";""$ser_name_rus"".(cезон.""$ser_s_post"".серия.""$ser_e_post"")" >> list_to_download.tmp
# Удаляем файлы промежуточной и финальной страниц, т.к. в следующем цикле они изменятся.
rm dl_page_stage.tmp
rm dl_page_final.tmp
done
# Загрузка торрент-файлов и отправка сообщения о наличии новых серий.
for l in `cat list_to_download.tmp`
do
# Забираем ссылку для загрузки торрент-файла.
tor_link=`echo $l | cut -d';' -f1`
# Забираем название торрент-файла.
tor_name=`echo $l | cut -d';' -f2`
# Забираем наименование сериала на русском языке, номер сезона и номер серии.
tor_name_msg=`echo $l | cut -d';' -f3`
# Проверяем наличие файла в директории, на которую смотрит Transmission-Daemon.
if [ ! -f $WDIR/$tor_name ]
then
# Загружаем торрент-файл.
/usr/bin/wget -nc -O $tor_name $tor_link
# Передаем информацию о новой серии в файл, для последующего уведомления на почту.
echo $tor_name_msg >> downloaded_to_mail
# Перемещаем загруженный торрент-файл в директорию, на которую смотрит Transmission-Daemon.
mv $tor_name $WDIR
else
echo "Файл $tor_name уже существует в $WDIR"
fi
done
# Посылаем уведомление о нывых сериях на почту.
if [ -f downloaded_to_mail ]
then
# Получаем количество новых серий.
ser_col=`wc -l downloaded_to_mail | cut -d ' ' -f1`
# Реквизиты для отправки уведомления на почту.
SERVER="followmortimer.com:25"
FROM="alert@followmortimer.com"
TO="vladimir.rabtsun@gmail.com,wolf_159@mail.ru"
MSG=`cat downloaded_to_mail`
SUB="Новые серии: ""$ser_col"
xu=alert@followmortimer.com
xp=lostfilmalert
# Отправка сообщения.
sendEmail -xu $xu -xp $xp -f $FROM -t $TO -u $SUB -m $MSG -s $SERVER
fi
# Удаляем временные файлы.
rm list_to_download.tmp
rm downloaded_to_mail
