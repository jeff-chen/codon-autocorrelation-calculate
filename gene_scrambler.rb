require 'translator'
require 'gene_data'

class GeneScrambler
  include GeneData
  include Calculator
  
  attr_accessor :translator
  attr_accessor :trnas
  
  def shuffled_trnas
    #return @shuffled_trnas if @shuffled_trnas #weird
    if translator && translator.trnas
      @shuffled_trnas = translator.trnas
      SYNONYMOUS_AMINO_ACIDS.each do |acid|
        positions = translator.trna_indices_for(acid)
        scrambled = scrambled_trnas_of(acid)
        positions.each_with_index do |pos, i|
          @shuffled_trnas[pos] = scrambled[i]
        end
      end
      @shuffled_trnas
    else
      raise "No sequence provided"
    end
  end
  
  def original_trnas_of(trna)
    translator.trnas.select{|i| i =~ Regexp.new("^" + trna, true)}.compact
  end
  
  def randomized_dica
    dica_for(shuffled_trnas)
  end
  
  def scrambled_trnas_of(trna)
    original_trnas_of(trna).shuffle
  end
  
  def trna_transitions_of(trna)
    count_transitions(original_trnas_of(trna))
  end
  
  def count_transitions(trnas)
    transitions = 0
    trnas.each_with_index do |t, i|
      if trnas[i+1]
        transitions += 1 if trnas[i+1] != t
      end
    end
    transitions
  end
  
  def scrambled_trna_transitions_of(trna)
    count_transitions(scrambled_trnas_of(trna))
  end
  
  def scrambled_trna_transitions
    total = 0
    SYNONYMOUS_AMINO_ACIDS.each do |acid|
      total += scrambled_trna_transitions_of(acid)
    end
    total
  end
  
  def trna_transitions
    total = 0
    SYNONYMOUS_AMINO_ACIDS.each do |acid|
      total += trna_transitions_of(acid)
    end
    total
  end

end