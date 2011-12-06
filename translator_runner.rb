require 'translator'
require 'log_distance_translator'
require 'root_distance_translator'
require 'rational'

require 'rubygems'
require 'ruby-debug'

SLOWGENES = ["YEL020C", "YPR090W", "YLR398C", "YHR112C", "YNL256W", "YCR097WA", "YDR159W", "YER007W", "YGR051C", "YLR237W",
  "YCR077C", "YER125W", "YGL164C", "YIR001C", "YLR251W", "YDR229W", "YLR415C", "YNL040W", "YMR226C", "YOL032W"]
  
FASTGENES = ["YPL163C", "YOR383C", "YNR067C", "YFL033C", "YKL164C", "YBR038W", "YPL256C", "YKL185W", "YLR454W", "YML027W",
  "YNL102W", "YDR055W", "YOR025W", "YKL096W", "YDR225W", "YNL030W", "YBR009C", "YDL003W", "YLR183C", "YPR149W"]

raise "no files given" if ARGV.empty?
speeds = {}
ARGV.each do |filename|
  begin
    speedfile = File.open("speeds.txt", "r")
    speedfile.readlines.each do |line|
      splitthings = line.split("\t")
      name, speed = splitthings.first, splitthings.last.strip.to_f
      speeds[name] = speed
    end
  rescue Errno::ENOENT
    puts "No speed file found, continuing..."
  end
  lolfile = File.open(filename, "r")
  lollines = lolfile.readlines
  
  lines_indexes = []
  
  lollines.each_index do |i|
    lines_indexes << i if lollines[i] =~ /^>/
  end
  
  #blah_csv = File.open("distanceinfo.csv", "w+")
  #blah_csv << "gene,median,mode,mean,max\n"
  output_csv = File.open("outputinfo.csv", "w+")
  output_csv << "gene,dica,speed\n"
  autocorrelations = []
  sum = 0.to_f
  genes = 0
  #ratiocsv = File.open("ratios.csv", "w+")
  #ratiocsv << "genename"
  #2.upto(50){|i| ratiocsv << ",#{i}"}
  #ratiocsv << "\n"
  #raise lines_indexes.size.inspect
  lines_indexes.each_with_index do |lolbreak, i|
    puts lollines[lolbreak]
    asequence = lollines[lolbreak + 1..lines_indexes[i+1] - 1].join().gsub("\n", "") if lines_indexes[i+1]# and i == 1
    blah = Translator.new
    blah.sequence = asequence
    if blah.sequence && blah.sequence != ""
      genes += 1
      sum += blah.total_autocorrelation
      autocorrelations << blah.total_autocorrelation
      #puts blah.total_autocorrelation.inspect if blah.sequence
      puts "dica: #{blah.total_autocorrelation.inspect}"
      genename = lollines[lolbreak].split(" ").first.gsub(">", "")
      if speeds[genename]
        puts "speed: #{speeds[genename]}" if speeds[genename]
        output_csv << "#{genename},#{blah.total_autocorrelation},#{speeds[genename]}\n"
      end
      #if ["YPL163C", "YOR383C", "YNR067C", "YFL033C", "YKL164C", "YBR038W", "YPL256C", "YKL185W", "YLR454W", "YML027W"].any?{|i| genename == i}
      if [FASTGENES + SLOWGENES].flatten.any?{|i| genename == i}
        #ratiocsv << genename + "," + blah.normalized_ratios_csv + "\n"
        #blah_csv << genename + "," + blah.output_matched_distances + "\n"
        #f = File.open(genename + "_mismatched.csv", "w+")
        #f << "distance,count\n"
        #blah.mismatched_distance_distribution.each do |a, b|
        #  f << "#{a.to_s},#{b.to_s}\n"
        #end
        #f.close
      end
    end
  end
  #blah_csv.close
  #ratiocsv.close
  output_csv.close
  puts "THe average is::::"
  puts (sum/genes.to_f).inspect
  puts "The median is:::: #{autocorrelations.sort[autocorrelations.size / 2]}"
end
#ARGV.each do |filename|
#  blah = Translator.new(filename)
#  puts blah.total_autocorrelation.inspect if blah.sequence
#end