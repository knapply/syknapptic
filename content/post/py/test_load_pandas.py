def square(x):
  return x**2

def evens(x):
  y = []
  for i in x:
    if i // 2 == 0:
      y.append(i)
  return(y)


def ceci_nest_pas_une_pipe(args, *funs):
  for arg in args:
    for fun in funs:
      arg = fun(arg)
  return arg

ceci_nest_pas_une_pipe([1, 2, 3, 4], even)
