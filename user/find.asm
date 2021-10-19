
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/stat.h"
#include "user.h"
#include "kernel/fs.h"

void find(char *path, char *filename)
{
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	26913423          	sd	s1,616(sp)
  10:	27213023          	sd	s2,608(sp)
  14:	25313c23          	sd	s3,600(sp)
  18:	25413823          	sd	s4,592(sp)
  1c:	25513423          	sd	s5,584(sp)
  20:	25613023          	sd	s6,576(sp)
  24:	23713c23          	sd	s7,568(sp)
  28:	23813823          	sd	s8,560(sp)
  2c:	0500                	addi	s0,sp,640
  2e:	892a                	mv	s2,a0
  30:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0)
  32:	4581                	li	a1,0
  34:	00000097          	auipc	ra,0x0
  38:	4c4080e7          	jalr	1220(ra) # 4f8 <open>
  3c:	02054a63          	bltz	a0,70 <find+0x70>
  40:	84aa                	mv	s1,a0
    {
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
  42:	d8840593          	addi	a1,s0,-632
  46:	00000097          	auipc	ra,0x0
  4a:	4ca080e7          	jalr	1226(ra) # 510 <fstat>
  4e:	02054c63          	bltz	a0,86 <find+0x86>
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }

    if (st.type != T_DIR)
  52:	d9041703          	lh	a4,-624(s0)
  56:	4785                	li	a5,1
  58:	04f70763          	beq	a4,a5,a6 <find+0xa6>
    {
        fprintf(2, "<usage>:<dir_name> <filename>\n");
  5c:	00001597          	auipc	a1,0x1
  60:	9ac58593          	addi	a1,a1,-1620 # a08 <malloc+0x11a>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	79c080e7          	jalr	1948(ra) # 802 <fprintf>
        return;
  6e:	a295                	j	1d2 <find+0x1d2>
        fprintf(2, "ls: cannot open %s\n", path);
  70:	864a                	mv	a2,s2
  72:	00001597          	auipc	a1,0x1
  76:	96658593          	addi	a1,a1,-1690 # 9d8 <malloc+0xea>
  7a:	4509                	li	a0,2
  7c:	00000097          	auipc	ra,0x0
  80:	786080e7          	jalr	1926(ra) # 802 <fprintf>
        return;
  84:	a2b9                	j	1d2 <find+0x1d2>
        fprintf(2, "ls: cannot stat %s\n", path);
  86:	864a                	mv	a2,s2
  88:	00001597          	auipc	a1,0x1
  8c:	96858593          	addi	a1,a1,-1688 # 9f0 <malloc+0x102>
  90:	4509                	li	a0,2
  92:	00000097          	auipc	ra,0x0
  96:	770080e7          	jalr	1904(ra) # 802 <fprintf>
        close(fd);
  9a:	8526                	mv	a0,s1
  9c:	00000097          	auipc	ra,0x0
  a0:	444080e7          	jalr	1092(ra) # 4e0 <close>
        return;
  a4:	a23d                	j	1d2 <find+0x1d2>
    }

    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
  a6:	854a                	mv	a0,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	1e2080e7          	jalr	482(ra) # 28a <strlen>
  b0:	2541                	addiw	a0,a0,16
  b2:	20000793          	li	a5,512
  b6:	0aa7ee63          	bltu	a5,a0,172 <find+0x172>
    {
        printf("find: path too long\n");
    }

    strcpy(buf, path);
  ba:	85ca                	mv	a1,s2
  bc:	db040513          	addi	a0,s0,-592
  c0:	00000097          	auipc	ra,0x0
  c4:	182080e7          	jalr	386(ra) # 242 <strcpy>
    p = buf + strlen(buf);
  c8:	db040513          	addi	a0,s0,-592
  cc:	00000097          	auipc	ra,0x0
  d0:	1be080e7          	jalr	446(ra) # 28a <strlen>
  d4:	02051913          	slli	s2,a0,0x20
  d8:	02095913          	srli	s2,s2,0x20
  dc:	db040793          	addi	a5,s0,-592
  e0:	993e                	add	s2,s2,a5
    *p++ = '/'; //p指向最后一个'/'之后第一个字符
  e2:	00190a13          	addi	s4,s2,1
  e6:	02f00793          	li	a5,47
  ea:	00f90023          	sb	a5,0(s2)
            fprintf(2, "find:cannot stat %s\n", buf);
            continue;
        }

        //不要在.和..目录递归
        if (st.type == T_DIR && strcmp(p, ".") != 0 && strcmp(p, "..") != 0)
  ee:	4a85                	li	s5,1
        {
            find(buf, filename);
        }
        else if (strcmp(filename, p) == 0)
        {
            printf("%s\n", buf);
  f0:	00001b97          	auipc	s7,0x1
  f4:	8f8b8b93          	addi	s7,s7,-1800 # 9e8 <malloc+0xfa>
        if (st.type == T_DIR && strcmp(p, ".") != 0 && strcmp(p, "..") != 0)
  f8:	00001b17          	auipc	s6,0x1
  fc:	960b0b13          	addi	s6,s6,-1696 # a58 <malloc+0x16a>
 100:	00001c17          	auipc	s8,0x1
 104:	960c0c13          	addi	s8,s8,-1696 # a60 <malloc+0x172>
    while (read(fd, &de, sizeof(de)) == sizeof(de))
 108:	4641                	li	a2,16
 10a:	da040593          	addi	a1,s0,-608
 10e:	8526                	mv	a0,s1
 110:	00000097          	auipc	ra,0x0
 114:	3c0080e7          	jalr	960(ra) # 4d0 <read>
 118:	47c1                	li	a5,16
 11a:	0af51763          	bne	a0,a5,1c8 <find+0x1c8>
        if ((de.inum == 0)) //判断有没有文件
 11e:	da045783          	lhu	a5,-608(s0)
 122:	d3fd                	beqz	a5,108 <find+0x108>
        memmove(p, de.name, DIRSIZ); //添加路径名称
 124:	4639                	li	a2,14
 126:	da240593          	addi	a1,s0,-606
 12a:	8552                	mv	a0,s4
 12c:	00000097          	auipc	ra,0x0
 130:	2d6080e7          	jalr	726(ra) # 402 <memmove>
        p[DIRSIZ] = 0;               //字符串结束符
 134:	000907a3          	sb	zero,15(s2)
        if (stat(buf, &st) < 0)
 138:	d8840593          	addi	a1,s0,-632
 13c:	db040513          	addi	a0,s0,-592
 140:	00000097          	auipc	ra,0x0
 144:	232080e7          	jalr	562(ra) # 372 <stat>
 148:	02054e63          	bltz	a0,184 <find+0x184>
        if (st.type == T_DIR && strcmp(p, ".") != 0 && strcmp(p, "..") != 0)
 14c:	d9041783          	lh	a5,-624(s0)
 150:	05578663          	beq	a5,s5,19c <find+0x19c>
        else if (strcmp(filename, p) == 0)
 154:	85d2                	mv	a1,s4
 156:	854e                	mv	a0,s3
 158:	00000097          	auipc	ra,0x0
 15c:	106080e7          	jalr	262(ra) # 25e <strcmp>
 160:	f545                	bnez	a0,108 <find+0x108>
            printf("%s\n", buf);
 162:	db040593          	addi	a1,s0,-592
 166:	855e                	mv	a0,s7
 168:	00000097          	auipc	ra,0x0
 16c:	6c8080e7          	jalr	1736(ra) # 830 <printf>
 170:	bf61                	j	108 <find+0x108>
        printf("find: path too long\n");
 172:	00001517          	auipc	a0,0x1
 176:	8b650513          	addi	a0,a0,-1866 # a28 <malloc+0x13a>
 17a:	00000097          	auipc	ra,0x0
 17e:	6b6080e7          	jalr	1718(ra) # 830 <printf>
 182:	bf25                	j	ba <find+0xba>
            fprintf(2, "find:cannot stat %s\n", buf);
 184:	db040613          	addi	a2,s0,-592
 188:	00001597          	auipc	a1,0x1
 18c:	8b858593          	addi	a1,a1,-1864 # a40 <malloc+0x152>
 190:	4509                	li	a0,2
 192:	00000097          	auipc	ra,0x0
 196:	670080e7          	jalr	1648(ra) # 802 <fprintf>
            continue;
 19a:	b7bd                	j	108 <find+0x108>
        if (st.type == T_DIR && strcmp(p, ".") != 0 && strcmp(p, "..") != 0)
 19c:	85da                	mv	a1,s6
 19e:	8552                	mv	a0,s4
 1a0:	00000097          	auipc	ra,0x0
 1a4:	0be080e7          	jalr	190(ra) # 25e <strcmp>
 1a8:	d555                	beqz	a0,154 <find+0x154>
 1aa:	85e2                	mv	a1,s8
 1ac:	8552                	mv	a0,s4
 1ae:	00000097          	auipc	ra,0x0
 1b2:	0b0080e7          	jalr	176(ra) # 25e <strcmp>
 1b6:	dd59                	beqz	a0,154 <find+0x154>
            find(buf, filename);
 1b8:	85ce                	mv	a1,s3
 1ba:	db040513          	addi	a0,s0,-592
 1be:	00000097          	auipc	ra,0x0
 1c2:	e42080e7          	jalr	-446(ra) # 0 <find>
 1c6:	b789                	j	108 <find+0x108>
        }
    }
    close(fd);
 1c8:	8526                	mv	a0,s1
 1ca:	00000097          	auipc	ra,0x0
 1ce:	316080e7          	jalr	790(ra) # 4e0 <close>
}
 1d2:	27813083          	ld	ra,632(sp)
 1d6:	27013403          	ld	s0,624(sp)
 1da:	26813483          	ld	s1,616(sp)
 1de:	26013903          	ld	s2,608(sp)
 1e2:	25813983          	ld	s3,600(sp)
 1e6:	25013a03          	ld	s4,592(sp)
 1ea:	24813a83          	ld	s5,584(sp)
 1ee:	24013b03          	ld	s6,576(sp)
 1f2:	23813b83          	ld	s7,568(sp)
 1f6:	23013c03          	ld	s8,560(sp)
 1fa:	28010113          	addi	sp,sp,640
 1fe:	8082                	ret

