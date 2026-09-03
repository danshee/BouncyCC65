#include <cbm.h>
#include <conio.h>
#include <time.h>

typedef unsigned char uint8;

static void drawBall(uint8 x, uint8 y) {
    cputcxy(x, y, 113);
}

static void clearBall(uint8 x, uint8 y) {
    cputcxy(x, y, 32);
}

static void sleep(void) {
    clock_t start = clock();
    while ((clock_t)(clock() - start) < 6);
}

int main(void) {
    uint8 x = 1, y = 1;
    uint8 dx = 1, dy = 1;
    uint8 max_x, max_y;

    screensize(&max_x, &max_y);
    max_x--; max_y--;

    cbm_k_bsout(0x93);   /* PETSCII clear-home */
    cbm_k_bsout(142);    /* uppercase / graphics  */

    for (;;) {
        drawBall(x,y);
        sleep();
        clearBall(x,y);

        x = x + dx;
        if (!((0 < x) && (x < max_x))) dx = -dx;

        y = y + dy;
        if (!((0 < y) && (y < max_y))) dy = -dy;
    }

    return 0;
}
