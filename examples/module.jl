# sorts M, A
# operations m: M,M -> M
#            a: M,A -> A
# equations  a(m(x,y),t) = a(x,a(y,t))

module_pres = Presentation(
    2,
    [([1,1],1), ([1,2],2)],
    [(Context([1,1,2]),
      (Appl(2, [Appl(1, [Var(1), Var(2)]), Var(3)]),
       Appl(2, [Var(1), Appl(2, [Var(2), Var(3)])]))
      )]
)
