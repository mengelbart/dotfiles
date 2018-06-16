

.PHONY: dotfiles
dotfiles:
	for file in `find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp"`; do \
		f=`basename $$file`; \
		ln -snf $$file $(HOME)/$$f; \
	done; \
	ln -snf $(CURDIR)/gitignore $(HOME)/.gitignore;
	ln -snf $(CURDIR)/gitconfig $(HOME)/.gitconfig;
	mkdir -p $(HOME)/.config;
	ln -snf $(CURDIR)/.i3 $(HOME)/.config/.i3;

.PHONY: bin
bin:
	for file in `find $(CURDIR)/bin -type f`; do \
		f=`basename $$file`; \
		sudo ln -snf $$file /usr/local/bin/$$f; \
	done;



