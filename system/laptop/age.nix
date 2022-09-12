{
	age.identityPaths = [ "/root/per/data/.state/ssh/id_rsa" ];

	age.secrets.user.file = "/root/per/data/.secret/user.age";
	age.secrets.wifi.file = "/root/per/data/.secret/wifi.age";
	age.secrets.duplicity.file = "/root/per/data/.secret/duplicity.age";
	age.secrets.wg-mullvad.file = "/root/per/data/.secret/wg-mullvad.age";
	age.secrets.mail-personal.file = "/root/per/data/.secret/mail-personal.age";
	age.secrets.mail-university.file = "/root/per/data/.secret/mail-university.age";
	age.secrets.newsboat-urls.file = "/root/per/data/.secret/newsboat-urls.age";
	age.secrets.wanikani.file = "/root/per/data/.secret/wanikani.age";
}
