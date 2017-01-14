class String
  def match_first_part(with)  
    with.size.times do |i|
      return false if with[i] != self[i]
    end
    true
  end

  def option_arg(with)
    additional_part = self[with.size..-1] if with.size == 2
    additional_part = self[(with.size + 1)..-1] if with.size > 2
    additional_part
  end
end

module BonusFunction
  def add_options_with_parameters(command_runner, argv)
    res = ''
    @hash_option_plus_args.each do |k, v|
      argv.each do |e|
        res = e.option_arg('--' + k[1]) if e.match_first_part('--' + k[1])
        res = e.option_arg('-' + k[0]) if e.match_first_part('-' + k[0])
      end
      v.call command_runner, res if res != ''
      res = ''
    end  
  end
end

class CommandParser
  include BonusFunction
  def initialize(command_name)
    @command_name = command_name
    @hash_args = {}
    @hash_option = {}
    @hash_option_plus_args = {}
  end

  def argument(name, &block)
    @hash_args.merge!({name => block})
  end

  def option(short_name, full_name, discription, &block)
    arr_option_names = [short_name, full_name, discription]
    @hash_option.merge!({arr_option_names => block})
  end

  def option_with_parameter(s_name, f_name, discription, placeholder, &block)
    arr_option_names = [s_name, f_name, discription, placeholder]
    @hash_option_plus_args.merge!({arr_option_names => block})
  end

  def parse(command_runner, argv)
    work = argv.select { |e| e[0] != '-' }
    @hash_args.each_with_index { |e, i| e[1].call command_runner, work[i] }
    
    @hash_option.each do |k, v|
      if argv.include?('-' + k[0]) || argv.include?('--' + k[1]) 
        v.call command_runner, true 
      end
    end

    add_options_with_parameters(command_runner, argv)
  end
  
  def help
    arg_row = "Usage: #{@command_name}"
    @hash_args.each { |k, _| arg_row += " [#{k}]" }
    @hash_option.each { |k, _| arg_row += "\n    -#{k[0]}, --#{k[1]} #{k[2]}" }
    @hash_option_plus_args.each do |k, _| 
      arg_row += "\n    -#{k[0]}, --#{k[1]}=#{k[3]} #{k[2]}"
    end
    arg_row
  end
end