0000000000000200 <main>:

int main(int agrc, char *agrv[])
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
    if (agrc != 3)
 208:	470d                	li	a4,3
 20a:	02e50063          	beq	a0,a4,22a <main+0x2a>
    {
        fprintf(2, "<usage>:<dir_name> <filename>\n");
 20e:	00000597          	auipc	a1,0x0
 212:	7fa58593          	addi	a1,a1,2042 # a08 <malloc+0x11a>
 216:	4509                	li	a0,2
 218:	00000097          	auipc	ra,0x0
 21c:	5ea080e7          	jalr	1514(ra) # 802 <fprintf>
        exit(1);
 220:	4505                	li	a0,1
 222:	00000097          	auipc	ra,0x0
 226:	296080e7          	jalr	662(ra) # 4b8 <exit>
 22a:	87ae                	mv	a5,a1
    }
    find(agrv[1], agrv[2]);
 22c:	698c                	ld	a1,16(a1)
 22e:	6788                	ld	a0,8(a5)
 230:	00000097          	auipc	ra,0x0
 234:	dd0080e7          	jalr	-560(ra) # 0 <find>
    exit(0);
 238:	4501                	li	a0,0
 23a:	00000097          	auipc	ra,0x0
 23e:	27e080e7          	jalr	638(ra) # 4b8 <exit>

