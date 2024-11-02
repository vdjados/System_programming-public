#include <stdio.h>
#include <stdlib.h>

extern long *init_queue();
extern long *free_queue();
extern long q_push(long);
extern long q_pop();
extern void rand_fill(long);
extern long count_even_numbers();
extern long ends_with_one();
extern long count_odd();

int main() {
  long *arr, n, cap;
  scanf("%ld", &n);
  arr = init_queue(n);
  if (arr == NULL) {
    fprintf(stderr, "Ошибка выделения памяти\n");
    return 1;
  }

  cap = 5;
  rand_fill(cap);

  for (int i = 0; i < cap; i++) {
    printf("%ld\n", arr[i]);
  }

  printf("even=%ld ones=%ld odd=%ld\n\n", count_even_numbers(),
         ends_with_one(), count_odd());

  for (int i = cap; i < n; i++) {
    q_push(i);
  }

  for (int i = 0; i < n; i++) {
    printf("%ld\n", arr[i]);
  }

  printf("poped=%ld\n", q_pop());
  printf("poped=%ld\n", q_pop());

  free_queue();

  return 0;
}
