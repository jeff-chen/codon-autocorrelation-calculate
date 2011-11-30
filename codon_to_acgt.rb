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
require 'root_distance_translator'
require 'log_distance_translator'
require 'rational'

puts blah.inspect

t = RootDistanceTranslator.new

t.sequence = blah

puts t.total_autocorrelation