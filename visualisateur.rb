require 'gosu'

class Tutorial < Gosu::Window

  ORIGINE_X = 50
  ORIGINE_Y = 670
  SIZE_X = 900
  SIZE_Y = 650
  PREC_Y = 10.0
  PREC_X = 10.0

  BLUE = 0xff3498db
  MIDNIGHT = 0xA02c3e50
  PUMPKIN = 0xffd35400
  YELLOW = 0xfff1c40f
  BLANC = 0xffffffff
  CURSOR = 'wwatkins.png'

  def initialize(args = [])
    super 1080, 720
    @speed = 20
    if args.count > 0
      if args[0] == "-v"
        @speed = args[1].to_i if args[1] && args[1].to_i != nil && args[1].to_i > 0
      else
        return puts "illegal option"
      end
    end
    self.caption = "Linear Regression - visualisateur"
    @font = Gosu::Font.new(self, "Arial", 18)
    @cursor = Gosu::Image.new(self, CURSOR)
    @args = take_data
    @visualisateur = 0
    @file_visu = []
    @count = 0
    @theta0, @theta1, @min, @max, @n = determine_args
    @n = 0 if !@n
    @count = 0
    @index = 0
  end

  def update
    # ...
  end

  def draw
    @count += 1
    determine_thetas if @count % @speed == 0 && @visualisateur == 1
    draw_line(ORIGINE_X, ORIGINE_Y + 20, YELLOW,
              ORIGINE_X, ORIGINE_Y - SIZE_Y, YELLOW, 1)
    draw_line(20, ORIGINE_Y, YELLOW, SIZE_X + 100, ORIGINE_Y, YELLOW, 1)
    @font.draw("Price (euro)", ORIGINE_X + 10, 10, 1, 1, 1, YELLOW)
    @font.draw("Mileage (km)", ORIGINE_X + SIZE_X + 30,
                ORIGINE_Y - 20, 1, 1, 1, YELLOW)
    @font.draw("Iteration = #{@n}", ORIGINE_X + SIZE_X - 30,
                ORIGINE_Y - SIZE_Y, 1, 1, 1, YELLOW)
    draw_y
    draw_x
    draw_point
    draw_affine if @theta0 && @theta1 && @min && @max
    @cursor.draw self.mouse_x, self.mouse_y, 3, 1, 1
  end

  def draw_y
    value_in_space = @args[:max_y].to_f / (PREC_Y - 1)
    space = SIZE_Y / (PREC_Y - 1)
    for i in 1..PREC_Y + 1
      draw_line(ORIGINE_X - 5, ORIGINE_Y - i * space , YELLOW,
                ORIGINE_X + 5, ORIGINE_Y - i * space, YELLOW, 1)
      @font.draw("#{(i * value_in_space).to_i}", ORIGINE_X - 45,
                  ORIGINE_Y - i * space - 10, 1, 1, 1, YELLOW)
    end
  end

  def draw_x
    value_in_space = @args[:max_x].to_f / (PREC_X - 1)
    space = SIZE_X / (PREC_X - 1)
    for i in 0..PREC_X - 1
      draw_line(ORIGINE_X + i * space, ORIGINE_Y + 5 , YELLOW,
                ORIGINE_X + i * space, ORIGINE_Y - 5, YELLOW, 1)
      @font.draw("#{(i * value_in_space).to_i}",ORIGINE_X + i * space - 25,
                  ORIGINE_Y + 10, 1, 1, 1, YELLOW)
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
      draw_line(ORIGINE_X + x, ORIGINE_Y - y, MIDNIGHT,
                ORIGINE_X, ORIGINE_Y - y, MIDNIGHT, 0)
      draw_line(ORIGINE_X + x, ORIGINE_Y - y, MIDNIGHT,
                ORIGINE_X + x, ORIGINE_Y, MIDNIGHT, 0)
    end
  end

  def draw_affine
    scale_max = (250000 - @min) / (@max - @min)
    scale_min = (2000 - @min) / (@max - @min)
    x_min = 2000 / @args[:max_x].to_f * SIZE_X
    y_min = (@theta0 + @theta1 * scale_min)/ @args[:max_y].to_f * SIZE_Y
    x_max = 250000 / @args[:max_x].to_f * SIZE_X
    y_max = (@theta0 + @theta1 * scale_max) /@args[:max_y].to_f * SIZE_Y
    draw_line(ORIGINE_X + x_min, ORIGINE_Y - y_min, PUMPKIN,
              ORIGINE_X + x_max, ORIGINE_Y - y_max, PUMPKIN, 2)
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

  def determine_thetas
    @index += 1
    @index = @file_visu.count - 1 if @index > @file_visu.count - 1
    tmp = @file_visu[@index].split(';')
    @theta0 = tmp[0].to_f
    @theta1 = tmp[1].to_f
    @n = tmp[2].to_i
  end

  def determine_args
    if File.exist?('visualisateur.txt')
      @visualisateur = 1
      @file_visu = open('visualisateur.txt').read.split("\n")
      tmp = @file_visu[0].split(';')
      theta0 = 0
      theta1 = 0
      min = tmp[3].to_f
      max = tmp[4].to_f
      n = 0
    elsif File.exist?('result.txt')
      @visualisateur = 0
      args = open('result.txt').read.split(';')
      theta0 = args[0].to_f
      theta1 = args[1].to_f
      n = args[2].to_f
      min = args[3].to_f
      max = args[4].to_f
    else
      return
    end

    return theta0, theta1, min, max, n
  end
end

Tutorial.new(ARGV).show
