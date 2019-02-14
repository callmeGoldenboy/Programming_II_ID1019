#-------------Module for the complex number operations
defmodule Complex do

  def new(r,i)do
    {r,i}

  end
  def add({r,i},{r2,i2})do
    {r+r2,i+i2}
  end
  def sqr({r,0})do
    {r*r,0}
  end
  def sqr({0,i})do
    {0,-1*i*i}
  end

  def sqr({r,i}) do
     {r*r - i*i, 2*r*i}
  end
  def abs({r,i}) do
    :math.sqrt(r*r + i*i)
  end
end

#-------------Depth calculator for any complex number
defmodule Brot do
 ###calculating the depth of any given complex number with a limit m of iterations
  def mandelbrot(c,m) do
    z0 = Complex.new(0,0)
    i = 0
    test(i,z0,c,m)
  end
  ###iteration number has reached the threshold
  def test(max,_,_,max) do
    0
  end
  def test(i,z,c,m) do
    cond do
      Complex.abs(z) <= 2 ->
        z1 = Complex.add(Complex.sqr(z),c)
        test(i+1,z1,c,m)
      true -> i
    end
  end
end

#----------File writer-------------
defmodule PPM do
# write(name, image) The image is a list of rows, each row a list of
# tuples {R,G,B}. The RGB values are 0-255.

def write(name, image) do
  height = length(image)
  width = length(List.first(image))
  {:ok, fd} = File.open(name, [:write])
  IO.puts(fd, "P6")
  IO.puts(fd, "#generated by ppm.ex")
  IO.puts(fd, "#{width} #{height}")
  IO.puts(fd, "255")
  rows(image, fd)
  File.close(fd)
end

defp rows(rows, fd) do
  Enum.each(rows, fn(r) ->
    colors = row(r)
    IO.write(fd, colors)
  end)
end

defp row(row) do
  List.foldr(row, [], fn({:rgb, r, g, b}, a) ->
    [r, g, b | a]
  end)
end

end

#--- color calculator using the depth of a complex number
defmodule Color do

  def convert(depth,max)do
    f = depth / max
    a = 5 * f
    x = trunc(a)
    y = trunc(255 * (a - x))
    case x do
      0 -> {:rgb,y,0,0}
      1 -> {:rgb,255,y, 0}
      2 -> {:rgb,255 - y, 255, 0}
      3 -> {:rgb,0, 255, y}
      4 -> {:rgb,0, 255 - y, 255}
      5 -> {:rgb,0,y,255}
    end
  end
end


defmodule Mandel do
 def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
    Complex.new(x + k * (w - 1), y - k * (h - 1))
    end
   rows(width, height, trans, depth, [])
 end


 def rows(_,0,_,_,acc) do acc end
 def rows(width,height,trans,depth,rowList) do
   rows(width,height-1,trans,depth,[eachRow(width,height,trans,depth,[]) | rowList])
 end
 def eachRow(0,_,_,_,acc) do acc end
 def eachRow(width,height,trans,depth,acc)do
   number = trans.(width,height)
   iteration = Brot.mandelbrot(number,depth)
   color = Color.convert(iteration,depth)
    eachRow(width-1,height,trans,depth,acc++ [color ])

 end
 def demo() do
  small(-2.6, 1.2, 1.2)
 end
def small(x0, y0, xn) do
 width = 960
 height = 540
 depth = 60
 k = (xn - x0) / width
 image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
 PPM.write("small.ppm", image)
end


end
