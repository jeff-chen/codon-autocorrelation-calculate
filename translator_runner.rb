require 'translator'
require 'rational'


ARGV.each do |filename|
  blah = Translator.new(filename)
  puts blah.total_autocorrelation.inspect if blah.sequence
end