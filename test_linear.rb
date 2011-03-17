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

s = GSL::Interp.alloc('linear', xs, ys)
#x2 = GSL::Vector.alloc([1.5, 2.5, 5.5])
x2 = GSL::Vector.linspace(firstx, lastx, 100)
y2 = s.eval(xs, ys, x2) 
p y2.inspect
#puts s.eval(2.5)

GSL::graph([xs, ys], [x2, y2], "-C -g 3 -S 2")

#f = GSL::Function.alloc { |x| Math.sin(x) }
f = GSL::Function.alloc { |x| s.eval(xs, ys, x) }
ans = 0
Benchmark.bm do |x|
  x.report('integrate') do
    ans = f.qng([firstx, lastx], [0.25, 0.1]) 
  end
end

p ans[0]
p ans[0]/(lastx - firstx)