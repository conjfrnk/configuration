#include <X11/XF86keysym.h>

static const unsigned int borderpx = 7; /* border pixel of windows */
static const unsigned int snap = 20;    /* snap pixel */
static const unsigned int gappih = 15;  /* horiz inner gap */
static const unsigned int gappiv = 15;  /* vert inner gap */
static const unsigned int gappoh = 20;  /* horiz outer gap */
static const unsigned int gappov = 20;  /* vert outer gap */
static int smartgaps = 1;     /* 1 means no outer gap with only one window */
static const int showbar = 1; /* 0 : no bar
                               * 1 : yes bar */
static const int topbar = 1;  /* 0 : bottom bar
                               * 1 : top bar */

static const char *fonts[] = {
    "Hack Nerd Font:size=12:antialias=true:autohint=true"};

/*
 * andromeda colorscheme:
 *
 * black: "#666666"
 * blue: "#2472c8"
 * cyan: "#0fa8cd"
 * green: "#05bc79"
 * magenta: "#bc3fbc"
 * red: "#cd3131"
 * white: "#e5e5e5"
 * yellow: "#e5e512"
 *
 * background: "#262a33"
 * foreground: "#e5e5e5"
 */

static const char *colors[][3] = {
    /*                fg        bg        border   */
    [SchemeNorm] = {"#e5e5e5", "#262a33", "#666666"},
    [SchemeSel] = {"#e5e5e5", "#2472c8", "#05bc79"},
};

typedef struct {
  const char *name;
  const void *cmd;
} Sp;
const char *spcmd0[] = {"st", "-n", "spterm", "-g", "130x34", NULL};
const char *spcmd1[] = {"st",     "-n", "spfiles", "-g",
                        "155x45", "-e", "ranger",  NULL};
const char *spcmd2[] = {"st",     "-n", "spcalc", "-g",
                        "100x25", "-e", "calc",   NULL};
const char *spcmd3[] = {"keepassxc", NULL};
const char *spcmd4[] = {"st",     "-n", "spmusic", "-g",
                        "150x40", "-e", "ncmpcpp", NULL};
const char *spcmd5[] = {"st",     "-n", "spmixer",    "-g",
                        "100x25", "-e", "pulsemixer", NULL};
const char *spcmd6[] = {"st", "-n", "sptop", "-g", "150x40", "-e", "htop"};
const char *spcmd7[] = {"thunderbird", NULL};
const char *spcmd8[] = {"monero-wallet-gui", NULL};
const char *spcmd9[] = {"zotero", NULL};
const char *spcmd10[] = {"discord", NULL};
static Sp scratchpads[] = {
    /* name, cmd  */
    {"spterm", spcmd0},    {"spranger", spcmd1}, {"spcalc", spcmd2},
    {"keepassxc", spcmd3}, {"ncmpcpp", spcmd4},  {"pulsemixer", spcmd5},
    {"htop", spcmd6},      {"spmail", spcmd7},   {"xmrwallet", spcmd8},
    {"citations", spcmd9}, {"discord", spcmd10},
};

/* tags */
static const char *tags[] = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"};

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title */
    /* class, instance, title, tags mask, iscentered, isfloating,
       isfakefullscreen, monitor */
    {"termapp", NULL, NULL, 0, 1, 1, 0, -1},
    {NULL, "spterm", NULL, SPTAG(0), 0, 1, 0, -1},
    {NULL, "spfiles", NULL, SPTAG(1), 0, 1, 0, -1},
    {NULL, "spcalc", NULL, SPTAG(2), 0, 1, 0, -1},
    {NULL, "keepassxc", NULL, SPTAG(3), 0, 1, 0, -1},
    {NULL, "spmusic", NULL, SPTAG(4), 0, 1, 0, -1},
    {NULL, "spmixer", NULL, SPTAG(5), 0, 1, 0, -1},
    {NULL, "sptop", NULL, SPTAG(6), 0, 1, 0, -1},
    {NULL, "spmail", NULL, SPTAG(7), 0, 1, 0, -1},
    {NULL, "xmrwallet", NULL, SPTAG(8), 0, 1, 0, -1},
    {NULL, "citations", NULL, SPTAG(9), 0, 1, 0, -1},
    {NULL, "discord", NULL, SPTAG(10), 0, 1, 0, -1},
};

