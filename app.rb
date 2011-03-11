require 'json'
require 'sinatra'
require 'gsl'
include GSL

# Call via: curl http://localhost:8080/interpolate/area_over_time -d "{\"data\":[[1,1],[2,2],[3,3],[4,4]],\"points\":20}"

class App < Sinatra::Application
  before '/interpolate/*' do
    request.body.rewind  # in case someone already read it
    @body = JSON.parse request.body.read
    @dataset = @body['data']
  
    @xValues = @dataset.map { |e| e[0] }
    @yValues = @dataset.map { |e| e[1] }  
    @xMin = @xValues.min
    @xMax = @xValues.max
    @xVect = Vector.alloc(@xValues)
    @yVect =  Vector.alloc(@yValues)
  end

  post '/interpolate/area_over_time' do  
    #Perform interpolation and build a function
    spline = Spline.alloc(@xVect, @yVect)
    function = Function.alloc { |x| spline.eval(x) }
    area = function.qag([@xMin, @xMax])[0]
    areaOverTime = area / (@xMax - @xMin)
  
    res = { areaOverTime: areaOverTime }
  
    if (points = @body['points'])
      res[:fit] = []
      x2 = Vector.linspace(@xMin, @xMax, points)
      y2 = spline.eval(x2)
      x2.each_index { |i| res[:fit] << [x2[i], y2[i]] }    
    end
  
    return [200, res.to_json]
  end
end