0000000000000242 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 248:	87aa                	mv	a5,a0
 24a:	0585                	addi	a1,a1,1
 24c:	0785                	addi	a5,a5,1
 24e:	fff5c703          	lbu	a4,-1(a1)
 252:	fee78fa3          	sb	a4,-1(a5)
 256:	fb75                	bnez	a4,24a <strcpy+0x8>
    ;
  return os;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 264:	00054783          	lbu	a5,0(a0)
 268:	cb91                	beqz	a5,27c <strcmp+0x1e>
 26a:	0005c703          	lbu	a4,0(a1)
 26e:	00f71763          	bne	a4,a5,27c <strcmp+0x1e>
    p++, q++;
 272:	0505                	addi	a0,a0,1
 274:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 276:	00054783          	lbu	a5,0(a0)
 27a:	fbe5                	bnez	a5,26a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 27c:	0005c503          	lbu	a0,0(a1)
}
 280:	40a7853b          	subw	a0,a5,a0
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strlen>:

uint
strlen(const char *s)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 290:	00054783          	lbu	a5,0(a0)
 294:	cf91                	beqz	a5,2b0 <strlen+0x26>
 296:	0505                	addi	a0,a0,1
 298:	87aa                	mv	a5,a0
 29a:	4685                	li	a3,1
 29c:	9e89                	subw	a3,a3,a0
 29e:	00f6853b          	addw	a0,a3,a5
 2a2:	0785                	addi	a5,a5,1
 2a4:	fff7c703          	lbu	a4,-1(a5)
 2a8:	fb7d                	bnez	a4,29e <strlen+0x14>
    ;
  return n;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  for(n = 0; s[n]; n++)
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <strlen+0x20>

00000000000002b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ba:	ce09                	beqz	a2,2d4 <memset+0x20>
 2bc:	87aa                	mv	a5,a0
 2be:	fff6071b          	addiw	a4,a2,-1
 2c2:	1702                	slli	a4,a4,0x20
 2c4:	9301                	srli	a4,a4,0x20
 2c6:	0705                	addi	a4,a4,1
 2c8:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2ca:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2ce:	0785                	addi	a5,a5,1
 2d0:	fee79de3          	bne	a5,a4,2ca <memset+0x16>
  }
  return dst;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <strchr>:

char*
strchr(const char *s, char c)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2e0:	00054783          	lbu	a5,0(a0)
 2e4:	cb99                	beqz	a5,2fa <strchr+0x20>
    if(*s == c)
 2e6:	00f58763          	beq	a1,a5,2f4 <strchr+0x1a>
  for(; *s; s++)
 2ea:	0505                	addi	a0,a0,1
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	fbfd                	bnez	a5,2e6 <strchr+0xc>
      return (char*)s;
  return 0;
 2f2:	4501                	li	a0,0
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	bfe5                	j	2f4 <strchr+0x1a>

00000000000002fe <gets>:

