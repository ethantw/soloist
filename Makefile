css ::
	mkdir -p assets
	npx stylus --watch ./css/index.styl --out ./assets/soloist.css
server ::
	npx http-server .
all ::
	make server | make css
