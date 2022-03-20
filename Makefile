all: deploy helios

deploy:
	scp -r -P 2222 src s286528@se.ifmo.ru:.

helios:
	~/shortcuts/helios