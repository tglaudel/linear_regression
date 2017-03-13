#! /usr/bin/env ruby -w

def estimate(arg = [])
  if arg.count < 1
    return puts "No argument"
  else
    arg = Float(arg[0]) rescue nil
    if arg.nil?
      return puts "Invalid argument"
    end
  end
  begin
    str = open('result.txt').read
    str = str.split(';')
  rescue
    puts "Pliz train before execute estimate.rb"
    return
  end
  theta0 = str[0].to_f
  theta1 = str[1].to_f
  min = str[3].to_f
  max = str[4].to_f

  scale = (arg - min) / (max - min)
  result = theta0 + (theta1 * scale)
  if result < 0
    puts "#{result} -> yes, your car suck"
  else
    puts result
  end
end

estimate(ARGV)
