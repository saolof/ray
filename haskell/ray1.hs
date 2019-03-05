import System
infinity = 1/0
epsilon_float = e where e = encodeFloat (floatRadix e) (-floatDigits e)

infixl 7 .*, *|
data Vector = V !Double !Double !Double deriving (Show, Eq)
s *| V x y z = V (s * x) (s * y) (s * z)
instance Num Vector where
    V x y z + V x' y' z' = V (x + x') (y + y') (z + z')
    V x y z - V x' y' z' = V (x - x') (y - y') (z - z')
    fromInteger i = V x x x where x = fromInteger i
V x y z .* V x' y' z' = x * x' + y * y' + z * z'
unitise r = 1 / sqrt (r .* r) *| r

data Scene = S !Vector !Double [Scene]
intersect o d hit@(l, _) (S c r s) =
  let v = c - o
      b = v .* d
      disc = sqrt (b * b - v .* v + r * r)
      t1 = b - disc; t2 = b + disc
      l' = if t2>0 then if t1>0 then t1 else t2 else infinity
  in  if l' >= l then hit else case s of
      [] -> (l', unitise (o + l' *| d - c))
      ss -> foldl (intersect o d) hit ss

light = unitise (V 1 3 (-2)); ss = 4

create 1 c r = S c r []
create level c r =
    let a = 3 * r / sqrt 12
	aux x' z' = create (level - 1) (c + V x' a z') (0.5 * r)
    in  S c (3*r) [S c r [], aux (-a) (-a), aux a (-a), aux (-a) a, aux a a]

ray_trace dir scene =
  let (l, n) = intersect 0 dir (infinity, 0) scene
      g = n .* light
  in  if g <= 0 then 0 else
      let p = l *| dir + sqrt epsilon_float *| n in
      if fst (intersect p light (infinity, 0) scene) < infinity then 0 else g

pixel_val n scene y x = sum
  [ let f a da = a - n / 2 + da / ss; d = unitise (V (f x dx) (f y dy) n)
    in  ray_trace d scene | dx <- [0..ss-1], dy <- [0..ss-1] ]

main = do 
    [level,ni] <- fmap (map read) getArgs
    let n = fromIntegral ni
	scene = create level (V 0 (-1) 4) 1  
	scale x = 0.5 + 255 * x / (ss*ss)
	picture = [ toEnum $ truncate $ scale $ pixel_val n scene y x |
                   y <- [n-1,n-2..0], x <- [0..n-1]]
    putStr $ "P5\n" ++ show ni ++ " " ++ show ni ++ "\n255\n" ++ picture
