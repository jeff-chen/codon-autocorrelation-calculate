require 'translator'
require 'rational'

raise "no files given" if ARGV.empty?

lolfile = File.open(ARGV.first, "r")
lollines = lolfile.readlines

lines_indexes = []

lollines.each_index do |i|
  lines_indexes << i if lollines[i] =~ /^>/
end

sum = 0.to_f
genes = 0
lines_indexes.each_with_index do |lolbreak, i|
  puts lolbreak+1
  asequence = lollines[lolbreak + 1..lines_indexes[i+1] - 1].join().gsub("\n", "") if lines_indexes[i+1]# and i == 1
  blah = Translator.new
  blah.sequence = asequence
  if blah.sequence
    genes += 1
    sum += blah.total_autocorrelation
    puts blah.total_autocorrelation.inspect if blah.sequence
  end
end
puts "THe average is::::"
puts (sum/genes.to_f).inspect

#ARGV.each do |filename|
#  blah = Translator.new(filename)
#  puts blah.total_autocorrelation.inspect if blah.sequence
#end