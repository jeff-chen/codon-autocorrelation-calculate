#a little script to extract percentile data

file = File.open("slowrandomdicas.csv")

lines = file.readlines[1..-1] #no header

lines.each do |line|
  things = line.strip.split(",")
  genename = things[0]
  basevalue = things[1].to_f
  random = things[2,50].map(&:to_f)
  percentile = random.select{|i| basevalue > i}.size
  percentile *= 100
  percentile /= random.size
  puts "#{percentile}"
end
