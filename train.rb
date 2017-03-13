#! /usr/bin/env ruby -w

require 'json'

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
      if (cost0 < (cost1 / (10000000 / learningRate)))
        break
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

def main(args = [])
  (0..args.count - 1).each do |n|
     puts args[n]
  end
  data, min, max = scale(parse)
  thetas = train(data, min, max)
  puts thetas
  file = open("result.txt", "w+")
  file << thetas.join(';')
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

main(ARGV)
