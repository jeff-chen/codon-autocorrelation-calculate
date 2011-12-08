require 'gene_scrambler'
require 'rational'


filename = ARGV.first or raise "lol noob u forgot the fasta filename"

lolfile = File.open(filename, "r")
lollines = lolfile.readlines

lines_indexes = []

lollines.each_index do |i|
  lines_indexes << i if lollines[i] =~ /^>/
end

randomized_data = []

lines_indexes.each_with_index do |lolbreak, i|
  #puts lollines[lolbreak]
  asequence = lollines[lolbreak + 1..lines_indexes[i+1] - 1].join().gsub("\n", "") if lines_indexes[i+1]# and i == 1
  blah = Translator.new
  blah.sequence = asequence
  if blah.sequence && blah.sequence != ""
    genename = lollines[lolbreak].split(" ").first.gsub(">", "")
    
    scrambler = GeneScrambler.new
    scrambler.translator = blah
    csv_string = "#{genename},#{blah.total_autocorrelation},"
    puts "Genename #{genename}, DICA: #{blah.total_autocorrelation}"
    50.times{|i| csv_string << "#{scrambler.randomized_dica},"}
    csv_string << "\n"
    randomized_data << csv_string
  end
end

csvfile = File.open("randomdicas.csv", "w+")
csvfile << "Genename,DICA\n"
randomized_data.each do |dataline|
  csvfile << dataline
end
csvfile.close
