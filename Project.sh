# Shell Script to cocatenate all of the possible variations of the hsp70 gene into one file, 
# and all of the possible variation of the mcrA gene into one file. This script will then 
# run the two files created through the MUSCLE tool aligner and output two new .fasta files.
# Next, the results of the MUSCLE aligner will be passed to the HMMERBUILD tool.

# Usage: bash Project.sh

for x in "./ref_sequences/hsp*.fasta"
do

        cat $x >> hsp70align.fasta

done

for y in "./ref_sequences/mcrA*.fasta"
do
	
	cat $y >> mcrAalign.fasta
done

./muscle3.8.31_i86linux64 -in ./ref_sequences/hsp70align.fasta -out hsp70muscle.fasta

./muscle3.8.31_i86linux64 -in ./ref_sequences/mcrAalign.fasta -out mcrAmuscle.fasta

~/Private/bioinformatics_project2019/hmmer-3.2/hmmbuild hsp70.hmm hsp70muscle.fasta

~/Private/bioinformatics_project2019/hmmer-3.2/hmmbuild mcrA.hmm mcrAmuscle.fasta 



