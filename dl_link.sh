
#!/bin/sh
lfrss="https://lostfilm.tv/nrdr2.php?c=159&s=5&e=4"
lfcookie="Cookie: _ga=GA1.2.1172720830.1460950075; _gat=1; _ym_isad=2; _ym_uid=1460950075248392930; _ym_visorc_5681512=w; lnk_uid=95d4f4b893a5be0fd044052e4ab61dad; pass=c1590eb43b93eef263dbbb18bff69adc; phpbb2mysql_data=a%3A2%3A%7Bs%3A11%3A%22autologinid%22%3Bs%3A32%3A%22b129187c8bc7e421477dcd2c578bdda0%22%3Bs%3A6%3A%22userid%22%3Bs%3A7%3A%224721761%22%3B%7D; uid=4762870"
ua="Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)"

/usr/bin/wget -O page $lfrss --user-agent="$ua" --no-cookies --header="$lfcookie" $l

lfrss1="http://retre.org/?c=159&s=5&e=4&u=4762870&h=c8c23a8a7240e87bc33dc5aef8ec504a"

/usr/bin/wget -O page1 $lfrss --user-agent="$ua" --no-cookies --header="$lfcookie" $l