char*
gets(char *buf, int max)
{
 2fe:	711d                	addi	sp,sp,-96
 300:	ec86                	sd	ra,88(sp)
 302:	e8a2                	sd	s0,80(sp)
 304:	e4a6                	sd	s1,72(sp)
 306:	e0ca                	sd	s2,64(sp)
 308:	fc4e                	sd	s3,56(sp)
 30a:	f852                	sd	s4,48(sp)
 30c:	f456                	sd	s5,40(sp)
 30e:	f05a                	sd	s6,32(sp)
 310:	ec5e                	sd	s7,24(sp)
 312:	1080                	addi	s0,sp,96
 314:	8baa                	mv	s7,a0
 316:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 318:	892a                	mv	s2,a0
 31a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 31c:	4aa9                	li	s5,10
 31e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 320:	89a6                	mv	s3,s1
 322:	2485                	addiw	s1,s1,1
 324:	0344d863          	bge	s1,s4,354 <gets+0x56>
    cc = read(0, &c, 1);
 328:	4605                	li	a2,1
 32a:	faf40593          	addi	a1,s0,-81
 32e:	4501                	li	a0,0
 330:	00000097          	auipc	ra,0x0
 334:	1a0080e7          	jalr	416(ra) # 4d0 <read>
    if(cc < 1)
 338:	00a05e63          	blez	a0,354 <gets+0x56>
    buf[i++] = c;
 33c:	faf44783          	lbu	a5,-81(s0)
 340:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 344:	01578763          	beq	a5,s5,352 <gets+0x54>
 348:	0905                	addi	s2,s2,1
 34a:	fd679be3          	bne	a5,s6,320 <gets+0x22>
  for(i=0; i+1 < max; ){
 34e:	89a6                	mv	s3,s1
 350:	a011                	j	354 <gets+0x56>
 352:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 354:	99de                	add	s3,s3,s7
 356:	00098023          	sb	zero,0(s3)
  return buf;
}
 35a:	855e                	mv	a0,s7
 35c:	60e6                	ld	ra,88(sp)
 35e:	6446                	ld	s0,80(sp)
 360:	64a6                	ld	s1,72(sp)
 362:	6906                	ld	s2,64(sp)
 364:	79e2                	ld	s3,56(sp)
 366:	7a42                	ld	s4,48(sp)
 368:	7aa2                	ld	s5,40(sp)
 36a:	7b02                	ld	s6,32(sp)
 36c:	6be2                	ld	s7,24(sp)
 36e:	6125                	addi	sp,sp,96
 370:	8082                	ret

0000000000000372 <stat>:

int
stat(const char *n, struct stat *st)
{
 372:	1101                	addi	sp,sp,-32
 374:	ec06                	sd	ra,24(sp)
 376:	e822                	sd	s0,16(sp)
 378:	e426                	sd	s1,8(sp)
 37a:	e04a                	sd	s2,0(sp)
 37c:	1000                	addi	s0,sp,32
 37e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 380:	4581                	li	a1,0
 382:	00000097          	auipc	ra,0x0
 386:	176080e7          	jalr	374(ra) # 4f8 <open>
  if(fd < 0)
 38a:	02054563          	bltz	a0,3b4 <stat+0x42>
 38e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 390:	85ca                	mv	a1,s2
 392:	00000097          	auipc	ra,0x0
 396:	17e080e7          	jalr	382(ra) # 510 <fstat>
 39a:	892a                	mv	s2,a0
  close(fd);
 39c:	8526                	mv	a0,s1
 39e:	00000097          	auipc	ra,0x0
 3a2:	142080e7          	jalr	322(ra) # 4e0 <close>
  return r;
}
 3a6:	854a                	mv	a0,s2
 3a8:	60e2                	ld	ra,24(sp)
 3aa:	6442                	ld	s0,16(sp)
 3ac:	64a2                	ld	s1,8(sp)
 3ae:	6902                	ld	s2,0(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret
    return -1;
 3b4:	597d                	li	s2,-1
 3b6:	bfc5                	j	3a6 <stat+0x34>

00000000000003b8 <atoi>:

int
atoi(const char *s)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e422                	sd	s0,8(sp)
 3bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3be:	00054603          	lbu	a2,0(a0)
 3c2:	fd06079b          	addiw	a5,a2,-48
 3c6:	0ff7f793          	andi	a5,a5,255
 3ca:	4725                	li	a4,9
 3cc:	02f76963          	bltu	a4,a5,3fe <atoi+0x46>
 3d0:	86aa                	mv	a3,a0
  n = 0;
 3d2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3d4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3d6:	0685                	addi	a3,a3,1
 3d8:	0025179b          	slliw	a5,a0,0x2
 3dc:	9fa9                	addw	a5,a5,a0
 3de:	0017979b          	slliw	a5,a5,0x1
 3e2:	9fb1                	addw	a5,a5,a2
 3e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e8:	0006c603          	lbu	a2,0(a3)
 3ec:	fd06071b          	addiw	a4,a2,-48
 3f0:	0ff77713          	andi	a4,a4,255
 3f4:	fee5f1e3          	bgeu	a1,a4,3d6 <atoi+0x1e>
  return n;
}
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret
  n = 0;
 3fe:	4501                	li	a0,0
 400:	bfe5                	j	3f8 <atoi+0x40>

0000000000000402 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 408:	02b57663          	bgeu	a0,a1,434 <memmove+0x32>
    while(n-- > 0)
 40c:	02c05163          	blez	a2,42e <memmove+0x2c>
 410:	fff6079b          	addiw	a5,a2,-1
 414:	1782                	slli	a5,a5,0x20
 416:	9381                	srli	a5,a5,0x20
 418:	0785                	addi	a5,a5,1
 41a:	97aa                	add	a5,a5,a0
  dst = vdst;
 41c:	872a                	mv	a4,a0
      *dst++ = *src++;
 41e:	0585                	addi	a1,a1,1
 420:	0705                	addi	a4,a4,1
 422:	fff5c683          	lbu	a3,-1(a1)
 426:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 42a:	fee79ae3          	bne	a5,a4,41e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 42e:	6422                	ld	s0,8(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret
    dst += n;
 434:	00c50733          	add	a4,a0,a2
    src += n;
 438:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 43a:	fec05ae3          	blez	a2,42e <memmove+0x2c>
 43e:	fff6079b          	addiw	a5,a2,-1
 442:	1782                	slli	a5,a5,0x20
 444:	9381                	srli	a5,a5,0x20
 446:	fff7c793          	not	a5,a5
 44a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 44c:	15fd                	addi	a1,a1,-1
 44e:	177d                	addi	a4,a4,-1
 450:	0005c683          	lbu	a3,0(a1)
 454:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 458:	fee79ae3          	bne	a5,a4,44c <memmove+0x4a>
 45c:	bfc9                	j	42e <memmove+0x2c>

000000000000045e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 45e:	1141                	addi	sp,sp,-16
 460:	e422                	sd	s0,8(sp)
 462:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 464:	ca05                	beqz	a2,494 <memcmp+0x36>
 466:	fff6069b          	addiw	a3,a2,-1
 46a:	1682                	slli	a3,a3,0x20
 46c:	9281                	srli	a3,a3,0x20
 46e:	0685                	addi	a3,a3,1
 470:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 472:	00054783          	lbu	a5,0(a0)
 476:	0005c703          	lbu	a4,0(a1)
 47a:	00e79863          	bne	a5,a4,48a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 47e:	0505                	addi	a0,a0,1
    p2++;
 480:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 482:	fed518e3          	bne	a0,a3,472 <memcmp+0x14>
  }
  return 0;
 486:	4501                	li	a0,0
 488:	a019                	j	48e <memcmp+0x30>
      return *p1 - *p2;
 48a:	40e7853b          	subw	a0,a5,a4
}
 48e:	6422                	ld	s0,8(sp)
 490:	0141                	addi	sp,sp,16
 492:	8082                	ret
  return 0;
 494:	4501                	li	a0,0
 496:	bfe5                	j	48e <memcmp+0x30>

