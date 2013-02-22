#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int
main (int argc, char *argv[])
{
  /* No argument checking done.
     Called from rndimg.sh

     First and second args are positive integers, third argument is filename */

  unsigned int w = atoi(argv[1]);
  unsigned int h = atoi(argv[2]);
  const char *ppm = argv[3];
  unsigned int i, j;

  FILE *ppmf = fopen (ppm, "w");

  struct timeval tv;
  gettimeofday (&tv, NULL);
  srand ((unsigned int) (tv.tv_sec ^ tv.tv_usec));

  if (!ppmf)
    return 1;

  fprintf (ppmf, "P3\n");
  fprintf (ppmf, "%d\n", w);
  fprintf (ppmf, "%d\n", h);
  fprintf (ppmf, "255\n");

  for (i = 0; i < h; i++)
    {
      for (j = 0; j < w; j++)
        fprintf (ppmf, "%d %d %d ", rand() % 256, rand() % 256, rand() % 256);
      fprintf (ppmf, "\n");
    }

  fclose (ppmf);

  return 0;
}
