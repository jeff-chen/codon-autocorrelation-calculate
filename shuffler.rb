#every day i'm shufflin'

require 'gene_data'

module Shuffler
  include GeneData
  
  def scrambled_trnas_of(trna)
    original_trnas_of(trna).shuffle
  end
  
  def original_trnas_of(trna)
    translator.trnas.select{|i| i =~ Regexp.new("^" + trna, true)}.compact
  end
  
  def shuffled_trnas
    #return @shuffled_trnas if @shuffled_trnas #weird
    if translator && translator.trnas
      @shuffled_trnas = translator.trnas.clone
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
end