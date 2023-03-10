using Mmap

struct Screen
    bpp
    xres
    yres
    fb
    function Screen()
        f = open("/sys/class/graphics/fb0/bits_per_pixel")
        bpp = parse(Int, readline(f))
        close(f)
        f = open("/sys/class/graphics/fb0/virtual_size")
        res = ((split(readline(f),",")))
        xres = parse(Int, res[1])
        yres = parse(Int, res[2])
        close(f)
        fbfd = open("/dev/fb0", "w+")
        if (bpp == 16)
            fb = Mmap.mmap(fbfd, Matrix{UInt16},(xres, yres), grow=false)
        elseif (bpp == 32)
            fb = Mmap.mmap(fbfd, Matrix{UInt32},(xres, yres), grow=false)
        else
            fb = 0
        end
        close(fbfd)
        new(bpp,xres,yres,fb)
    end
end

s = Screen()
println(s.bpp)
println(s.xres)
println(s.yres)
fill!(s.fb, 0xffffffff)
