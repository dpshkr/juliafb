# juliafb

Currently there are many libraries to work with 
low-level frame buffer in Linux. Library is available
in [Python](https://github.com/raspiduino/libpyfb), 
[C](https://gist.github.com/FredEckert/3425429), as well
as [Go](https://github.com/kaey/framebuffer). 

1. Python is too slow for any practical graphical work, and takes about 3 -  4 seconds to fill a 1920 X 1080 screen at 16 BPP ! (On a Raspberry Pi Zero 2 W)
2. C is fast, but error prone and difficult to work with, given all the memory mappings, type conversions, pointers etc.

I created an extremely small Julia library ( a single `struct` to be honest) 
which is very fast and very easy to work with.  

## Usage

As all framebuffer codes do, I have also used memory mapped IO for faster write operations. 
Standard operation begins by creating a `Screen` `struct`
```
s = Screen()
```
`Screen` has four fields. Three fields are filled on initialization, which give useful information about the screen.

1. `bpp` : Bits per pixel 
2. `xres` : X Resolution
3. `yres` : Y Resolution

For example, you can print the screen bits per pixel :

```
println(s.bpp)
```

The fourth field is the actual framebuffer of the type `Matrix{UInt32}` if `bpp == 32` 
else `Matrix{UInt16}` if `bpp == 16`. Presently I have written for only these cases. 
The dimensions of the matrix are `(xres, yres)`

You can then fill the matrix with required values to display on the screen. 
For example, to make all the pixels of the screen red (32 bpp) - 
```
fill!(s.fb, 0xff0000)
```

To turn the first pixel white (Again assuming 32 bpp) - 

```
s.fb[1,1] = 0xffffffff
```

Code tested on Raspberry Pi Zero 2 W, with Raspberry Pi OS Lite Bullseye (headless) and Julia 1.8.5.
