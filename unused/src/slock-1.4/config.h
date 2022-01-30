/* user and group to drop privileges to */
static const char *user = "connor";
static const char *group = "users";

static const char *colorname[NUMCOLS] = {
    [INIT] = "#2472c8",   /* after initialization */
    [INPUT] = "#05bc79",  /* during input */
    [FAILED] = "#cd3131", /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;
