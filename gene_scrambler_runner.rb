require 'gene_scrambler'
require 'rational'


filename = ARGV.first or raise "specify fasta file e.g. ruby gene_scrambler_runner.rb test.fasta"

lolfile = File.open(filename, "r")
lollines = lolfile.readlines

lines_indexes = []

lollines.each_index do |i|
  lines_indexes << i if lollines[i] =~ /^>/
end

csv_string = "GeneName, DICA, Percentile\n"

lines_indexes.each_with_index do |lolbreak, i|
  
  asequence = lollines[lolbreak + 1..lines_indexes[i+1] - 1].join().gsub("\n", "") if lines_indexes[i+1]# and i == 1
  blah = Translator.new
  blah.sequence = asequence
  if blah.sequence && blah.sequence != ""
    genename = lollines[lolbreak].split(" ").first.gsub(">", "")
    
    scrambler = GeneScrambler.new
    scrambler.translator = blah
    
    puts "Genename #{genename}, DICA: #{blah.total_autocorrelation}"
    print "#{genename},#{scrambler.randomized_dica},#{scrambler.random_percentile}\n"
    csv_string << "#{genename},#{scrambler.randomized_dica},#{scrambler.random_percentile}\n"
    csv_string << "\n"
  end

end

csvfile = File.open("scrambled.csv", "w+")

csvfile << csv_string

csvfile.close
