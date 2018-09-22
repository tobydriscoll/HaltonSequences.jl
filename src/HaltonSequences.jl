module HaltonSequences

using Primes
export haltonvalue,Halton,HaltonPoint

const MAXLEN = typemax(UInt32)

"""
    haltonvalue(n, base[, T])

Return the `n`th element of the Halton sequence with prime base `base` (defaults to 2). If
a `<:Real` type `T` is given, compute the value in that type.

# Examples
```jldoctest
julia> haltonvalue(4,3,Rational)
4//9
```
"""
function haltonvalue(n::Integer,base::Integer=2,T::Type=float(Int))
    haltonvalue!(zero(T),n,base)
end

function haltonvalue!(x::Real,n::Integer,base::Integer=2)
    x = zero(x)
    s = one(x)
    while n > 0
        s /= base
        n,r = divrem(n,base)
        x += s*r
    end
    return x
end

const val = haltonvalue  # for terser qualified uses

########################################################
# Vector of Halton sequence values
########################################################
"""
    Halton(base=2; <keyword arguments>)
    Halton{T<:Real}(base=2; <keyword arguments>)

Create a `Vector`-like object for a Halton sequence. Optionally, use a `<:Real` type
`T` for the elements.

# Arguments
- `base::Integer`: prime number base for the sequence
- `start=1` (keyword): starting/offset index
- `length=typemax(UInt32)` (keyword): length of the sequence vector

# Examples
```jldoctest
julia> Halton(3,length=4)
4-element Halton{Float64}:
 0.3333333333333333
 0.6666666666666666
 0.1111111111111111
 0.4444444444444444
```
```jldoctest
julia> Halton{Rational}(2,length=7)
7-element Halton{Rational}:
 1//2
 1//4
 3//4
 1//8
 5//8
 3//8
 7//8
```
```jldoctest
julia> sum( Halton()[1:10000] )/10000
0.4998324768066406
```

 See also: [`HaltonPoint`](@ref), [`haltonvalue`](@ref)
"""
struct Halton{T<:Real} <: AbstractArray{T, 1}
    base::Int
    start::Int
    length::Int
    # Constructor for when the type is explicit.
    function Halton{T}(base::Integer=2;start=1,length=MAXLEN) where {T<:Real}
        new(base,start,length)
    end
end

# Constructor when no type given. Also includes a check for prime base.
function Halton(base::Integer=2;kw...)
    isprime(base) || error("Base must be a prime number.")
    Halton{float(Int)}(base;kw...)
end

# Serve the AbstractArray interface
Base.size(H::Halton) = (H.length,)
Base.IndexStyle(::Type{<:Halton}) = IndexLinear()
function Base.getindex(H::Halton{T}, n::Integer) where T
    n <= H.length || throw(BoundsError(H,n))
    haltonvalue(n+H.start-1,H.base,T)
end

########################################################
# Vector of multidimensional points based on different bases
########################################################
"""
    HaltonPoint(ndim::Integer; <keyword arguments>)
    HaltonPoint(base::Vector{<:Integer}; <keyword arguments>)
    HaltonPoint{T<:Real}(base::Vector{<:Integer}; <keyword arguments>)

Create a `Vector`-like object for a sequence of `ndim`-dimensional vectors constructed
from Halton sequences. If given, `base` should be a vector of primes and then
`ndim=length(base)`. If `T` is given, it is the element type for the vectors.

# Keyword arguments
- `start=1`: starting/offset index
- `length=typemax(UInt32)`: length of the sequence vector

# Examples
```jldoctest
julia> HaltonPoint(4,length=5)
5-element HaltonPoint{Float64}:
 [0.5, 0.333333, 0.2, 0.142857]
 [0.25, 0.666667, 0.4, 0.285714]
 [0.75, 0.111111, 0.6, 0.428571]
 [0.125, 0.444444, 0.8, 0.571429]
 [0.625, 0.777778, 0.04, 0.714286]
```
```jldoctest
julia> h = HaltonPoint([5,11,17]);  sum(h[10001:20000])/10000
3-element Array{Float64,1}:
 0.49996162048000015
 0.5000650725546567
 0.49992980926952507
```

 See also: [`Halton`](@ref), [`haltonvalue`](@ref)
"""
struct HaltonPoint{T<:Real} <: AbstractArray{T, 1}
    base::Vector{Int}
    start::Int
    length::Int
    # Constructor when the type and base are explicit.
    function HaltonPoint{T}(base::Vector{S};start=1,length=MAXLEN) where {T<:Real} where {S<:Integer}
        new(base,start,length)
    end
    # Constructor when the type is explicit, but bases are not given.
    function HaltonPoint{T}(ndim=Integer;kw...) where {T<:Real}
        function firstprimes(k::Integer)
            n = zeros(UInt16,k)
            n[1] = 2
            for i = 2:k
                n[i] = nextprime(n[i-1]+1)
            end
            return n
        end
        HaltonPoint{T}(firstprimes(ndim);kw...)
    end
end

# Constructor when the type is not given.
HaltonPoint(b_or_n;kw...) = HaltonPoint{float(Int)}(b_or_n;kw...)

# Serve the AbstractArray interface
Base.size(P::HaltonPoint) = (P.length,)
Base.IndexStyle(::Type{<:HaltonPoint}) = IndexLinear()
Base.eltype(::HaltonPoint{T}) where T = Vector{T}
function Base.getindex(P::HaltonPoint{T}, n::Integer) where T
    [ haltonvalue(n+P.start-1,P.base[i],T) for i in eachindex(P.base) ]
end
# This seems to be needed for range/vector indexing, since the eltype is not scalar.
function Base.getindex(P::HaltonPoint{T}, n::Union{AbstractVector,AbstractRange}) where T
    [ P[n[i]] for i in eachindex(n) ]
end

end # module