0000000000000498 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 498:	1141                	addi	sp,sp,-16
 49a:	e406                	sd	ra,8(sp)
 49c:	e022                	sd	s0,0(sp)
 49e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a0:	00000097          	auipc	ra,0x0
 4a4:	f62080e7          	jalr	-158(ra) # 402 <memmove>
}
 4a8:	60a2                	ld	ra,8(sp)
 4aa:	6402                	ld	s0,0(sp)
 4ac:	0141                	addi	sp,sp,16
 4ae:	8082                	ret

00000000000004b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b0:	4885                	li	a7,1
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b8:	4889                	li	a7,2
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c0:	488d                	li	a7,3
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c8:	4891                	li	a7,4
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <read>:
.global read
read:
 li a7, SYS_read
 4d0:	4895                	li	a7,5
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <write>:
.global write
write:
 li a7, SYS_write
 4d8:	48c1                	li	a7,16
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <close>:
.global close
close:
 li a7, SYS_close
 4e0:	48d5                	li	a7,21
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e8:	4899                	li	a7,6
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f0:	489d                	li	a7,7
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <open>:
.global open
open:
 li a7, SYS_open
 4f8:	48bd                	li	a7,15
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 500:	48c5                	li	a7,17
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 508:	48c9                	li	a7,18
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 510:	48a1                	li	a7,8
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <link>:
.global link
link:
 li a7, SYS_link
 518:	48cd                	li	a7,19
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 520:	48d1                	li	a7,20
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 528:	48a5                	li	a7,9
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <dup>:
.global dup
dup:
 li a7, SYS_dup
 530:	48a9                	li	a7,10
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 538:	48ad                	li	a7,11
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 540:	48b1                	li	a7,12
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 548:	48b5                	li	a7,13
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 550:	48b9                	li	a7,14
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 558:	1101                	addi	sp,sp,-32
 55a:	ec06                	sd	ra,24(sp)
 55c:	e822                	sd	s0,16(sp)
 55e:	1000                	addi	s0,sp,32
 560:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 564:	4605                	li	a2,1
 566:	fef40593          	addi	a1,s0,-17
 56a:	00000097          	auipc	ra,0x0
 56e:	f6e080e7          	jalr	-146(ra) # 4d8 <write>
}
 572:	60e2                	ld	ra,24(sp)
 574:	6442                	ld	s0,16(sp)
 576:	6105                	addi	sp,sp,32
 578:	8082                	ret

000000000000057a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57a:	7139                	addi	sp,sp,-64
 57c:	fc06                	sd	ra,56(sp)
 57e:	f822                	sd	s0,48(sp)
 580:	f426                	sd	s1,40(sp)
 582:	f04a                	sd	s2,32(sp)
 584:	ec4e                	sd	s3,24(sp)
 586:	0080                	addi	s0,sp,64
 588:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58a:	c299                	beqz	a3,590 <printint+0x16>
 58c:	0805c863          	bltz	a1,61c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 590:	2581                	sext.w	a1,a1
  neg = 0;
 592:	4881                	li	a7,0
 594:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 598:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 59a:	2601                	sext.w	a2,a2
 59c:	00000517          	auipc	a0,0x0
 5a0:	4d450513          	addi	a0,a0,1236 # a70 <digits>
 5a4:	883a                	mv	a6,a4
 5a6:	2705                	addiw	a4,a4,1
 5a8:	02c5f7bb          	remuw	a5,a1,a2
 5ac:	1782                	slli	a5,a5,0x20
 5ae:	9381                	srli	a5,a5,0x20
 5b0:	97aa                	add	a5,a5,a0
 5b2:	0007c783          	lbu	a5,0(a5)
 5b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ba:	0005879b          	sext.w	a5,a1
 5be:	02c5d5bb          	divuw	a1,a1,a2
 5c2:	0685                	addi	a3,a3,1
 5c4:	fec7f0e3          	bgeu	a5,a2,5a4 <printint+0x2a>
  if(neg)
 5c8:	00088b63          	beqz	a7,5de <printint+0x64>
    buf[i++] = '-';
 5cc:	fd040793          	addi	a5,s0,-48
 5d0:	973e                	add	a4,a4,a5
 5d2:	02d00793          	li	a5,45
 5d6:	fef70823          	sb	a5,-16(a4)
 5da:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5de:	02e05863          	blez	a4,60e <printint+0x94>
 5e2:	fc040793          	addi	a5,s0,-64
 5e6:	00e78933          	add	s2,a5,a4
 5ea:	fff78993          	addi	s3,a5,-1
 5ee:	99ba                	add	s3,s3,a4
 5f0:	377d                	addiw	a4,a4,-1
 5f2:	1702                	slli	a4,a4,0x20
 5f4:	9301                	srli	a4,a4,0x20
 5f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fa:	fff94583          	lbu	a1,-1(s2)
 5fe:	8526                	mv	a0,s1
 600:	00000097          	auipc	ra,0x0
 604:	f58080e7          	jalr	-168(ra) # 558 <putc>
  while(--i >= 0)
 608:	197d                	addi	s2,s2,-1
 60a:	ff3918e3          	bne	s2,s3,5fa <printint+0x80>
}
 60e:	70e2                	ld	ra,56(sp)
 610:	7442                	ld	s0,48(sp)
 612:	74a2                	ld	s1,40(sp)
 614:	7902                	ld	s2,32(sp)
 616:	69e2                	ld	s3,24(sp)
 618:	6121                	addi	sp,sp,64
 61a:	8082                	ret
    x = -xx;
 61c:	40b005bb          	negw	a1,a1
    neg = 1;
 620:	4885                	li	a7,1
    x = -xx;
 622:	bf8d                	j	594 <printint+0x1a>

