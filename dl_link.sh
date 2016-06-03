
#!/bin/sh
link_to_dl_page_stage="https://lostfilm.tv/nrdr2.php?c=159&s=5&e=4"
lfcookie="Cookie: _ga=GA1.2.1172720830.1460950075; _gat=1; _ym_isad=2; _ym_uid=1460950075248392930; _ym_visorc_5681512=w; lnk_uid=95d4f4b893a5be0fd044052e4ab61dad; pass=c1590eb43b93eef263dbbb18bff69adc; phpbb2mysql_data=a%3A2%3A%7Bs%3A11%3A%22autologinid%22%3Bs%3A32%3A%22b129187c8bc7e421477dcd2c578bdda0%22%3Bs%3A6%3A%22userid%22%3Bs%3A7%3A%224721761%22%3B%7D; uid=4762870"
ua="Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)"

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

link_to_dl_torrent=$(cat dl_page_final.tmp | grep -ie '1080p WEB-DLRip\.' -A 1 | grep -ioe '<a href=".*" ' | cut -c 10- | rev | cut -c 3- | rev)

#echo "[DEBUG] link_to_dl_torrent=$link_to_dl_torrent" # Отладка

/usr/bin/wget -O tor $link_to_dl_torrent
