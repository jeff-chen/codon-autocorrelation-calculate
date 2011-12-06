module GeneData
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
end