0000000000000624 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 624:	7119                	addi	sp,sp,-128
 626:	fc86                	sd	ra,120(sp)
 628:	f8a2                	sd	s0,112(sp)
 62a:	f4a6                	sd	s1,104(sp)
 62c:	f0ca                	sd	s2,96(sp)
 62e:	ecce                	sd	s3,88(sp)
 630:	e8d2                	sd	s4,80(sp)
 632:	e4d6                	sd	s5,72(sp)
 634:	e0da                	sd	s6,64(sp)
 636:	fc5e                	sd	s7,56(sp)
 638:	f862                	sd	s8,48(sp)
 63a:	f466                	sd	s9,40(sp)
 63c:	f06a                	sd	s10,32(sp)
 63e:	ec6e                	sd	s11,24(sp)
 640:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 642:	0005c903          	lbu	s2,0(a1)
 646:	18090f63          	beqz	s2,7e4 <vprintf+0x1c0>
 64a:	8aaa                	mv	s5,a0
 64c:	8b32                	mv	s6,a2
 64e:	00158493          	addi	s1,a1,1
  state = 0;
 652:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 654:	02500a13          	li	s4,37
      if(c == 'd'){
 658:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 65c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 660:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 664:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 668:	00000b97          	auipc	s7,0x0
 66c:	408b8b93          	addi	s7,s7,1032 # a70 <digits>
 670:	a839                	j	68e <vprintf+0x6a>
        putc(fd, c);
 672:	85ca                	mv	a1,s2
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	ee2080e7          	jalr	-286(ra) # 558 <putc>
 67e:	a019                	j	684 <vprintf+0x60>
    } else if(state == '%'){
 680:	01498f63          	beq	s3,s4,69e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 684:	0485                	addi	s1,s1,1
 686:	fff4c903          	lbu	s2,-1(s1)
 68a:	14090d63          	beqz	s2,7e4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 68e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 692:	fe0997e3          	bnez	s3,680 <vprintf+0x5c>
      if(c == '%'){
 696:	fd479ee3          	bne	a5,s4,672 <vprintf+0x4e>
        state = '%';
 69a:	89be                	mv	s3,a5
 69c:	b7e5                	j	684 <vprintf+0x60>
      if(c == 'd'){
 69e:	05878063          	beq	a5,s8,6de <vprintf+0xba>
      } else if(c == 'l') {
 6a2:	05978c63          	beq	a5,s9,6fa <vprintf+0xd6>
      } else if(c == 'x') {
 6a6:	07a78863          	beq	a5,s10,716 <vprintf+0xf2>
      } else if(c == 'p') {
 6aa:	09b78463          	beq	a5,s11,732 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6ae:	07300713          	li	a4,115
 6b2:	0ce78663          	beq	a5,a4,77e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6b6:	06300713          	li	a4,99
 6ba:	0ee78e63          	beq	a5,a4,7b6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6be:	11478863          	beq	a5,s4,7ce <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c2:	85d2                	mv	a1,s4
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e92080e7          	jalr	-366(ra) # 558 <putc>
        putc(fd, c);
 6ce:	85ca                	mv	a1,s2
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e86080e7          	jalr	-378(ra) # 558 <putc>
      }
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b765                	j	684 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6de:	008b0913          	addi	s2,s6,8
 6e2:	4685                	li	a3,1
 6e4:	4629                	li	a2,10
 6e6:	000b2583          	lw	a1,0(s6)
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e8e080e7          	jalr	-370(ra) # 57a <printint>
 6f4:	8b4a                	mv	s6,s2
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b771                	j	684 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fa:	008b0913          	addi	s2,s6,8
 6fe:	4681                	li	a3,0
 700:	4629                	li	a2,10
 702:	000b2583          	lw	a1,0(s6)
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	e72080e7          	jalr	-398(ra) # 57a <printint>
 710:	8b4a                	mv	s6,s2
      state = 0;
 712:	4981                	li	s3,0
 714:	bf85                	j	684 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 716:	008b0913          	addi	s2,s6,8
 71a:	4681                	li	a3,0
 71c:	4641                	li	a2,16
 71e:	000b2583          	lw	a1,0(s6)
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	e56080e7          	jalr	-426(ra) # 57a <printint>
 72c:	8b4a                	mv	s6,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	bf91                	j	684 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 732:	008b0793          	addi	a5,s6,8
 736:	f8f43423          	sd	a5,-120(s0)
 73a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 73e:	03000593          	li	a1,48
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	e14080e7          	jalr	-492(ra) # 558 <putc>
  putc(fd, 'x');
 74c:	85ea                	mv	a1,s10
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e08080e7          	jalr	-504(ra) # 558 <putc>
 758:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75a:	03c9d793          	srli	a5,s3,0x3c
 75e:	97de                	add	a5,a5,s7
 760:	0007c583          	lbu	a1,0(a5)
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	df2080e7          	jalr	-526(ra) # 558 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 76e:	0992                	slli	s3,s3,0x4
 770:	397d                	addiw	s2,s2,-1
 772:	fe0914e3          	bnez	s2,75a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 776:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 77a:	4981                	li	s3,0
 77c:	b721                	j	684 <vprintf+0x60>
        s = va_arg(ap, char*);
 77e:	008b0993          	addi	s3,s6,8
 782:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 786:	02090163          	beqz	s2,7a8 <vprintf+0x184>
        while(*s != 0){
 78a:	00094583          	lbu	a1,0(s2)
 78e:	c9a1                	beqz	a1,7de <vprintf+0x1ba>
          putc(fd, *s);
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	dc6080e7          	jalr	-570(ra) # 558 <putc>
          s++;
 79a:	0905                	addi	s2,s2,1
        while(*s != 0){
 79c:	00094583          	lbu	a1,0(s2)
 7a0:	f9e5                	bnez	a1,790 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7a2:	8b4e                	mv	s6,s3
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	bdf9                	j	684 <vprintf+0x60>
          s = "(null)";
 7a8:	00000917          	auipc	s2,0x0
 7ac:	2c090913          	addi	s2,s2,704 # a68 <malloc+0x17a>
        while(*s != 0){
 7b0:	02800593          	li	a1,40
 7b4:	bff1                	j	790 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7b6:	008b0913          	addi	s2,s6,8
 7ba:	000b4583          	lbu	a1,0(s6)
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	d98080e7          	jalr	-616(ra) # 558 <putc>
 7c8:	8b4a                	mv	s6,s2
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bd65                	j	684 <vprintf+0x60>
        putc(fd, c);
 7ce:	85d2                	mv	a1,s4
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	d86080e7          	jalr	-634(ra) # 558 <putc>
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b565                	j	684 <vprintf+0x60>
        s = va_arg(ap, char*);
 7de:	8b4e                	mv	s6,s3
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b54d                	j	684 <vprintf+0x60>
    }
  }
}
 7e4:	70e6                	ld	ra,120(sp)
 7e6:	7446                	ld	s0,112(sp)
 7e8:	74a6                	ld	s1,104(sp)
 7ea:	7906                	ld	s2,96(sp)
 7ec:	69e6                	ld	s3,88(sp)
 7ee:	6a46                	ld	s4,80(sp)
 7f0:	6aa6                	ld	s5,72(sp)
 7f2:	6b06                	ld	s6,64(sp)
 7f4:	7be2                	ld	s7,56(sp)
 7f6:	7c42                	ld	s8,48(sp)
 7f8:	7ca2                	ld	s9,40(sp)
 7fa:	7d02                	ld	s10,32(sp)
 7fc:	6de2                	ld	s11,24(sp)
 7fe:	6109                	addi	sp,sp,128
 800:	8082                	ret

0000000000000802 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 802:	715d                	addi	sp,sp,-80
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	1000                	addi	s0,sp,32
 80a:	e010                	sd	a2,0(s0)
 80c:	e414                	sd	a3,8(s0)
 80e:	e818                	sd	a4,16(s0)
 810:	ec1c                	sd	a5,24(s0)
 812:	03043023          	sd	a6,32(s0)
 816:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 81e:	8622                	mv	a2,s0
 820:	00000097          	auipc	ra,0x0
 824:	e04080e7          	jalr	-508(ra) # 624 <vprintf>
}
 828:	60e2                	ld	ra,24(sp)
 82a:	6442                	ld	s0,16(sp)
 82c:	6161                	addi	sp,sp,80
 82e:	8082                	ret

0000000000000830 <printf>:

void
printf(const char *fmt, ...)
{
 830:	711d                	addi	sp,sp,-96
 832:	ec06                	sd	ra,24(sp)
 834:	e822                	sd	s0,16(sp)
 836:	1000                	addi	s0,sp,32
 838:	e40c                	sd	a1,8(s0)
 83a:	e810                	sd	a2,16(s0)
 83c:	ec14                	sd	a3,24(s0)
 83e:	f018                	sd	a4,32(s0)
 840:	f41c                	sd	a5,40(s0)
 842:	03043823          	sd	a6,48(s0)
 846:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84a:	00840613          	addi	a2,s0,8
 84e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 852:	85aa                	mv	a1,a0
 854:	4505                	li	a0,1
 856:	00000097          	auipc	ra,0x0
 85a:	dce080e7          	jalr	-562(ra) # 624 <vprintf>
}
 85e:	60e2                	ld	ra,24(sp)
 860:	6442                	ld	s0,16(sp)
 862:	6125                	addi	sp,sp,96
 864:	8082                	ret

0000000000000866 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 866:	1141                	addi	sp,sp,-16
 868:	e422                	sd	s0,8(sp)
 86a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	00000797          	auipc	a5,0x0
 874:	2187b783          	ld	a5,536(a5) # a88 <freep>
 878:	a805                	j	8a8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 87a:	4618                	lw	a4,8(a2)
 87c:	9db9                	addw	a1,a1,a4
 87e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	6318                	ld	a4,0(a4)
 886:	fee53823          	sd	a4,-16(a0)
 88a:	a091                	j	8ce <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 88c:	ff852703          	lw	a4,-8(a0)
 890:	9e39                	addw	a2,a2,a4
 892:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 894:	ff053703          	ld	a4,-16(a0)
 898:	e398                	sd	a4,0(a5)
 89a:	a099                	j	8e0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89c:	6398                	ld	a4,0(a5)
 89e:	00e7e463          	bltu	a5,a4,8a6 <free+0x40>
 8a2:	00e6ea63          	bltu	a3,a4,8b6 <free+0x50>
{
 8a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a8:	fed7fae3          	bgeu	a5,a3,89c <free+0x36>
 8ac:	6398                	ld	a4,0(a5)
 8ae:	00e6e463          	bltu	a3,a4,8b6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	fee7eae3          	bltu	a5,a4,8a6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8b6:	ff852583          	lw	a1,-8(a0)
 8ba:	6390                	ld	a2,0(a5)
 8bc:	02059713          	slli	a4,a1,0x20
 8c0:	9301                	srli	a4,a4,0x20
 8c2:	0712                	slli	a4,a4,0x4
 8c4:	9736                	add	a4,a4,a3
 8c6:	fae60ae3          	beq	a2,a4,87a <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ce:	4790                	lw	a2,8(a5)
 8d0:	02061713          	slli	a4,a2,0x20
 8d4:	9301                	srli	a4,a4,0x20
 8d6:	0712                	slli	a4,a4,0x4
 8d8:	973e                	add	a4,a4,a5
 8da:	fae689e3          	beq	a3,a4,88c <free+0x26>
  } else
    p->s.ptr = bp;
 8de:	e394                	sd	a3,0(a5)
  freep = p;
 8e0:	00000717          	auipc	a4,0x0
 8e4:	1af73423          	sd	a5,424(a4) # a88 <freep>
}
 8e8:	6422                	ld	s0,8(sp)
 8ea:	0141                	addi	sp,sp,16
 8ec:	8082                	ret

