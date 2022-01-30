// Modify this file to change what commands output to your statusbar, and
// recompile using the make command.
static const Block blocks[] = {
    /*Icon*/ /*Command*/ /*Update Interval*/ /*Update Signal*/
    {" ", "dwm-network", 1, 3},
    //{" ", "dwm-speedtest", 60, 4},
    //{" ", "dwm-moonphase", 18000, 4},
    //{" ", "dwm-weather", 18000, 4},
    //{" ", "dwm-music", 0, 11},
    {" ", "dwm-cputemp", 10, 3},
    {" ", "dwm-cpubars", 1, 3},
    {" ", "dwm-packages", 600, 3},
    {" ", "dwm-volume", 0, 10},
    {" ", "dwm-battery", 10, 3},
    {" ", "dwm-misc", 1, 1},
    {" ", "dwm-clockfancy", 5, 2},
};

// Sets delimiter between status commands. NULL character ('\0') means no
// delimiter.
static char delim[] = " ";
static unsigned int delimLen = 1;

// Have dwmblocks automatically recompile and run when you edit this file in
// vim with the following line in your vimrc/init.vim:

// autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd
// ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid
// dwmblocks & }
