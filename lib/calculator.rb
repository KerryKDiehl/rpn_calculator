require 'byebug'
class RPNCalculator
  attr_accessor :input


  def initialize
    @input = []
    @operators = [:+,:-,:*,:/]
  end

  def push(num)
    @input.push(num.to_f)
  end

  def calculate(operator)
    if @input.length > 1
      @input.push(operator)
    else
      raise 'calculator is empty'
    end
  end

  def plus
    calculate(:+)
  end

  def minus
    calculate(:-)
  end

  def times
    calculate(:*)
  end

  def divide
    calculate(:/)
  end

  def tokens(string)
    string.split(' ').map do |n|
      if @operators.include?(n.to_sym)
        n.to_sym
      else
        n.to_f
      end
    end
  end

  def evaluate(string)
    @input = tokens(string)
    puts "The result of your equation is: #{value}!"
    value
  end

  def value
    location = 0
    func_operators = @input & @operators
    while func_operators.length > 0
      if @input.include?(func_operators[0])
        op = func_operators[0]
        location = @input.index(op) - 2
        nums = @input.slice!(location,2)
        @input[location] = eval(nums[0].to_s + op.to_s + nums[1].to_s)
      else
        func_operators.shift
      end
    end
    @input[location]
  end
end

def get_user_input
  input_string = ""
  puts "Please enter your function one character at a time"
  next_char = gets.chomp
  until next_char.empty?
    input_string << "#{next_char} "
    next_char = gets.chomp
  end
  input_string
end

def evaluate_file_equations(calculator)
  File.open(ARGV[0]) do |f|
    string = f.gets
    until string.nil?
      calculator.evaluate(string.chomp)
      string = f.gets
    end
  end
end

if __FILE__ == "calculator.rb"
  calculator = RPNCalculator.new
  # debugger
  if (ARGV.length > 0) && (!ARGV[0].include? "spec")
    evaluate_file_equations(calculator)
  else
    calculator.evaluate(get_user_input)
  end
end


