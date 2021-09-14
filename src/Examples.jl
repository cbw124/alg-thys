module Examples
export UnlabeledModule

using ..Theories

UnlabeledModule = UnlabeledPresentation(
  [(),()],
  [Operation([1,1],1), Operation([1,2],2)],
  [UnlabeledEquation(
    UnlabeledContext([1,1,2]),
    Appl(2, [Appl(1, [Var(1), Var(2)]), Var(3)]),
    Appl(2, [Var(1), Appl(2, [Var(2), Var(3)])])
  )]
)

end
