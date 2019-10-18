## Bioinformatics_project2019 Shell Script. 

## Usage: bash Project.sh

# The user's file system should be organized as follows in order to run this script:
#	bioinformatics_project2019 --> proteomes/, ref_sequences/, Project.sh, hmmer, muscle
#	hmmer --> hmmerbuild, hmmsearch

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

./muscle -in ./ref_sequences/hsp70align.fasta -out hsp70muscle.fasta

./muscle -in ./ref_sequences/mcrAalign.fasta -out mcrAmuscle.fasta

# The MUSCLE alignments are sent to the HMMBUILD tool.This will create a hidden Markov model or
# a "fuzzy picture" of what the gene looks like.  The .hmm files outputed will be sent to
# the HMMSEARCH tool.

./hmmer/hmmbuild hsp70.hmm hsp70muscle.fasta

./hmmer/hmmbuild mcrA.hmm mcrAmuscle.fasta 

# The following loop will compare each of the 50 proteome seqeuences to the hsp70 and mcrA gene 
# alignments using the HMMSEARCH tool. Directs the output to the designated file. 

num=$(0)

echo 1 > results.csv
cat results.csv| tail -n +2 > results.csv # Clears the results file for new compiling

echo Proteome   hspHits mcrAhits >> results.csv # Header for results.csv

for k in ./proteomes/proteome_*
do

	num=$(($num + 1))
	
	proteome=$(echo proteome_$num)

	./hmmer/hmmsearch --tblout hsp70.out hsp70.hmm $k
	
	hsp=$(cat hsp70.out | grep -v "^#" | uniq | wc -l)
	 
	./hmmer/hmmsearch --tblout mcrA.out mcrA.hmm $k
	
	mcrA=$(cat mcrA.out | grep -v "^#" | uniq | wc -l)

	echo $proteome	$hsp	$mcrA >> results.csv

done

# This pipe  will search through the rows of the results.csv for the top 3 candidates for 
# pH-resistant methanogens based on the results of the hsp70 and mcrA gene hits. Any proteomes
# that did not match the mcrA gene at least once, and therefore are not methanogens, were eliminated.
# Of the proteomes remaining, the 3 that had the most hsp70 gene matches were chosen.

cat results.csv | tail -n +2 | awk -F ' ' '$3>=1'|sort -k2 -n| tail -n 3 | cut -d " " -f 1 > Candidates.txt


## Description of the files outputed in this script:
	# Candidates.txt --> contains top 3 pH-resistant methanogens
	# hsp70align.fasta --> cocatenated hsp70 reference gene sequences
	# hsp70.hmm --> output from HMMBUILD hsp gene
	# hsp70muscle.fasta --> output from MUSCLE alignment for hsp gene
	# hsp70.out --> table output from HMMSEARCH for hsp gene
	# mcrAalign.fasta --> cocatenated mcrA reference gene sequences
	# mcrA.hmm --> output from HMMBUILD for mcrA gene
	# mcrAmuscle.fasta --> output from MUSCLE alignment for mcrA gene
	# mcrA.out --> table output from HMMSEARCH for mcrA gene
	# Project.sh --> shel script
	# results.csv --> table of the gene search results for each proteome

