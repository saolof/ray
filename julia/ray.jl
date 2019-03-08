// Translated from the Ray Tracer Language Comparison
// http://www.ffconsultancy.com/languages/ray_tracer/benchmark.html

import Printf
import LinearAlgebra: dot
import StaticArrays: SVector

struct Hit
    l ::Float64
    d ::SVector{3,Float64}
end

struct Scene
    c ::SVector{3,Float64}
    r ::Float64
    ss ::Array{Scene, 1}
end

unitise(u) = u / sqrt(dot(u, u))

function inter(o, d, hit, s)
    v = s.c - o
    b = dot(v, d)
    disc = b^2 - dot(v, v) + s.r^2
    disc = (disc < 0. ? NaN : sqrt(disc))
    t1 = b - disc
    t2 = b + disc
    l = (t2 > 0. ? (t1 > 0. ? t1 : t2) : Inf)
    if l > hit.l
        return hit
    else
        if size(s.ss, 1) == 0
            return Hit(l, unitise(o + l*d - s.c))
        else
            for s in s.ss
                hit = inter(o, d, hit, s)
            end
            return hit
        end
    end
end

const light = unitise(SVector(1., 3., -2.))
const ss = 4

function create(level, c, r)
    obj = Scene(c, r, [])
    if level == 1
        return obj
    else
        a = 3*r/sqrt(12)
        aux(x, z) = create(level-1, c + SVector(x, a, z), r/2)
        Scene(c, 3*r, [obj, aux(-a, -a), aux(a, -a), aux(-a, a), aux(a, a)])
    end
end

const level = 9

const scene = create(level, SVector(0., -1., 4.), 1)

const zero3 = SVector(0., 0., 0.)
const hit0 = Hit(Inf, zero3)

function raytrace(dir)
    hit = inter(zero3, dir, hit0, scene)
    g = dot(hit.d, light)
    if g < 0.
        return 0
    else
        p = hit.l * dir + sqrt(eps(1.0)) * hit.d
        return (inter(p, light, hit0, scene).l < Inf ? 0 : g)
    end
end

aux(x,n,d) = x - n/2 + d/ss

function main(n)
    Printf.@printf("P5\n%d %d\n255", n, n)
    for y in n-1:-1:0
        for x in 0:n-1
            g = 0
            for d in 0:ss^2-1
                g = g + raytrace(unitise(SVector(aux(x, n, d%ss), aux(y,n , d/ss), convert(Float64, n))))
            end
            g = round(255*g/ss^2)
            write(stdout, (isnan(g) ? 0x00 : convert(UInt8, g)))
        end
    end
end

n = 16
main(n)
