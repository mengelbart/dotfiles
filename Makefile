

.PHONY: dotfiles
dotfiles:
	for file in `find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".ssh"`; do \
		f=`basename $$file`; \
		ln -snf $$file $(HOME)/$$f; \
	done; \
	ln -snf $(CURDIR)/gitignore $(HOME)/.gitignore;
	ln -snf $(CURDIR)/gitconfig $(HOME)/.gitconfig;
	mkdir -p $(HOME)/.config;
	ln -snf $(CURDIR)/.i3 $(HOME)/.config/.i3;
	mkdir -p $(HOME)/.local/share;
	ln -snf $(CURDIR)/.fonts $(HOME)/.local/share/fonts;
	if [ ! -e $(HOME)/.ssh ]; then \
		mkdir -p $(HOME)/.ssh; \
		cp $(CURDIR)/.ssh/config $(HOME)/.ssh/; \
	fi
	mkdir -p $(HOME)/.npm-global

.PHONY: bin
bin:
	for file in `find $(CURDIR)/bin -type f`; do \
		f=`basename $$file`; \
		sudo ln -snf $$file /usr/local/bin/$$f; \
	done;


.PHONY: etc
etc:
	sudo ln -snf $(CURDIR)/etc/X11/xorg.conf /etc/X11/xorg.conf;
	sudo ln -snf $(CURDIR)/etc/X11/xorg.conf.d/10-keyboard.conf /etc/X11/xorg.conf.d/10-keyboard.conf
	sudo ln -snf $(CURDIR)/etc/X11/xorg.conf.d/40-libinput.conf /etc/X11/xorg.conf.d/40-libinput.conf
	sudo ln -snf $(CURDIR)/etc/X11/xorg.conf.d/90-macbook-monitor.conf /etc/X11/xorg.conf.d/90-macbook-monitor.conf
	sudo ln -snf $(CURDIR)/etc/X11/xorg.conf.d/90-samsung-monitor.conf /etc/X11/xorg.conf.d/90-samsung-monitor.conf
	sudo ln -snf $(CURDIR)/etc/asound.conf /etc/asound.conf
