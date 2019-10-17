# Bioinformatics_project2019 Shell Script. 

# Usage: bash Project.sh

# The following commands clear the contents of the alignment files created. This allows the user 
# to bash the shell script multiple times in case they need to edit it. 

echo 1 > hsp70align.fasta    
cat hsp70align.fasta| tail -n +2 > hsp70align.fasta 

echo 1 > mcrAalign.fasta
cat mcrAalign.fasta| tail -n +2 > mcrAalign.fasta  

# The following loops cocatenates the contents of the files containing the variations of the hsp70
# gene and the mcrA gene. These files will be sent to the MUSCLE tool for alignment. They are 
# both in .fasta format.
 
for x in "./ref_sequences/hsp*.fasta"  
do
        cat $x >> hsp70align.fasta

done

for y in "./ref_sequences/mcrA*.fasta"
do

	cat $y >> mcrAalign.fasta
done

# The cocatenated files for the hsp70 and mcrA gene are sent to the MUSCLE tool for alignment.
# The output files are in .fasta format.

./muscle3.8.31_i86linux64 -in ./ref_sequences/hsp70align.fasta -out hsp70muscle.fasta

./muscle3.8.31_i86linux64 -in ./ref_sequences/mcrAalign.fasta -out mcrAmuscle.fasta

# The MUSCLE alignments are sent to the HMMBUILD tool.This will create a hidden Markov model or
# a "fuzzy picture" of what the gene looks like.  The .hmm files outputed will be sent to
# the HMMSEARCH tool.

~/Private/bioinformatics_project2019/hmmer-3.2/hmmbuild hsp70.hmm hsp70muscle.fasta

~/Private/bioinformatics_project2019/hmmer-3.2/hmmbuild mcrA.hmm mcrAmuscle.fasta 

# The following loop will compare each of the 50 proteome seqeuences to the hsp70 and mcrA gene 
# alignments using the HMMSEARCH tool. Directs the output to the designated file. 

for k in ./proteomes/proteome_*
do
	./hmmer-3.2/hmmsearch hsp70.hmm $k > hsp70.out 
	./hmmer-3.2/hmmsearch mcrA.hmm $k > mcrA.out
done
