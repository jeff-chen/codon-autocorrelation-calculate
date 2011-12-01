class Translator
  START_CODON = "ATG"
  STOP_CODONS = ["TAA", "TGA", "TAG"]
  NULL_CHAR = "#"
  MAP = {"AAA" => "K1", "AAG" => "K1", "AAT" => "N1", "AAC" => "N1", "ACA" => "T2", "ACC" => "T1", "ACG" => "T3", "ACT" => "T1",
         "AGA" => "R3", "AGC" => "S4", "AGG" => "R4", "AGT" => "S4", "ATA" => "I2", "ATC" => "I1", "ATG" => "M", "ATT" => "I1", 
         "CAA" => "Q1", "CAC" => "H1", "CAG" => "Q1", "CAT" => "H1", "CCA" => "P2", "CCC" => "P1", "CCG" => "P2", "CCT" => "P1",
         "CGA" => "R1", "CGC" => "R1", "CGG" => "R2", "CGT" => "R1", "CTA" => "L4", "CTC" => "L3", "CTG" => "L4", "CTT" => "L3",
         "GAA" => "E1", "GAC" => "D1", "GAG" => "E1", "GAT" => "D1", "GCA" => "A2", "GCC" => "A1", "GCG" => "A2", "GCT" => "A1",
         "GGA" => "G2", "GGC" => "G1", "GGG" => "G3", "GGT" => "G1", "GTA" => "V2", "GTC" => "V1", "GTG" => "V3", "GTT" => "V1",
         "TAA" => NULL_CHAR, "TAC" => "Y1", "TAG" => NULL_CHAR, "TAT" => "Y1", "TCA" => "S2", "TCC" => "S1", "TCG" => "S3", "TCT" => "S1",
         "TGA" => NULL_CHAR, "TGC" => "C1", "TGG" => "W", "TGT" => "C1", "TTA" => "L1", "TTC" => "F1", "TTG" => "L2", "TTT" => "F1"}
  
  SYNONYMOUS_AMINO_ACIDS = ["A", "R", "G", "I", "L", "P", "S", "T", "V"]
  
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
  
  def matched_distance_average
    (matched_distances.inject{|sum, element| sum+element}.to_f / matched_distances.size).to_f
  end
  
  def mismatched_distance_average
    (mismatched_distances.inject{|sum, element| sum+element}.to_f / mismatched_distances.size).to_f
  end
  
  def trna_indices_for(char)
    things_to_check = []
    trnas.each_index do |i|
      things_to_check << i if trnas[i] =~ Regexp.new("^" + char, true)
    end
    things_to_check
  end
  
  def max_autocorrelation_score_for(char)
    things_indices = trna_indices_for(char)
    sum = 0
    return 1 if things_indices.size < 2 
    0.upto(things_indices.size-1) do |i|
      (i+1).upto(things_indices.size-1) do |j|
        sum = sum + distance_score(things_indices[i], things_indices[j])
      end
    end
    sum
  end
  
  def min_autocorrelation_score_for(char)
    things_indices = trna_indices_for(char)
    sum = 0
    return 1 if things_indices.size < 2 
    0.upto(things_indices.size-1) do |i|
      (i+1).upto(things_indices.size-1) do |j|
        sum = sum - distance_score(things_indices[i], things_indices[j])
      end
    end
    sum
  end
  
  def autocorrelation_score_for(char)
    things_indices = trna_indices_for(char)
    sum = 0
    return 1 if things_indices.size < 2 #it won't matter if there are no amino acids
    0.upto(things_indices.size-1) do |i|
      (i+1).upto(things_indices.size-1) do |j|
       # puts distance_score(things_indices[i], things_indices[j]).inspect
        if trnas[things_indices[i]] == trnas[things_indices[j]]
          sum = sum + distance_score(things_indices[i], things_indices[j])
        else
          sum = sum - distance_score(things_indices[i], things_indices[j])
        end
      end
    end
    sum / max_autocorrelation_score_for(char)
  end
  
  def total_autocorrelation
    total_codons = 0
    total_score = 0.to_f
    SYNONYMOUS_AMINO_ACIDS.each do |amino_acid|
      total_codons += codons_for(amino_acid)
      total_score += codons_for(amino_acid).to_f * autocorrelation_score_for(amino_acid)
    end
    return ((total_score.to_f)/(total_codons.to_f)).to_f
  end
  
  def codons_for(codon)
    sequence = to_protein
    my_regex = Regexp.new("[^#{codon}]")
    to_protein.gsub(my_regex, "").size
  end
  
  def distance(pos1, pos2)
    ((pos2 - pos1).abs)+1
  end
  
  def distance_score(pos1, pos2)
    Rational(1, distance(pos1, pos2)).to_f
  end
end