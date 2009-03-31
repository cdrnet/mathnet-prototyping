#!/usr/bin/env ruby

# equation: x*sin(x) - b*cos(x) = 0
# rewritten as: y = x = b*cot(x)

def refine_root(x)
  (1..50).each do |i|
    xold = x
    x = yield(x)
    xm = [x.abs,xold.abs].max
    if xm == 0 || (x-xold).abs/xm < 1e-14
      return {:result=>x, :converged=>i}
    end
  end
  return {:result=>x, :converged=>-1}
end


if __FILE__ == $0
  
  (1..10).each do |b|
    b = b/10.0
    puts
    puts "*** Equation x*sin(x) = #{b}*cos(x) ***"
    
    (1..5).each do |n|
      
      printf "Period %d: ", n
      
      result = refine_root(n*Math::PI) do |x|
        y = x
        Math::PI*(n+0.5) - Math.atan(y/b)
      end
      
      if result[:converged] >= 0
        puts "x=%s (%d iterations)" % [result[:result], result[:converged]]
      else
        puts "did not converge"
      end
      
    end
    
  end
  
end
