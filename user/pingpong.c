#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

int main(void)
{
    int p[2];
    int t[2];
    char sw[2];
    sw[0] = 'c';
    pipe(p);
    pipe(t);
    if (fork() == 0)
    {
        printf("%d: received ping\n", getpid());
        close(p[1]);
        close(t[0]);
        write(t[1], sw, 1);
        close(t[1]);
        exit(0);
    }
    else
    {
        close(p[0]);
        close(t[1]);
        write(p[1], sw, 1);
        close(p[1]);
        read(t[0], sw, 1);
        printf("%d: received pong\n", getpid());
        exit(0);
    }
}
