.PHONY: install
install:
	kpackagetool5 -t Plasma/Applet --install ./package/

.PHONY: run
run:
	plasmoidviewer --applet ./package/

.PHONY: zip
zip:
	zip -r ethprice-1.0.0.plasmoid ./package/
.PHONY: remove
remove:
	kpackagetool5 -t Plasma/Applet --remove ./package/
