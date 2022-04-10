all: out.prg

out.prg: main.asm
	xa $< -o $@ -O PETSCII

run: out.prg
	x64sc -autostart $< > /dev/null
