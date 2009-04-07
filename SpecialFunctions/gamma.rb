#!/usr/bin/env ruby

def gamma_ln_approx(a)
  # approximation for a > 6
  t = a + 5.5
  (a + 0.5) * Math.log(t) - t
end

def gamma_ln_series(a)
  
  coefficients = [
    76.18009172947146,
    -86.50532032941677,
    24.01409824083091,
    -1.231739572450155,
    0.1208650973866179e-2,
    -0.5395239384953e-5
  ]
  
  approx = gamma_ln_approx(a);

  y = a
  x = a
  ser = 1.000000000190015
  
  coefficients.each do |c|
    y = y+1
    ser = ser + c / y
    #puts "  SER: #{ser}"
  end

  approx + Math.log(2.5066282746310005 * ser / x)
end

def relative_error(expected, actual)
  if expected.zero?
    actual.abs
  elsif actual.zero?
    expedted.abs
  else
    max_abs = [expected.abs,actual.abs].max
    (actual-expected).abs / max_abs
  end
end

def verify(expected, actual)
  error_rel = relative_error expected, actual
  if error_rel > 1.0e-12
    puts "  expected %e, got %e -- rel %e." % [expected, actual, error_rel]
  else
    puts "  ok -- rel %e" % error_rel
  end
end

def test_known_numbers_around_1
  sqrtpi = Math.sqrt(Math::PI)
  verify Math.log(4.0/3.0*sqrtpi), yield(-3.0/2.0)
  verify Math.log(sqrtpi), yield(1.0/2.0)
  verify Math.log(1.0), yield(1.0)
  verify Math.log(sqrtpi/2.0), yield(3.0/2.0)
  verify Math.log(1.0), yield(2.0)
  verify Math.log(3.0/4.0*sqrtpi), yield(5.0/2.0)
  verify Math.log(2.0), yield(3.0)
  verify Math.log(15.0/8.0*sqrtpi), yield(7.0/2.0)
  verify Math.log(6.0), yield(4.0)
end


if __FILE__ == $0
  
  #~ puts "Konwn Numbers Around 1 - GammaLn Approx:"
  #~ test_known_numbers_around_1 {|a| gamma_ln_approx(a)}
  puts "Known Numbers Around 1 - GammaLn Series:"
  test_known_numbers_around_1 {|a| gamma_ln_series(a)}
  
end