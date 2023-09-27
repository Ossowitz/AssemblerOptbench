#include <stdio.h>

#define constant5 5

int j5, k5, i5;

int main() {
    j5 =0;
    do {
        k5 = k5 - 1;
        j5 = j5 + 1;
        i5 = (k5 * 3) / (j5 * constant5);
    } while (k5 > 0);
    printf("%d", i5);
    printf("%d", k5);
    printf("%d", j5);
}