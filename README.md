# Function to create LDPC codes

## To create lad files:

1. First we need to create .dat file using PEG software.
2. Syntax:  ./peg-unige/MainPEG -numM [number_of_periods] -numN [code_length] -codeName [output_file_name] -degFileName [configuration_file]
3. Example: ./peg-unige/MainPEG -numM 157 -numN 17113 -codeName Reg17113_109.dat -degFileName Reg_3.deg
4. Now navigate to matlab folder.
5. Run findseq function to get the sequence giving period as an argument.
6. Example: For period 109, we use factorable nearest value i.e. 108.
7. [seq = findseq(108); seq = [109 seq(2:end) 108]]
8. Put this sequence into the txSeq variable and update numCodes and period variable accordingly. Run the function providing path's of input and output files.
9. Example: peg2lad( fullfile('..','dat','Reg17113_109.dat'), fullfile('..','lad','RegDecoder17113_109.lad') )
10. To generate encoder file open up the generated ladder file. Remove all the codes except the last code. Each code consists starts from code number and consist of three lines.