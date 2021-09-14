using AlgThys
using AlgThys.Examples
using Test

@testset "AlgThys" begin
  @test check_presentation(UnlabeledModule)

  @present Module begin
    A::SORT
    S::SORT
    m::((A,A) -> A)
    ap::((A,S) -> S)
    assoc::(ap(m(x,y),z) == ap(x,ap(y,z)) ⊣ (x::A,y::A,z::S))
  end

  @test check_presentation(unlabel(Module))
end
