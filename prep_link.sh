
# Забираем в файл selected.serials.tmp только искомые сериалы по названию.
cat tmp.2 | grep -ie '\(Fear.the.Walking.Dead\|Mr.Robot\|The.Walking.Dead\|The.X-Files\|Person.of.Interest\)' >> selected.serials.tmp

# Определяем номер созона и номер серии.
cat selected.serials.tmp | grep -m 1 -oE '\S[[:digit:]]{1,2}\E[[:digit:]]{1,2}' >> current.ses_ep.selected.serials.tmp

ser_s_1_2=cat current.ses_ep.selected.serials.tmp | cut -c 2-3
ser_s_1=cat current.ses_ep.selected.serials.tmp | cut -c 2-2
ser_s_2=cat current.ses_ep.selected.serials.tmp | cut -c 3-3
ser_e_1_2=cat current.ses_ep.selected.serials.tmp | cut -c 5-6
ser_e_1=cat current.ses_ep.selected.serials.tmp | cut -c 5-5
ser_e_2=cat current.ses_ep.selected.serials.tmp | cut -c 6-6

if [ $ser_s_1 = 0 ]; then
	ser_s_post=$ser_s_2
else
	ser_s_post=$ser_s_1_2
fi

ser_s_selected=0
if [ !$ser_s_post ]; then
	echo "Ошибка (Код:3). Переменная ser_s_post не назначена."
else
	$ser_s_selected=1
	echo "[OK] Определение номера серии сериала: ser_s_post = $ser_s_post"
fi

if [ $ser_e_1 = 0 ]; then
	ser_e_post=$ser_e_2
else
	ser_e_post=$ser_e_1_2
fi

ser_e_selected=0
if [ !$ser_e_post ]; then
        echo "Ошибка (Код:4). Переменная ser_e_post не назначена."
else
        $ser_e_selected=1
        echo "[OK] Определение номера сезона сериала: ser_e_post = $ser_e_post"
fi


# Определяем наименование сериала и его порядковый номер на lostfilm.tv
ser_name=cat tmp.2 | grep -oie '\(Fear.the.Walking.Dead\|Mr.Robot\|The.Walking.Dead\|The.X-Files\|Person.of.Interest\)'

if [ $ser_name = "Fear.the.Walking.Dead" ]; then
	ser_c=252
elif [ $ser_name = "Mr.Robot" ]; then
	ser_c=245
elif [ $ser_name = "The.Walking.Dead" ]; then
	ser_c=134
elif [ $ser_name = "The.X-Files" ]; then
	ser_c=270
elif [ $ser_name = "Person.of.Interest" ]; then
	ser_c=159
else
	echo "Ошибка (Код:1). Некорректное значение переменной ser_name."
fi



ser_c_selected=0

if [ !$ser_c ]; then
	echo "Ошибка (Код:2). Переменная ser_c не назначена."
else
	ser_c_selected=1
	echo "[OK] Определение порядкового номера сериала: ser_c = $ser_c ($ser_name)"
fi




# Формируем ссылку на страницу для загрузки торрент-файлов, передавая атрибуты: c, s и e.
link_to_download_page = echo "https://lostfilm.tv/nrdr2.php?c=$ser_c&s=$ser_s&e=$ser_e"
