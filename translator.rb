class Translator
  START_CODON = "ATG"
  STOP_CODONS = ["TAA", "TGA", "TAG"]
  NULL_CHAR = "#"
  MAP = {"AAA" => "K1", "AAG" => "K2", "AAT" => "N1", "AAC" => "N2", "ACA" => "T1", "ACC" => "T2", "ACG" => "T3", "ACT" => "T4",
         "AGA" => "R1", "AGC" => "R2", "AGG" => "R3", "AGT" => "R4", "ATA" => "I1", "ATC" => "I2", "ATG" => "M", "ATT" => "I3", 
         "CAA" => "Q1", "CAC" => "H1", "CAG" => "Q2", "CAT" => "H2", "CCA" => "P1", "CCC" => "P2", "CCG" => "P3", "CCT" => "P4",
         "CGA" => "R3", "CGC" => "R4", "CGG" => "R5", "CGT" => "R6", "CTA" => "L1", "CTC" => "L2", "CTG" => "L3", "CTT" => "L4",
         "GAA" => "E1", "GAC" => "D1", "GAG" => "E2", "GAT" => "D2", "GCA" => "A1", "GCC" => "A2", "GCG" => "A3", "GCT" => "A4",
         "GGA" => "G1", "GGC" => "G2", "GGG" => "G3", "GGT" => "G4", "GTA" => "V1", "GTC" => "V2", "GTG" => "V3", "GTT" => "V4",
         "TAA" => NULL_CHAR, "TAC" => "Y1", "TAG" => NULL_CHAR, "TAT" => "Y2", "TCA" => "S1", "TCC" => "S2", "TCG" => "S3", "TCT" => "S4",
         "TGA" => NULL_CHAR, "TGC" => "C1", "TGG" => "W", "TGT" => "C2", "TTA" => "L5", "TTC" => "F1", "TTG" => "L6", "TTT" => "F2"}
  
  attr_accessor :sequence
  attr_accessor :stuff
  
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
  
  def distance(pos1, pos2)
    ((pos2 - pos1).abs)+1
  end
  
  def distance_score(pos1, pos2)
    Rational(1, distance(pos1, pos2))
  end
end