00000000000008ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ee:	7139                	addi	sp,sp,-64
 8f0:	fc06                	sd	ra,56(sp)
 8f2:	f822                	sd	s0,48(sp)
 8f4:	f426                	sd	s1,40(sp)
 8f6:	f04a                	sd	s2,32(sp)
 8f8:	ec4e                	sd	s3,24(sp)
 8fa:	e852                	sd	s4,16(sp)
 8fc:	e456                	sd	s5,8(sp)
 8fe:	e05a                	sd	s6,0(sp)
 900:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 902:	02051493          	slli	s1,a0,0x20
 906:	9081                	srli	s1,s1,0x20
 908:	04bd                	addi	s1,s1,15
 90a:	8091                	srli	s1,s1,0x4
 90c:	0014899b          	addiw	s3,s1,1
 910:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 912:	00000517          	auipc	a0,0x0
 916:	17653503          	ld	a0,374(a0) # a88 <freep>
 91a:	c515                	beqz	a0,946 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91e:	4798                	lw	a4,8(a5)
 920:	02977f63          	bgeu	a4,s1,95e <malloc+0x70>
 924:	8a4e                	mv	s4,s3
 926:	0009871b          	sext.w	a4,s3
 92a:	6685                	lui	a3,0x1
 92c:	00d77363          	bgeu	a4,a3,932 <malloc+0x44>
 930:	6a05                	lui	s4,0x1
 932:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 936:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93a:	00000917          	auipc	s2,0x0
 93e:	14e90913          	addi	s2,s2,334 # a88 <freep>
  if(p == (char*)-1)
 942:	5afd                	li	s5,-1
 944:	a88d                	j	9b6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 946:	00000797          	auipc	a5,0x0
 94a:	14a78793          	addi	a5,a5,330 # a90 <base>
 94e:	00000717          	auipc	a4,0x0
 952:	12f73d23          	sd	a5,314(a4) # a88 <freep>
 956:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 958:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95c:	b7e1                	j	924 <malloc+0x36>
      if(p->s.size == nunits)
 95e:	02e48b63          	beq	s1,a4,994 <malloc+0xa6>
        p->s.size -= nunits;
 962:	4137073b          	subw	a4,a4,s3
 966:	c798                	sw	a4,8(a5)
        p += p->s.size;
 968:	1702                	slli	a4,a4,0x20
 96a:	9301                	srli	a4,a4,0x20
 96c:	0712                	slli	a4,a4,0x4
 96e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 970:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 974:	00000717          	auipc	a4,0x0
 978:	10a73a23          	sd	a0,276(a4) # a88 <freep>
      return (void*)(p + 1);
 97c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 980:	70e2                	ld	ra,56(sp)
 982:	7442                	ld	s0,48(sp)
 984:	74a2                	ld	s1,40(sp)
 986:	7902                	ld	s2,32(sp)
 988:	69e2                	ld	s3,24(sp)
 98a:	6a42                	ld	s4,16(sp)
 98c:	6aa2                	ld	s5,8(sp)
 98e:	6b02                	ld	s6,0(sp)
 990:	6121                	addi	sp,sp,64
 992:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 994:	6398                	ld	a4,0(a5)
 996:	e118                	sd	a4,0(a0)
 998:	bff1                	j	974 <malloc+0x86>
  hp->s.size = nu;
 99a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99e:	0541                	addi	a0,a0,16
 9a0:	00000097          	auipc	ra,0x0
 9a4:	ec6080e7          	jalr	-314(ra) # 866 <free>
  return freep;
 9a8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ac:	d971                	beqz	a0,980 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b0:	4798                	lw	a4,8(a5)
 9b2:	fa9776e3          	bgeu	a4,s1,95e <malloc+0x70>
    if(p == freep)
 9b6:	00093703          	ld	a4,0(s2)
 9ba:	853e                	mv	a0,a5
 9bc:	fef719e3          	bne	a4,a5,9ae <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9c0:	8552                	mv	a0,s4
 9c2:	00000097          	auipc	ra,0x0
 9c6:	b7e080e7          	jalr	-1154(ra) # 540 <sbrk>
  if(p == (char*)-1)
 9ca:	fd5518e3          	bne	a0,s5,99a <malloc+0xac>
        return 0;
 9ce:	4501                	li	a0,0
 9d0:	bf45                	j	980 <malloc+0x92>
