#!/usr/bin/env ruby

# equation: x^2 + 2*b*x + c = 0  (note the 2 in the second summand)

require "complex"

def robust_division(a, b)
  # Numerically more robust than the standard ruby complex division implementation
  # Ported back from Math.NET Iridium (MathNet.Numerics.Complex)
  
  return Infinity if b == 0
  return a / b if !b.kind_of?(Complex)
  
  if b.real.abs >= b.image.abs
    r = b.image / b.real
    den = b.real + r * b.image
    if a.kind_of?(Complex)
      return Complex((a.real + a.image * r) / den, (a.image - a.real * r) / den)
    else
      return Complex(a / den, a * r / den)
    end
  else
    r = b.real / b.image
    den = b.image + r * b.real
    if a.kind_of?(Complex)
      return Complex((a.real * r + a.image) / den, (a.image * r - a.real) / den)
    else
      return Complex(a * r / den, -a / den)
    end
  end
end

def refine_root(x)
  xorig = x
  (0..5).each do |i|
    xold = x
    x = yield(x)
    if (x.real-xold.real == 0) && (x.image-xold.image == 0)
      puts "  #{i} iterations"
      return x 
    end
  end
  puts "not converged"
  return xorig
end

@schoolbook_formula = lambda {|b, c|
  sqrtarg = b*b - c
  sqrt = Math.sqrt(sqrtarg)
  x1 = -b + sqrt
  x2 = -b - sqrt
  [x1, x2]
}

@avoid_subtraction_formula = lambda {|b, c|
  sqrtarg = b*b - c
  sqrt = Math.sqrt(sqrtarg)
  if b > 0
    x2 = -b - sqrt
    x1 = c / x2
    #~ x1 = robust_division c, x2
  else
    x1 = -b + sqrt
    x2 = c / x1
    #~ x2 = robust_division c, x1
  end
  [x1, x2]
}

@refined_formula = lambda {|b, c|
  @avoid_subtraction_formula[b, c].collect do |x|
    refine_root(x) { |x| (x*x-c)/(2*(x+b)) }
  end
}

def analyze_formula(b, c)
  #~ x1, x2 = forumla[b, c]
  roots = yield(b, c)
  puts "  Roots: %s, %s" % roots
  puts "  Result: %s, %s" % roots.map {|x| (x + 2 * b) * x + c }
end

def analyze_roots(b, c)
  puts "b=#{b}, c=#{c}"
  
  puts "Schoolbook Formula"
  analyze_formula b, c, &@schoolbook_formula
  
  puts "Avoid Subtraction Formula"
  analyze_formula b, c, &@avoid_subtraction_formula
  
  puts "Refined Formula"
  analyze_formula b, c, &@refined_formula
end


if __FILE__ == $0
  puts
  analyze_roots 10.0**4, 4.0
  puts
  analyze_roots -5.0, 1.0
  puts
  analyze_roots 10.0**12, -10.0**14
end