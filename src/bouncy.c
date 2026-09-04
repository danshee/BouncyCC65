#include <cbm.h>
#include <conio.h>
#include <time.h>

typedef unsigned char uint8;

int main(void) {
    uint8 x = 1, y = 1;
    uint8 px = x, py = y;
    uint8 dx = 1, dy = 1;
    uint8 max_x, max_y;

    screensize(&max_x, &max_y);
    max_x--; max_y--;

    cbm_k_bsout(0x93);   /* PETSCII clear-home */
    cbm_k_bsout(142);    /* uppercase / graphics  */

    for (;;) {
        unsigned char i;
        for (i = 0; i < 6; ++i)
            waitvsync();

        cputcxy(px, py, 32);
        cputcxy(x, y, 113);

        px = x;
        x += dx;
        if (x == 0 || x == max_x) dx = -dx;
        py = y;

        y += dy;
        if (y == 0 || y == max_y) dy = -dy;
    }

    return 0;
}
