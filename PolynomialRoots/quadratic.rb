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

def schoolbook_formula(b, c)
  
  sqrtarg = Complex(b**2 - c, 0)
  sqrt = Math.sqrt(sqrtarg)
  x1 = -b + sqrt
  x2 = -b - sqrt
  
  return [x1, x2]
  
end

def avoid_subtraction(b, c)
  
  sqrtarg = Complex(b**2 - c, 0)
  sqrt = Math.sqrt(sqrtarg)
  if b > 0
    x2 = -b - sqrt
    #~ x1 = c / x2
    x1 = robust_division c, x2
  else
    x1 = -b + sqrt
    #~ x2 = c / x1
    x2 = robust_division c, x1
  end
  
  return [x1, x2]
  
end

def evaluate(b, c, x)
  x**2 + 2*b*x + c
end

def analyze_roots(b, c)
  puts "b=%.1e, c=%.1e" % [b, c]
  
  puts "Schoolbook Formula"
  roots_a = schoolbook_formula b, c
  puts "Roots: %s, %s" % roots_a
  puts "Result: %s, %s" % [evaluate(b, c, roots_a[0]), evaluate(b, c, roots_a[1])]
  
  puts "Avoid Subtraction"
  roots_b = avoid_subtraction b, c
  puts "Roots: %s, %s" % roots_b
  puts "Result: %s, %s" % [evaluate(b, c, roots_b[0]), evaluate(b, c, roots_b[1])]
end

if __FILE__ == $0
  
  puts
  analyze_roots 10.0**4, 4.0
  puts
  analyze_roots -5.0, 1.0
  puts
  analyze_roots 10.0**12, -10.0**14
  
end