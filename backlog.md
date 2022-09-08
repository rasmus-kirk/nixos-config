* mpd
* connect to public wifi

echo -n dit-hemmelige-password | iconv -t utf16le | openssl md4 | grep --color=none -o "[^ =]*$"
