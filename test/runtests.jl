using Test
using HaltonSequences

@testset "values" begin
    @test haltonvalue(1,2) ≈ 0.5
    @test haltonvalue(111111,2) ≈ 0.876182556152344
    @test haltonvalue(789,19) ≈ 0.534917626476163
    @test Halton{Rational}(17)[24] == 120//289
end

@testset "integrals" begin
    @test sum( Halton(5)[100:20100] )/20000 ≈ 0.5 atol=0.002
    p = HaltonPoint(4,length=32000)
    @test sum(p)/32000 ≈ [0.5,0.5,0.5,0.5] atol=0.001
    h = Halton{Float32}(29,start=1234,length=22000)
    @test sum( h.^2 )/22000 ≈ 1/3 atol=0.001
end
