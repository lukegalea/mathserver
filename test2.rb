require 'gsl'
require 'benchmark'
include GSL

@dataset = [
  [1, 1],
  [2, 5],
  [3, 10],
  [4, 6],
  [5, 2],
  [6, 9],
  #[6.5, 6],
  [1, 3],
  [3, 12],
  [5, 3],
  [7, 7]
]

########

@xValues = @dataset.map { |e| e[0] }
@yValues = @dataset.map { |e| e[1] }  
@xMin = @xValues.min
@xMax = @xValues.max
@xVect = Vector.alloc(@xValues)
@yVect =  Vector.alloc(@yValues)

########
points = 100
k = 4
ncoeffs = 4
nbreak = ncoeffs - 2
n = @xValues.length
b = Vector.alloc(ncoeffs)
w = Vector.alloc(n)
fitMatrix = Matrix.alloc(n, ncoeffs)
bspline = BSpline.alloc(k, nbreak)

# Uniform breakpoints
bspline.knots_uniform(@xMin, @xMax)

# Construct the fit matrix    
(@xValues).each do |x|
  w[x] = 0.1
  bspline.eval(x, b)
  (0...ncoeffs).each do |i|
    fitMatrix[x, i] = b[i]
  end
end

# Perform the fit
c, cov, chisq, status = MultiFit.wlinear(fitMatrix, w, @yVect)        


fit = []
x2 = Vector.linspace(@xMin, @xMax, points)
x2.each_index do |i| 
  y2[i] = bspline.eval(i)
end

#x2.each_index { |i| fit << [x2[i], y2[i]] }

GSL::graph([@xVect, @yVect], [x2, y2], "-T X -C -X x -Y y -x 0 15 -y -1 1.3")