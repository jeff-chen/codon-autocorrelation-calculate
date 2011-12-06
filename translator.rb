require 'gene_data'
require 'calculator'

class Translator
  include GeneData
  include Calculator
  
  attr_accessor :sequence
  attr_accessor :stuff
  
  def initialize(afile = nil)
    if afile
      lines = File.open(afile, "r").readlines
      lines = lines.join.gsub("\n", "")
      @sequence = lines
    end
  end
  
  def to_protein
    protein_sequence = ""
    @sequence.scan(/.{1,3}/).each do |abc|
      protein_sequence << MAP[abc][0]
    end
    protein_sequence.gsub(NULL_CHAR, "")
  end
  
  def trnas
    return @stuff if @stuff
    @stuff = []
    @sequence.scan(/.{1,3}/).each do |abc|
      @stuff << MAP[abc]
    end
    @stuff
  end
  
  def matched_distances
    distances = []
    SYNONYMOUS_AMINO_ACIDS.each do |char|
      things_indices = trna_indices_for(char)
      0.upto(things_indices.size-1) do |i|
        (i+1).upto(things_indices.size-1) do |j|
          if trnas[things_indices[i]] == trnas[things_indices[j]]
            distances << distance(things_indices[i], things_indices[j])
          end
        end
      end
    end
    #raise distances.sort.inspect
    return distances
  end
  
  def mismatched_distances
    distances = []
    SYNONYMOUS_AMINO_ACIDS.each do |char|
      things_indices = trna_indices_for(char)
      0.upto(things_indices.size-1) do |i|
        (i+1).upto(things_indices.size-1) do |j|
          if trnas[things_indices[i]] != trnas[things_indices[j]]
            distances << distance(things_indices[i], things_indices[j])
          end
        end
      end
    end
    return distances
  end
  
  def median_matched_distances
    median_distance(matched_distances)
  end
  
  def median_distance(distances)
    distances.sort[distances.size/2]
  end
  
  def max_distance(distances)
    distances.sort.last
  end
  
  def max_matched_distance
    max_distance(matched_distances)
  end
  
  def ratios
    things = []
    2.upto(50) do |i|
      if frequency_of(matched_distances, i) + frequency_of(mismatched_distances, i) > 0
        things << [i, Rational(frequency_of(matched_distances, i), (frequency_of(matched_distances, i) + frequency_of(mismatched_distances, i))).to_f]
      end
    end
    things
  end
  
  def normalized_ratios
    things = ratios
    baseline = ratios.first[1]
    things.map{|i| [i[0], (i[1].to_f / baseline).to_f]}
  end
  
  def normalized_ratios_csv
    line = ""
    things = normalized_ratios
    2.upto(50) do |i|
      ratio = things.select{|x| x[0] == i}.first
      if ratio     
        line << "#{ratio[1]}"
      end
      line << ","
    end
    line
  end
  
  def mode_distance(distances)
    freq = distances.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    distances.sort_by { |v| freq[v] }.last
  end
  
  def frequency_of(distances, distance)
    distances.select{|i| i == distance}.size
  end
  
  def mode_matched_distances
    mode_distance(matched_distances)
  end
  
  def output_matched_distances
    "#{median_matched_distances},#{mode_matched_distances},#{matched_distance_average},#{max_matched_distance}"
  end
  
  def matched_distance_distribution
    distribution_to_hash(matched_distances).to_a.sort{|a,b| a[0].to_i <=> b[0].to_i}.map{|a| [a[0].to_i, a[1]]}
  end
  
  def mismatched_distance_distribution
    distribution_to_hash(mismatched_distances).to_a.sort{|a,b| a[0].to_i <=> b[0].to_i}.map{|a| [a[0].to_i, a[1]]}
  end
  
  def distribution_to_hash(elements)
    distribution = {}
    elements.each do |element|
      if distribution[element.to_s]
        distribution[element.to_s] += 1
      else
        distribution[element.to_s] = 1
      end
    end
    distribution
  end
  
  def averages_of(elements)
    (elements.inject{|sum, element| sum+element}.to_f / elements.size).to_f
  end
  
  def matched_distance_average
    averages_of(matched_distances)
  end
  
  def mismatched_distance_average
    averages_of(mismatched_distances)
  end
  
  def trna_indices_for(char)
    indices_from_trna_of(char, trnas)
  end
  
  def max_autocorrelation_score_for(char)
    max_autocorrelation_score(char, trnas)
  end
  
  def total_autocorrelation
    dica_for(trnas)
  end
  

  def autocorrelation_score_for(char)
    autocorrelation_score(char, trnas)
  end
  
  def codons_for(codon)
    codons_for_codon_and_trnas(codon, trnas)
  end
  


end