#! /usr/bin/ruby

def get_option_strings(args)
  last_option_index = args.rindex { |token| token.start_with?('-') }
  return [] if last_option_index.nil?

  args[0..last_option_index].map { |token| token.start_with?('--') ? token[2..-1] : token[1..-1] }
end

def parse_option_strings(option_strings)
  option_strings.map do |option_string|
    case option_string
    when 'kebab'
      [[:kebab, true]]
    when 'pascal'
      [[:pascal, true]]
    when 'camel'
      [[:camel, true]]
    when 'case-sensitive'
      [[:case_sensitive, true]]
    else
      option_string.split('').map do |single_letter_option|
        case single_letter_option
        when 'k'
          [:kebab, true]
        when 'p'
          [:pascal, true]
        when 'c'
          [:camel, true]
        when 's'
          [:case_sensitive, true]
        else
          $stderr.puts "Unrecognized option: #{single_letter_option}\n\n"
          print_help(is_error: true)
          exit(1)
        end
      end
    end
  end.flatten(1).to_h
end

def print_version
  puts "snake 1.0"
end

def print_help(is_error:)
  help_text = """
    Usage: snake [--kebab/-k | --pascal/-p | --camel/-c] [--case-sensitive/-s] [tokens to transform...]

  Transforms arguments (or stdin) to the specified case.

  TRANSFORMATIONS
    snake (default):  this_string_is_snake_cased
    kebab:            this-string-is-kebab-cased
    pascal:           ThisStringIsKebabCased
    camel:            thisStringIsKebabCased

  OTHER OPTIONS
    case-sensitive (default: false):
        If false, tokens are downcased before being transformed.
        e.g. \"hello There\" becomes \"hello_there\"

        If true, specified casing is preserved.
    """.strip

  if is_error
    $stderr.puts help_text
  else
    puts help_text
  end
end

def main
  if ['-v', '--version'].include?(ARGV.first)
    print_version
    exit(0)
  end
  if ['-h', '--help'].include?(ARGV.first)
    print_help(is_error: false)
    exit(0)
  end

  option_strings = get_option_strings(ARGV)
  options = parse_option_strings(option_strings)
  if [options[:kebab], options[:pascal], options[:camel]].select(&:itself).count > 1
    $stderr.puts "Error: You can only select one of 'kebab', 'pascal', and 'camel' (or none for 'snake')\n\n"
    print_help(is_error: true)
    exit(1)
  end

  tokens = ARGV[option_strings.length..-1]
  tokens = STDIN.read.split(/\s/) if tokens.empty? && !$stdin.tty?
  if tokens.empty?
    $stderr.puts "Error: no tokens specificed\n\n"
    print_help(is_error: true)
    exit(1)
  end

  tokens = tokens.map(&:downcase) unless options[:case_sensitive]

  if options[:kebab]
    puts tokens.join('-')
  elsif options[:pascal]
    puts tokens.map(&:capitalize).join('')
  elsif options[:camel]
    puts ([tokens.first] + tokens[1..-1].map(&:capitalize)).join('')
  else
    puts tokens.join('_')
  end
end

main
