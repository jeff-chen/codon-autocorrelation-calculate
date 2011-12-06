require 'gene_data'

module Calculator
  include GeneData
  
  def indices_from_trna_of(codon, trnas)
    things_to_check = []
    trnas.each_index do |i|
      things_to_check << i if trnas[i] =~ Regexp.new("^" + codon, true)
    end
    things_to_check
  end
  
  def max_autocorrelation_score(char, trnas)
    things_indices = indices_from_trna_of(char, trnas)
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
    things_indices = indices_from_trna_of(char, trnas)
    sum = 0
    return 1 if things_indices.size < 2 
    0.upto(things_indices.size-1) do |i|
      (i+1).upto(things_indices.size-1) do |j|
        sum = sum - distance_score(things_indices[i], things_indices[j])
      end
    end
    sum
  end
  
  def autocorrelation_score(char, trnas)
    things_indices = indices_from_trna_of(char, trnas)
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
    sum / max_autocorrelation_score(char, trnas)
  end
  
  def dica_for(trnas)
    total_codons = 0
    total_score = 0.to_f
    SYNONYMOUS_AMINO_ACIDS.each do |amino_acid|
      total_codons += codons_for_codon_and_trnas(amino_acid, trnas)
      total_score += codons_for_codon_and_trnas(amino_acid, trnas).to_f * autocorrelation_score(amino_acid, trnas)
    end
    return ((total_score.to_f)/(total_codons.to_f)).to_f
  end

  def codons_for_codon_and_trnas(codon, trnas)
    trnas.select{|i| i =~ Regexp.new("^#{codon}")}.size
  end
  
  def distance(pos1, pos2)
    ((pos2 - pos1).abs)+1
  end
  
  def distance_score(pos1, pos2)
    Rational(1, distance(pos1, pos2)).to_f
  end
end