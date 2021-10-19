#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"
#include "kernel/fs.h"

void find(char *path, char *filename)
{
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0)
    {
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
    {
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }

    if (st.type != T_DIR)
    {
        fprintf(2, "<usage>:<dir_name> <filename>\n");
        return;
    }

    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
    {
        printf("find: path too long\n");
    }

    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/'; //p指向最后一个'/'之后第一个字符
    while (read(fd, &de, sizeof(de)) == sizeof(de))
    {
        if ((de.inum == 0)) //判断有没有文件
        {
            continue;
        }
        memmove(p, de.name, DIRSIZ); //添加路径名称
        p[DIRSIZ] = 0;               //字符串结束符
        if (stat(buf, &st) < 0)
        {
            fprintf(2, "find:cannot stat %s\n", buf);
            continue;
        }

        //不要在.和..目录递归
        if (st.type == T_DIR && strcmp(p, ".") != 0 && strcmp(p, "..") != 0)
        {
            find(buf, filename);
        }
        else if (strcmp(filename, p) == 0)
        {
            printf("%s\n", buf);
        }
    }
    close(fd);
}

int main(int agrc, char *agrv[])
{
    if (agrc != 3)
    {
        fprintf(2, "<usage>:<dir_name> <filename>\n");
        exit(1);
    }
    find(agrv[1], agrv[2]);
    exit(0);
}