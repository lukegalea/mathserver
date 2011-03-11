require 'gsl'
require 'benchmark'
dataset = [
  [1, 1],
  [2, 5],
  [3, 10],
  [4, 6],
  [5, 2],
  [6, 9],
  [6.5, 6]
]
xvals = dataset.map { |e| e[0] }
firstx = xvals.first
lastx = xvals.last
yvals = dataset.map { |e| e[1] }
xs = GSL::Vector.alloc(xvals)
ys = GSL::Vector.alloc(yvals)

s = GSL::Spline.alloc(xs, ys)
#x2 = GSL::Vector.alloc([1.5, 2.5, 5.5])
x2 = GSL::Vector.linspace(firstx, lastx, 1000)
y2 = s.eval(x2) 
p y2.inspect
#puts s.eval(2.5)

GSL::graph([xs, ys], [x2, y2], "-C -g 3 -S 2")

#f = GSL::Function.alloc { |x| Math.sin(x) }
f = GSL::Function.alloc { |x| s.eval(x) }
puts f.at(2.5)
ans = 0
Benchmark.bm do |x|
  x.report('integrate') do
    ans = f.qag([firstx, lastx]) #[0, 1.0e-7] 
  end
end

p ans[0]
p ans[0]/(lastx - firstx)