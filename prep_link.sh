#update 1
# Забираем в файл selected.serials.tmp только искомые сериалы по названию.
cat tmp.2 | grep -ie '\(Fear.the.Walking.Dead\|Mr.Robot\|The.Walking.Dead\|The.X-Files\|Person.of.Interest\)' >> selected.serials.tmp

# Определяем номер созона и номер серии.
cat selected.serials.tmp | grep -m 1 -oE '\S[[:digit:]]{1,2}\E[[:digit:]]{1,2}' >> current.ses_ep.selected.serials.tmp

ser_s_1_2=$(cat current.ses_ep.selected.serials.tmp | cut -c 2-3)
ser_s_1=$(cat current.ses_ep.selected.serials.tmp | cut -c 2-2)
ser_s_2=$(cat current.ses_ep.selected.serials.tmp | cut -c 3-3)
ser_e_1_2=$(cat current.ses_ep.selected.serials.tmp | cut -c 5-6)
ser_e_1=$(cat current.ses_ep.selected.serials.tmp | cut -c 5-5)
ser_e_2=$(cat current.ses_ep.selected.serials.tmp | cut -c 6-6)

#echo "Отладка: ser_s_1_2= $ser_s_1_2" #отдадка
#echo "Отладка: ser_s_1= $ser_s_1" #отдадка
#echo "Отладка: ser_s_2= $ser_s_2" #отдадка
#echo "Отладка: ser_e_1_2= $ser_e_1_2" #отладка
#echo "Отладка: ser_e_1= $ser_e_1" #отдадка
#echo "Отладка: ser_e_2= $ser_e_2" #отдадка

null_eq=0
if [ "$ser_s_1" = "$null_eq" ]; then
	ser_s_post=$ser_s_2
else
	ser_s_post=$ser_s_1_2
fi

#echo "Отладка: ser_s_post= $ser_s_post" #отладка

ser_s_selected=0
if [ -e "$ser_s_post" ]; then
	echo "[ERROR] Ошибка (Код:3). Переменная ser_s_post не назначена."
else
	ser_s_selected=1
	echo "[OK] Определение номера серии сериала: ser_s_post = $ser_s_post"
fi


if [ "$ser_e_1" = "$null_eq" ]; then
	ser_e_post=$ser_e_2
else
	ser_e_post=$ser_e_1_2
fi

#echo "Отладка: ser_e_post= $ser_e_post"

ser_e_selected=0
if [ -e "$ser_e_post" ]; then
        echo "[ERROR] Ошибка (Код:4). Переменная ser_e_post не назначена."
else
        ser_e_selected=1
        echo "[OK] Определение номера сезона сериала: ser_e_post = $ser_e_post"
fi


# Определяем наименование сериала и его порядковый номер на lostfilm.tv
ser_name=$(cat tmp.2 | grep -oie '\(Fear.the.Walking.Dead\|Mr.Robot\|The.Walking.Dead\|The.X-Files\|Person.of.Interest\)')

ser_name_c_252="Fear.the.Walking.Dead"
ser_name_c_245="Mr.Robot"
ser_name_c_134="The.Walking.Dead"
ser_name_c_270="The.X-Files"
ser_name_c_159="Person.of.Interest"

if [ "$ser_name" = "$ser_name_c_252" ]; then
	ser_c=252
elif [ "$ser_name" = "$ser_name_c_245" ]; then
	ser_c=245
elif [ "$ser_name" = "$ser_name_c_134" ]; then
	ser_c=134
elif [ "$ser_name" = "$ser_name_c_270" ]; then
	ser_c=270
elif [ "$ser_name" = "$ser_name_c_159" ]; then
	ser_c=159
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



#if [ [$ser_c_selected=1] & [$ser_s_selected=1] & [$ser_e_selected=1] ]; then

# Формируем ссылку на страницу для загрузки торрент-файлов, передавая атрибуты: c, s и e.
#link_to_download_page = echo "https://lostfilm.tv/nrdr2.php?c=$ser_c&s=$ser_s&e=$ser_e"

#else
#	echo "Ошибка (Код:5). Неопредены переменные."
#fi

rm selected.serials.tmp
echo "[OK] Удаление временного файла selected.serials.tmp"

rm current.ses_ep.selected.serials.tmp
echo "[OK] Удаление временного файла current.ses_ep.selected.serials.tmp"
