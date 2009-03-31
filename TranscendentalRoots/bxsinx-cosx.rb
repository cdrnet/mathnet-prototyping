#!/usr/bin/env ruby

# equation: b*x*cos(x) - sin(x) = 0
# rewritten as: y = b*x = tan(x)

def iterate_root(refine, x)
  (1..50).each do |i|
    xold = x
    x = refine.call(x)
    xm = [x.abs,xold.abs].max
    if xm == 0 || (x-xold).abs/xm < 1e-14
      break
    end
  end
  return x
end

if __FILE__ == $0
  
  (-10..10).each do |b|
    b = b/10.0
    puts
    puts "=== (#{b})*x*cos(x)=sin(x) ==="
    
    (-2..2).each do |n|
      
      refine = lambda { |x| Math::PI*n + Math.atan(b*x) }
      x = iterate_root(refine, n*Math::PI)
      puts " %2d: %s" % [n,x]
      
    end
    
  end
  
end
