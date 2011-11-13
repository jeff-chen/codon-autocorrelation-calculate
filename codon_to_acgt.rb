sequence = ARGV.first

blah = ""

sequence.split('').each do |char|
  case char
  when 'X'
    blah << "ATG"
  when 'A'
    blah << "CGC"
  when 'B'
    blah << "CGG"
  end
end

require 'translator' 
require 'rational'
puts blah.inspect

t = Translator.new

t.sequence = blah

puts t.total_autocorrelation