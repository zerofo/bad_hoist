ALARM ?= beep # will be called each time user interaction is needed

all: dumps/gadgets.txt dumps/syscalls.txt

always_run:

dumps: always_run
	cd memserver; make all

dumps/webkit-gadgets.txt: dumps
	ROPgadget --binary dumps/webkit.elf --dump > dumps/webkit-gadgets.txt

dumps/libc-gadgets.txt: dumps
	ROPgadget --binary dumps/libc.elf --dump > dumps/libc-gadgets.txt

dumps/gadgets.txt: dumps/webkit-gadgets.txt dumps/libc-gadgets.txt
	cd dumps; grep '' webkit-gadgets.txt libc-gadgets.txt > gadgets.txt

dumps/syscalls.txt: dumps
	objdump -D dumps/libkernel.elf | python3 rop/syscalls.py > dumps/syscalls.txt

clean:
	rm -rf dumps
