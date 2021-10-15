#include "kernel/types.h"
#include "user.h"

#define RD 0
#define WR 1

const int INT_LEN = sizeof(int);

/* 
    @function:从左边读取第一个数据
    @param lpipe:左边的管道符
    @param *lfirst:指向读取左边的第一个数据
    @return:有数据返回0，无数据返回1
 */
int read_left_first(int lpipe[], int *lfirst)
{
    if (read(lpipe[RD], lfirst, INT_LEN) > 0)
    {
        printf("prime %d\n", *lfirst);
        return 0;
    }

    return 1;
}

/* 
    @function:从左边读取数据，不可以被第一个数据整除的数传到右边
    @param lpipe:左边的管道符
    @param rpipe:右边的管道符
    @param first:左边的第一个数据
 */
void transmit(int lpipe[], int rpipe[], int first)
{
    int tmp = 0;
    while (read(lpipe[RD], &tmp, INT_LEN) > 0)
    {
        if (tmp % first != 0)
        {
            write(rpipe[WR], &tmp, INT_LEN);
        }
    }
    close(rpipe[WR]);
    close(lpipe[RD]);
}

/* 
    @funciton:寻找素数
    @param:左边的管道符
 */
void primes(int lpipe[])
{
    close(lpipe[WR]);
    int p[2];
    pipe(p);
    int first_of_left;
    if (read_left_first(lpipe, &first_of_left) == 0) //左边有数据
    {
        if (fork() == 0)
        {
            primes(p);
        }

        transmit(lpipe, p, first_of_left); //将左边的数据传入右边
        wait(0);
        exit(0);
    }
    else
    {
        close(lpipe[RD]);
        close(p[WR]);
        exit(0);
    }
}

int main(int agrc, char *agrv[])
{
    int p[2];
    pipe(p);

    for (int i = 2; i <= 35; i++)
    {
        write(p[WR], &i, INT_LEN);
    }

    if (fork() == 0)
    {
        primes(p);
    }

    close(p[WR]);
    close(RD);
    wait(0);
    exit(0);
}