#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

#define RD 0
#define WR 1

const uint INT_LEN = sizeof(int);

/* 
@ function:读取左边第一个数据
@param lpipe:左边的管道符
@param *first:指向左边第一个数据
@return:有数据返回0，无数据返回1
*/
int read_left_first(const int lpipe[], int *lfirst)
{
    if (read(lpipe[RD], lfirst, INT_LEN) > 0)
    {
        printf("prime %d\n", *lfirst);
        return 0;
    }
    return 1;
}

/*
@function:读取左边数据，不能被第一个数据整除的发送到右边
@param lpipe:左边的管道符
@param Rpipe:右边的管道符
@param first：左边第一个数据
 */
void transmit_data(int lpipe[], int rpipe[], int first)
{
    int tmp = 0;
    while (read(lpipe[RD], &tmp, INT_LEN) > 0)
    {
        if (tmp % first != 0)
        {
            write(rpipe[WR], &tmp, INT_LEN);
        }
    }
    close(lpipe[RD]);
    close(rpipe[WR]);
}

/*
@function:寻找素数
@param:左边管道符 
 */

void primes(int lpipe[])
{
    close(lpipe[WR]); //关闭左边管道符
    int p[2];
    pipe(p);
    int left_first;

    if (read_left_first(lpipe, &left_first) == 0)
    {
        if (fork() == 0) //fork为0的是子进程
        {
            primes(p); //创建新的进程，当前进程成为新创建进程的左边
        }
        close(p[RD]);
        transmit_data(lpipe, p, left_first);
        wait(0);
        exit(0);
    }
    else
    {
        close(p[RD]);
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

    if (fork() == 0) //子进程
    {
        primes(p);
    }

    close(p[WR]);
    close(p[RD]);
    wait(0);
    exit(0);
}