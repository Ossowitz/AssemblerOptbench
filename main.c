#include <stdio.h>

#define constant5 5

typedef unsigned char    uchar;

int    i, j, k, l, m;
int    i2, j2, k2;
int    g3, h3, i3, k3, m3;
int    i4, j4;
int    i5, j5, k5;

double flt_1, flt_2, flt_3, flt_4, flt_5, flt_6;

int    ivector[ 3 ];
uchar  ivector2[ 3 ];
short  ivector4[ 6 ];
int    ivector5[ 100 ];

#ifndef NO_PROTOTYPES
void   dead_code( int, char * );
void   unnecessary_loop( void );
void   loop_jamming( int );
void   loop_unrolling( int );
int    jump_compression( int, int, int, int, int );
#else
void   dead_code();
       void   unnecessary_loop();
       void   loop_jamming();
       void   loop_unrolling();
       int    jump_compression();
#endif

int /* cdecl */  main( argc, argv )           /* optbench */
        int argc;
        char **argv;
{
    /* ──────────────────────────── *
         │ Отказ от циклов │
         *──────────────────────────────*/
    for (i = 0; i < 3; i++) ivector[i] = 1;

    /* ──────────────────────────── *
         │ Переприсваивание│
         *──────────────────────────────*/
    i2 = 5;
    j4 = 6;
    i2 = j4;
    /* ──────────────────────────── *
         │ Размножение констант и копий │
         *──────────────────────────────*/

    j4 = 2;
    if (i2 < j4 && i4 < j4) {
        i2 = 2;
        printf("Hello");
    }

    j4 = k5;
    if (i2 < j4 && i4 < j4) {
        i5 = 3;
        printf("Hello");
    }

    /* ────────────────────────────────────────── *
 │ Свертка констант, арифметические тождества │
     │ и излишние операции загрузки/сохранения    │
     * ────────────────────────────────────────── */

    i3 = 1 + 2;
    flt_1 = 2.4 + 6.3;
    i2 = 5;
    j2 = i + 0;
    k2 = i / 1;
    i4 = i * 1;
    i5 = i * 0;

    k3 = 1;
    k3 = 1;

    /* ────────────────── *
     │  Снижение мощности │
     * ────────────────── */

    k2 = 4 * j5;
    for (i = 0; i <= 5; i++)
        ivector4[i] = i * 2;

    /* ───────────── *
         │  Простой цикл │
         * ───────────── */

    j5 = 0;
    k5 = 10000;
    do {
        k5 = k5 - 1;
        j5 = j5 + 1;
        i5 = (k5 * 3) / (j5 * constant5);
    } while (k5 > 0);

    /* ────────────────────────────────────── *
 │  Управление переменной индукции цикла  │
     * ────────────────────────────────────── */
    for (i = 0; i < 100; i++)
        ivector5[i * 2 + 3] = 5;

    /* ─────────────────────── *
     │  Глубокие подвыражения  │
     * ─────────────────────── */

    if (i < 10)
        j5 = i5 + i2;
    else
        k5 = i5 + i2;
}