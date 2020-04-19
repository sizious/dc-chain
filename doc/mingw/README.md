# Sega Dreamcast toolchain with MinGW #

Before starting, you need to open the correct `README` file, depending of
your environment:

* If you are using the newer **MinGW-w64/MSYS2** environment provided by
  [MinGW-w64.org](https://mingw-w64.org/), please open `mingw-w64.md`.
* If you are using the original **MinGW/MSYS** environment provided by
  [MinGW.org](http://www.mingw.org), please open `mingw.md`.

Even if the name of the environment sounds identical, they are very different. 
So please be sure to use the correct documentation!

## How to determinate the MinGW environment

A quick way to determinate if you are using **MinGW-w64/MSYS2** or 
**MinGW/MSYS** can be:

1. Open the **MSYS Shell**.

2. Enter the following:
		
		command -v pacman

3. Check the output:

	* If the output is blank: You are using the legacy **MinGW/MSYS**
      environment.
	* If the output is similar to `/usr/bin/pacman`: You are using the newer 
      **MinGW-w64/MSYS2** environment.
