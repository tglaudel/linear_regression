#! /usr/bin/env ruby -w

require 'json'

class Train

  def initialize(args = [])
    @visualisateur = 0
    @variance = 0
    (0..args.count - 1).each do |n|
      if args[n] == "--visualisateur"
        puts "with visualisateur.txt output."
        @visualisateur = 1
        @file_visu = open("visualisateur.txt", "w+")
      elsif args[n] == "--variance"
        @variance = 1
      else
        return puts "illegal option"
      end
    end
    data, min, max = scale(parse)
    thetas = train(data, min, max)
    file = open("result.txt", "w+")
    file << thetas.join(';')
    file.close
    if @visualisateur == 1
      @file_visu << thetas.join(';')
      @file_visu.close
    end
    puts "Regression works in #{thetas[2]} iterations."
    if @variance == 1
      var = calcul_variance(data, thetas[0], thetas[1])
      puts "La variance est de #{var} pour theta0 = #{thetas[0]} && theta1 = #{thetas[1]}"
      puts "L'ecart type est de #{Math.sqrt(var)}"
    end
  end

  private

  def calcul_variance(data, theta0, theta1)
    ecart = 0
    data.each do |elem|
      ecart += elem[1] - (theta0 + theta1 * elem[0])
    end
    var = theta0 + theta1 * (ecart ** 2)
    return var
  end

  def train(data, min, max)
    learningRate = 0.1
    theta0 = 0.0
    theta1 = 0.0
    cost0 = 0.0
    m = data.count.to_f
    n = 0
    while true
      n = n + 1
      if n % 20 == 0
        cost1 = 0.0
        data.each do |elem|
          cost1 += ((theta0 + (theta1 * elem[0])) - elem[1]) ** 2;
        end
        cost1 *= (1.0 / (2.0 * m))
        cost0 -= cost1
        if (cost0 < (cost1 / 1000000000))
          break
        end
        if @visualisateur == 1
          @file_visu << "#{theta0};#{theta1};#{n};#{min};#{max}\n"
        end
      end
      sum1 = 0.0
      sum2 = 0.0
      cost0 = 0.0
      data.each do |elem|
        cost0 += ((theta0 + (theta1 * elem[0])) - elem[1]) ** 2;
        sum1 += (theta0 + theta1 * elem[0]) - elem[1]
        sum2 += ((theta0 + theta1 * elem[0]) - elem[1]) * elem[0]
      end
      cost0 *= (1.0 / (2.0 * m))
      theta0 -= learningRate / m * sum1
      theta1 -= learningRate / m * sum2
    end
    return theta0, theta1, n, min, max
  end

  def scale(data)
    data = data.sort { |a, b| a[0] <=> b[0] }
    min = data[0][0]
    max = data.last[0]
    new_data = []
    data.each do |elem|
      new_data << [((elem[0] - min) / (max - min)), elem[1]]
    end
    return new_data, min, max
  end

  def parse
    csv = open("data.csv", "r").read
    csv = csv.split("\n")
    list_arg = []
    (1..csv.count - 1).each do |x|
      arg = csv[x].split(',')
      list_arg << [arg[0].to_f, arg[1].to_f]
    end
    return list_arg
  end

end

Train.new(ARGV)
