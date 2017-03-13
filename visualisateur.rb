require 'gosu'

class Tutorial < Gosu::Window

  ORIGINE_X = 50
  ORIGINE_Y = 670
  SIZE_X = 900
  SIZE_Y = 650
  YELLOW = 0xfff1c40f
  PREC_Y = 10.0
  PREC_X = 10.0
  BLUE = 0xff3498db
  MIDNIGHT = 0xA02c3e50
  PUMPKIN = 0xffd35400
  BLANC = 0xffffffff

  def initialize
    super 1080, 720
    self.caption = "Linear Regression - visualisateur"
    @font = Gosu::Font.new(self, "Arial", 18)
    @args = take_data
    @affines = 
  end

  def update
    # ...
  end

  def draw
    draw_quad(ORIGINE_X - 5, ORIGINE_Y - 5, BLANC,
              ORIGINE_X - 5, ORIGINE_Y + 5, BLANC,
              ORIGINE_X + 5, ORIGINE_Y + 5, BLANC,
              ORIGINE_X + 5, ORIGINE_Y - 5, BLANC, 1)
    draw_line(ORIGINE_X, ORIGINE_Y + 20, YELLOW, ORIGINE_X, ORIGINE_Y - SIZE_Y, YELLOW, 1)
    draw_line(20, ORIGINE_Y, YELLOW, SIZE_X + 100, ORIGINE_Y, YELLOW, 1)
    @font.draw("Price (euro)", ORIGINE_X + 10, 10, 1, 1, 1, YELLOW)
    @font.draw("Mileage (km)", ORIGINE_X + SIZE_X + 30, ORIGINE_Y - 20, 1, 1, 1, YELLOW)
    draw_y
    draw_x
    draw_point
    draw_affine
  end

  def draw_y
    value_in_space = @args[:max_y].to_f / (PREC_Y - 1)
    space = SIZE_Y / (PREC_Y - 1)
    for i in 1..PREC_Y + 1
      draw_line(ORIGINE_X - 5, ORIGINE_Y - i * space , YELLOW, ORIGINE_X + 5, ORIGINE_Y - i * space, YELLOW, 1)
      @font.draw("#{(i * value_in_space).to_i}", ORIGINE_X - 45, ORIGINE_Y - i * space - 10, 1, 1, 1, YELLOW)
    end
  end

  def draw_x
    value_in_space = @args[:max_x].to_f / (PREC_X - 1)
    space = SIZE_X / (PREC_X - 1)
    for i in 0..PREC_X - 1
      draw_line(ORIGINE_X + i * space, ORIGINE_Y + 5 , YELLOW, ORIGINE_X + i * space, ORIGINE_Y - 5, YELLOW, 1)
      @font.draw("#{(i * value_in_space).to_i}",ORIGINE_X + i * space - 25, ORIGINE_Y + 10, 1, 1, 1, YELLOW)
    end
  end

  def draw_point
    @args[:data].each do |point|
      x = point[0] / @args[:max_x].to_f * SIZE_X
      y = point[1] / @args[:max_y].to_f * SIZE_Y
      draw_quad(ORIGINE_X + x - 2, ORIGINE_Y - y - 2, BLUE,
                ORIGINE_X + x - 2, ORIGINE_Y - y + 2, BLUE,
                ORIGINE_X + x + 2, ORIGINE_Y - y + 2, BLUE,
                ORIGINE_X + x + 2, ORIGINE_Y - y - 2, BLUE,
                1)
      draw_line(ORIGINE_X + x, ORIGINE_Y - y, MIDNIGHT, ORIGINE_X, ORIGINE_Y - y, MIDNIGHT, 0)
      draw_line(ORIGINE_X + x, ORIGINE_Y - y, MIDNIGHT, ORIGINE_X + x, ORIGINE_Y, MIDNIGHT, 0)
    end
  end

  def draw_affine
    if File.exist?('result.txt')
      args = open('result.txt').read.split(';')
    else
      return
    end
    theta0 = args[0].to_f
    theta1 = args[1].to_f
    scale_max = (250000 - args[3].to_f) / (args[4].to_f - args[3].to_f)
    scale_min = (2000 - args[3].to_f) / (args[4].to_f - args[3].to_f)
    x_min = 2000 / @args[:max_x].to_f * SIZE_X
    y_min = (theta0 + theta1 * scale_min)/ @args[:max_y].to_f * SIZE_Y
    x_max = 250000 / @args[:max_x].to_f * SIZE_X
    y_max = (theta0 + theta1 * scale_max) /@args[:max_y].to_f * SIZE_Y
    # puts ORIGINE_X + x_min, ORIGINE_Y - y_min,ORIGINE_X + x_max,ORIGINE_Y - y_max
    draw_line(ORIGINE_X + x_min, ORIGINE_Y - y_min, PUMPKIN, ORIGINE_X + x_max, ORIGINE_Y - y_max, PUMPKIN, 2)
  end

  def take_data
    data = open('data.csv', 'r').read.split("\n")
    list_data = []
    (1..data.count-1).each do |x|
      arg = data[x].split(',')
      list_data << [arg[0].to_f, arg[1].to_f]
    end
    list_data = list_data.sort { |a, b| a[0] <=> b[0] }
    args = {}

    args[:data] = list_data
    args[:min_x] = list_data[0][0]
    args[:max_x] = list_data.last[0]
    list_data = list_data.sort { |a, b| a[1] <=> b[1] }
    args[:min_y] = list_data[0][1]
    args[:max_y] = (list_data.last[1].to_i / 1000 + 1) * 1000
    return args
  end
end

Tutorial.new.show
