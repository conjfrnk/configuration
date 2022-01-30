/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

/* -b  option; if 0, dmenu appears at bottom */
static int topbar = 0;
/* -c option; centers dmenu on screen */
static int centered = 1;
/* minimum width when centered */
static int min_width = 25;
/* Size of the window border */
static const unsigned int border_width = 5;
static const char *fonts[] = {"Hack Nerd Font Mono:size=12"};
static const char *prompt =
    "run:"; /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
    /*     fg         bg       */
    [SchemeNorm] = {"#e5e5e5", "#262a33"},
    [SchemeSel] = {"#e5e5e5", "#2472c8"},
    [SchemeOut] = {"#000000", "#00ffff"},
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines = 10;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
