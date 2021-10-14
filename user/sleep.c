#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

int main(int agrc, char *agrv[])
{
    sleep(atoi(agrv[1]));
    exit(0);
}