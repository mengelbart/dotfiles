

.PHONY: dotfiles
dotfiles:
	for file in `find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp"`; do \
		f=`basename $$file`; \
		ln -snf $$file $(HOME)/$$f; \
	done; \
	ln -snf $(CURDIR)/gitignore $(HOME)/.gitignore;
	ln -snf $(CURDIR)/gitconfig $(HOME)/.gitconfig;



