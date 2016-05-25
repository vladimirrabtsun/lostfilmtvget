
    #!/bin/sh
    TMP1=tmp.1
    TMP2=tmp.2
    TMP3=tmp.3
    lfrss="http://www.lostfilm.tv/rssdd.xml"
    lfcookie="Cookie: _ga=GA1.2.1172720830.1460950075; _gat=1; _ym_isad=2; _ym_uid=1460950075248392930; _ym_visorc_5681512=w; lnk_uid=95d4f4b893a5be0fd044052e4ab61dad; pass=c1590eb43b93eef263dbbb18bff69adc; phpbb2mysql_data=a%3A2%3A%7Bs%3A11%3A%22autologinid%22%3Bs%3A32%3A%22b129187c8bc7e421477dcd2c578bdda0%22%3Bs%3A6%3A%22userid%22%3Bs%3A7%3A%224721761%22%3B%7D; uid=4762870"
    ua="Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)"
    # Каталог, который наблюдает transmission
    WDIR=~/Downloads/torrents_lostfilm_tv
    # Качаем RSS
    /usr/bin/wget -O $TMP1 $lfrss
    # Качать только avi
    cat $TMP1 | grep -ioe 'http.*torrent'| grep -ie '1080p' > $TMP2
    # Список сериалов
    cat $TMP2 | grep -ie '\(Fear\|The.Originals\|Mr.Robot\|The.Walking.Dead\|The.X-Files\|Person\)' > $TMP3
    for l in `cat $TMP3`
    do
    tor=`echo $l | cut -d';' -f2`
    if [ ! -f $WDIR/$tor ]
    then
    echo !!! download $tor
    /usr/bin/wget -nc -O $tor --referer="$lfrss" --user-agent="$ua" --no-cookies --header="$lfcookie" $l
    echo ------------ >> download.torrent.list
    echo `date`: download $tor >> download.torrent.list
    mv $tor $WDIR
    fi
    done

