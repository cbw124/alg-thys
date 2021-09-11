using AlgThys
using AlgThys.Examples
using Test

@testset "AlgThys" begin
  @test check_presentation(module_pres)
end
