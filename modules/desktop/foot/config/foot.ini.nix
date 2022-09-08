colorscheme:
builtins.toFile "foot.ini" ''
	font=monospace:pixelsize=20
	term=xterm-256color
	[colors]
	alpha=0.85
	background = ${colorscheme.bg}
	foreground = ${colorscheme.fg}
	regular0 = ${colorscheme.black}
	regular1 = ${colorscheme.red}
	regular2 = ${colorscheme.green}
	regular3 = ${colorscheme.yellow}
	regular4 = ${colorscheme.blue}
	regular5 = ${colorscheme.purple}
	regular6 = ${colorscheme.teal}
	regular7 = ${colorscheme.white}
	bright0 = ${colorscheme.bright.black}
	bright1 = ${colorscheme.bright.red}
	bright2 = ${colorscheme.bright.green}
	bright3 = ${colorscheme.bright.yellow}
	bright4 = ${colorscheme.bright.blue}
	bright5 = ${colorscheme.bright.purple}
	bright6 = ${colorscheme.bright.teal}
	bright7 = ${colorscheme.bright.white}
	[key-bindings]
	scrollback-up-half-page=Mod1+Shift+K
	scrollback-up-line=Mod1+K
	scrollback-down-half-page=Mod1+Shift+J
	scrollback-down-line=Mod1+J
	clipboard-copy=Mod1+C Control+Shift+C
	clipboard-paste=Mod1+V Control+Shift+V
	font-increase=Mod1+plus Mod1+equal Control+KP_Add
	font-decrease=Mod1+minus Control+KP_Subtract
''