/* layout */
static const float mfact = 0.5;   /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;     /* number of clients in master area */
static const int resizehints = 0; /* 0 : don't respect size hints
                                   * 1 : means respect size hints
                                   * in tiled resizals */
static const int decorhints = 0;  /* 1 means respect decoration hints */

#define FORCE_VSPLIT 1
#include "vanitygaps.c"

static const Layout layouts[] = {
    /* symbol, arrange function */
    {"[]=", tile}, /* first entry is default */
    {"[M]", monocle},
    {"[@]", spiral},
    {"[\\]", dwindle},
    {"H[]", deck},
    {"TTT", bstack},
    {"===", bstackhoriz},
    {"HHH", grid},
    {"###", nrowgrid},
    {"---", horizgrid},
    {":::", gaplessgrid},
    {"|M|", centeredmaster},
    {">M>", centeredfloatingmaster},
    {"><>", NULL}, /* no layout function means floating behavior */
    {NULL, NULL},
};

/************/
/* Bindings */
/************/

#define MODKEY Mod1Mask
#define SUPKEY Mod4Mask

#define TAGKEYS(KEY, TAG)                                                      \
  {SUPKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {SUPKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {SUPKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
      {SUPKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

/* commands */

/*apps*/
// static char dmenumon[2] = "0";
/* component of dmenucmd, manipulated in spawn() */
// static const char *dmenucmd[] = {"dmenu_run"};
static const char *sbuild[] = {"st",     "-c", "termapp", "-g",
                               "150x40", "-e", "sbuild"};

#include "movestack.c" /*movestack*/
#include "shiftview.c" /*shiftview*/

static Key keys[] = {
    /* apps */
    {SUPKEY, XK_space, spawn, SHCMD("dmenu_run")},
    {MODKEY | ShiftMask, XK_Return, spawn, SHCMD("st")},
    {MODKEY, XK_Return, spawn, SHCMD("alacritty")},
    {SUPKEY, XK_F3, spawn,
     SHCMD("mpv --no-cache --no-osc --no-input-default-bindings "
           "--profile=low-latency --input-conf=/dev/null --title=webcam $(ls "
           "/dev/video[0,2,4,6,8] | tail -n 1)")},
    {SUPKEY, XK_b, spawn, {.v = sbuild}},
    /*
     * scratchpads:
     * 0 - terminal
     * 1 - file manager
     * 2 - calculator
     * 3 - password manager
     * 4 - music player
     * 5 - audio mixer
     * 6 - htop
     * 7 - mail (thunderbird)
     * 8 - monero
     * 9 - zotero
     * 10 - discord
     */
    {SUPKEY, XK_t, togglescratch, {.ui = 0}},
    {SUPKEY, XK_f, togglescratch, {.ui = 1}},
    {SUPKEY, XK_c, togglescratch, {.ui = 2}},
    {SUPKEY, XK_backslash, togglescratch, {.ui = 3}},
    {SUPKEY, XK_n, togglescratch, {.ui = 4}},
    {SUPKEY, XK_a, togglescratch, {.ui = 5}},
    {SUPKEY, XK_x, togglescratch, {.ui = 6}},
    {SUPKEY, XK_m, togglescratch, {.ui = 7}},
    {SUPKEY, XK_w, togglescratch, {.ui = 8}},
    {SUPKEY, XK_z, togglescratch, {.ui = 9}},
    {SUPKEY, XK_d, togglescratch, {.ui = 10}},
    {SUPKEY, XK_e, spawn, SHCMD("qbittorrent")},
    {SUPKEY, XK_s, spawn, SHCMD("wireshark")},
    {SUPKEY, XK_v, spawn, SHCMD("openshot-qt")},
    {SUPKEY, XK_g, spawn, SHCMD("gimp")},
    {SUPKEY, XK_i, spawn, SHCMD("inkscape")},
    {SUPKEY, XK_o, spawn, SHCMD("libreoffice")},
    {MODKEY, XK_space, spawn, SHCMD("firefox")},
    {MODKEY | ShiftMask, XK_space, spawn, SHCMD("vivaldi-stable")},
    {MODKEY | ControlMask, XK_space, spawn, SHCMD("tor-browser")},
    /* resets */
    {SUPKEY, XK_r, spawn, SHCMD("kill -37 $(pidof dwmblocks)")},
    {SUPKEY | ShiftMask, XK_r, spawn, SHCMD("kill -35 $(pidof dwmblocks)")},
    {SUPKEY | MODKEY, XK_r, spawn, SHCMD("kill -38 $(pidof dwmblocks)")},
    {SUPKEY | MODKEY | ShiftMask, XK_r, spawn, SHCMD("random-wallpaper")},
    /* lock and power menu */
    {SUPKEY | ControlMask, XK_l, spawn, SHCMD("slock")},
    {SUPKEY | ShiftMask, XK_space, spawn, SHCMD("power")},
    /* audio volume control */
    {0, XF86XK_AudioMute, spawn,
     SHCMD("pamixer -t; kill -44 $(pidof dwmblocks)")},
    {0, XF86XK_AudioRaiseVolume, spawn,
     SHCMD("pamixer --allow-boost -i 5; kill -44 $(pidof dwmblocks)")},
    {0, XF86XK_AudioLowerVolume, spawn,
     SHCMD("pamixer --allow-boost -d 5; kill -44 $(pidof dwmblocks)")},
    {0, XF86XK_AudioMicMute, spawn, SHCMD("amixer set Capture toggle")},
    /* music control */
    {0, XF86XK_Favorites, spawn, SHCMD("mpc toggle")},
    {0, XK_End, spawn, SHCMD("mpc next")},
    {0, XK_Home, spawn, SHCMD("mpc prev")},
    {0, XF86XK_AudioPlay, spawn, SHCMD("mpc toggle")},
    {0, XF86XK_AudioNext, spawn, SHCMD("mpc next")},
    {0, XF86XK_AudioPrev, spawn, SHCMD("mpc prev")},
    {0, XF86XK_AudioStop, spawn, SHCMD("mpc stop")},
    {0, XF86XK_AudioRewind, spawn, SHCMD("mpc seek -10")},
    {0, XF86XK_AudioForward, spawn, SHCMD("mpc seek +10")},
    /* brightness */
    {0, XF86XK_MonBrightnessUp, spawn,
     SHCMD("backlight-up; kill -35 $(pidof dwmblocks)")},
    {0, XF86XK_MonBrightnessDown, spawn,
     SHCMD("backlight-down; kill -35 $(pidof dwmblocks)")},
    /* dwm */
    {MODKEY | SUPKEY, XK_space, togglefloating, {0}},
    {MODKEY, XK_f, togglefullscr, {0}},
    {MODKEY, XK_b, togglebar, {0}},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY | ShiftMask, XK_i, incnmaster, {.i = -1}},
    {MODKEY | ShiftMask, XK_j, movestack, {.i = +1}},
    {MODKEY | ShiftMask, XK_k, movestack, {.i = -1}},
    {SUPKEY, XK_Right, shiftview, {.i = +1}},
    {SUPKEY, XK_Left, shiftview, {.i = -1}},
    /* cfacts and mfacts */
    {SUPKEY, XK_j, setcfact, {.f = +0.25}},
    {SUPKEY, XK_k, setcfact, {.f = -0.25}},
    {SUPKEY, XK_h, setmfact, {.f = -0.05}},
    {SUPKEY, XK_l, setmfact, {.f = +0.05}},
    /* gaps from vanitygaps patch */
    {MODKEY | SUPKEY, XK_u, incrgaps, {.i = +2}},
    {MODKEY | SUPKEY | ShiftMask, XK_u, incrgaps, {.i = -2}},
    {MODKEY | SUPKEY, XK_i, incrigaps, {.i = +2}},
    {MODKEY | SUPKEY | ShiftMask, XK_i, incrigaps, {.i = -2}},
    {MODKEY | SUPKEY, XK_o, incrogaps, {.i = +2}},
    {MODKEY | SUPKEY | ShiftMask, XK_o, incrogaps, {.i = -2}},
    {MODKEY | SUPKEY, XK_6, incrihgaps, {.i = +2}},
    {MODKEY | SUPKEY | ShiftMask, XK_6, incrihgaps, {.i = -2}},
    {MODKEY | SUPKEY, XK_7, incrivgaps, {.i = +2}},
    {MODKEY | SUPKEY | ShiftMask, XK_7, incrivgaps, {.i = -2}},
    {MODKEY | SUPKEY, XK_8, incrohgaps, {.i = +2}},
    {MODKEY | SUPKEY | ShiftMask, XK_8, incrohgaps, {.i = -2}},
    {MODKEY | SUPKEY, XK_9, incrovgaps, {.i = +2}},
    {MODKEY | SUPKEY | ShiftMask, XK_9, incrovgaps, {.i = -2}},
    /* gaps */
    {SUPKEY, XK_grave, togglegaps, {0}},
    {SUPKEY, XK_equal, defaultgaps, {0}},
    {SUPKEY, XK_Tab, view, {0}},
    /* cmd + q to kill */
    {SUPKEY, XK_q, killclient, {0}},
    /*
     * window arrangement types:
     * Super + Shift +
     * T = tiling
     * B = tiling with master on top (bstack)
     * F = floating
     * M = monocle
     * D = deck
     * C = centered master
     */
    {SUPKEY | ShiftMask, XK_t, setlayout, {.v = &layouts[0]}},
    {SUPKEY | ShiftMask, XK_b, setlayout, {.v = &layouts[5]}},
    {SUPKEY | ShiftMask, XK_f, setlayout, {.v = &layouts[13]}},
    {SUPKEY | ShiftMask, XK_m, setlayout, {.v = &layouts[1]}},
    {SUPKEY | ShiftMask, XK_d, setlayout, {.v = &layouts[4]}},
    {SUPKEY | ShiftMask, XK_c, setlayout, {.v = &layouts[11]}},
    /* move floating windows using super + h/j/k/l */
    {SUPKEY, XK_j, moveresize, {.v = "0x 25y 0w 0h"}},
    {SUPKEY, XK_k, moveresize, {.v = "0x -25y 0w 0h"}},
    {SUPKEY, XK_l, moveresize, {.v = "25x 0y 0w 0h"}},
    {SUPKEY, XK_h, moveresize, {.v = "-25x 0y 0w 0h"}},
    /* resize floating windows using Super + Shift + h/j/k/l */
    {SUPKEY | ShiftMask, XK_j, moveresize, {.v = "0x 0y 0w 25h"}},
    {SUPKEY | ShiftMask, XK_k, moveresize, {.v = "0x 0y 0w -25h"}},
    {SUPKEY | ShiftMask, XK_l, moveresize, {.v = "0x 0y 25w 0h"}},
    {SUPKEY | ShiftMask, XK_h, moveresize, {.v = "0x 0y -25w 0h"}},
    /* monitors */
    {SUPKEY | MODKEY, XK_j, focusmon, {.i = +1}},
    {SUPKEY | MODKEY, XK_k, focusmon, {.i = -1}},
    {SUPKEY | MODKEY, XK_l, tagmon, {.i = +1}},
    {SUPKEY | MODKEY, XK_h, tagmon, {.i = -1}},
    /* desktop names */
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
            TAGKEYS(XK_9, 8)
                TAGKEYS(XK_0, 9){SUPKEY | ShiftMask, XK_q, quit, {0}},
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
 * ClkClientWin, or ClkRootWin */
static Button buttons[] = {
    /* click, event mask, button, function argument*/
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkWinTitle, 0, Button2, zoom, {0}},
    {ClkClientWin, SUPKEY, Button1, movemouse, {0}},
    {ClkClientWin, SUPKEY, Button2, togglefloating, {0}},
    {ClkClientWin, SUPKEY | MODKEY, Button1, togglefloating, {0}},
    {ClkClientWin, SUPKEY, Button3, resizemouse, {0}},
    {ClkClientWin, SUPKEY | ShiftMask, Button1, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, toggleview, {0}},
    {ClkTagBar, SUPKEY, Button1, tag, {0}},
    {ClkTagBar, SUPKEY, Button3, toggletag, {0}},
};
