require 'translator'
require 'log_distance_translator'

describe Translator do
  before do
    @translator = Translator.new
  end
  it 'does something' do
    @translator.sequence = "ATGAAAAAAAAAAAAAAATAA"
    @translator.to_protein.should == "MKKKKK"
  end
  
  it 'stores the tRNA information' do
      @translator.sequence = "ATGAAAAAAAAAAAAAAATAA"
      @translator.trnas.should == ['M', 'K1', 'K1', 'K1', 'K1', 'K1', '#']
  end
  
  it 'grabs all tRNAs of a specific type' do
    @translator.sequence = "ATGGGTGGTGGTGGTGGTTAA"
    @translator.trna_indices_for("G").should == [1,2,3,4,5]
  end
  
  it 'autocorrelates the uniform case correctly' do
    @translator.sequence = "ATGGGTGGTGGTGGTGGTTAA"
    @translator.autocorrelation_score_for("G").should == 1
  end
  
  it 'calculates -1 for a perfectly unique codon for each position' do
    @translator.sequence = "ATGTCGAGCTCCTCATAA"
    @translator.autocorrelation_score_for("S").should == -1
  end
  
  it 'autocorrelates the maximum case correctly' do
    @translator.sequence = "ATGAAAAAAAAATAA"
    @translator.max_autocorrelation_score_for("K").to_f.should == Rational(4,3).to_f #1/2 + 1/2 + 1/3
  end
  
  it 'autocorrelates mixed cases correctly' do
    @translator.sequence = "ATGCCCCCCCCGTAA"
    @translator.autocorrelation_score_for("P").to_f.should == Rational(-1,4).to_f #1/2 - 1/2 - 1/3 / 1/2 + 1/2 + 1/3 = (-1/3)/(4/3)
  end
  
  it 'can find how often a given amino acid occurs' do
    @translator.sequence = "ATGAAAAAAAAACGGAGGTAA"
    @translator.codons_for("M").should == 1
    @translator.codons_for("K").should == 3
    @translator.codons_for("R").should == 2
  end
  
  it 'calculates a total correlation score' do
    @translator.sequence = "ATGGGTGGTGGTCGGAGGTAA"
    @translator.total_autocorrelation.to_f.should == Rational(1,5).to_f #3/5 from complete auto, -2/5 from other
  end
  
  describe 'matched and mismatched distances' do
    it 'finds the distances between matched synonymous codons as well as mismatches' do
      @translator.sequence = "ATGGGTGGTGGTCGGAGGTAA"
      @translator.matched_distances.should == [2,3,2]
      @translator.mismatched_distances.should == [2]
    end
    
    it 'correctly incorporates information from different amino acids' do
      @translator.sequence = "ATGGGTGGGGGTCGGAGGCGGTAA"
      @translator.matched_distances.should == [3,3]
      @translator.mismatched_distances.should == [2,2,2,2]
    end
    
    it 'does not include amino acids if a particular one occurs only once' do
      @translator.sequence = "ATGGGTGGGGGTCGGTAA"
      @translator.matched_distances.should == [3]
      @translator.mismatched_distances.should == [2,2]
    end
    
    it 'gets the average match distance' do
      @translator.sequence = "ATGGGTGGTGGTCGGAGGTAA"
      @translator.matched_distance_average.to_f.should == Rational(7,3).to_f
      @translator.mismatched_distance_average.to_f.should == Rational(2,1).to_f
    end
    
    it 'gets a sorted hash of how often each match occurs' do
      @translator.sequence = "ATGGGTGGTGGTCGGAGGTAA"
      @translator.matched_distances.should == [2,3,2]
      @translator.matched_distance_distribution.should == [[2,2],[3,1]]
    end
    
    describe 'distribution_to_hash' do
      it 'makes a histogram of elements in an array' do
        @translator.distribution_to_hash([2,2,3,4]).should == {"2" => 2, "3" => 1, "4" => 1}
      end
    end
    
    describe 'match/mismatch ratio' do
      it 'calculates the match and mismatch ratio of each distance relative to the distance at 2' do
        @translator.sequence = "ATGGGTGGTGGTCGGAGGTAA"
        #@translator.matched_distances.should == [2,3,2]
        #@translator.mismatched_distances.should == [2]
        #the ratio of 2 is 2/3, 3 is 1
        @translator.ratios.should == [[2,Rational(2,3).to_f], [3,1.0]]
      end
      
      it 'gets the normalized ratios' do
        @translator.sequence = "ATGGGTGGTGGTCGGAGGTAA"
        #2/3 / 2/3, 1 / 2/3
        @translator.normalized_ratios.should == [[2,1.0], [3,Rational(3,2).to_f]]
      end
      
      it 'seperates the normalized ratios in csv format if there is a hole' do
        @translator.sequence = "ATGGGTGGTGGTCGGAGGTAA"
        @translator.normalized_ratios_csv.should == "1.0,1.5,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
      end
      
    end
    
  end
end

describe LogDistanceTranslator do
  before do
    @translator = LogDistanceTranslator.new
  end
  it 'still calculates 1 for perfectly redundant and autocorrelated sequences' do
    @translator.sequence = "ATGGGTGGTGGTGGTGGTTAA"
    @translator.autocorrelation_score_for("G").should == 1
  end
  
  it 'calculates -1 for a perfectly unique codon for each position' do
    @translator.sequence = "ATGTCGAGCTCCTCATAA"
    @translator.autocorrelation_score_for("S").should == -1
  end
end