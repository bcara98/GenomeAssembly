# Background and Strategy Presentation
### General Topics to consider mentioning:
1. background, overview, and core concepts
1. description of tasks, algorithms uses, qualitative comparisons
1. proposed approach and analysis workflow
1. task descriptions and delegations

### Notes:
- 6 of 6 standing to present
- 8:28-8:46 - on time as-expected, great
- excellent overall breakdown of biological task/problem (outbreak analysis)
- why use dbgraph approach
- ref -vs- de novo advantages and disadvantages table (nice!)
- workflow graph, diplayed very well!
- fastqc but read dupe missing so fastp, faqc, falco, trimgalore, bbduk
- asm:  velvet, abyss, megahit, spades, idba_ud
- post-asm: busco, quast, genomeqc, reapr

### Comments:
- excellent *all* contributed at least 2 min to oral presentation, please do similar style for results presentation. It's excellent practice for all of you
- no listing of task delegations could be troublesome, consider clarifying those for everyone to have clear expectations
- please upload presentation here on the repo

### Suggestions:
- tons of pkgs listed for each step, great overview of options, but definitely trim down quickly to get going...
- pre-asm: choose 2 trimmers at most; only group to mention faqc and falco, sort of interested how 1 of those perform; trimgalore is terribly slow and imcomplete compared to others, I'd skip that one too
- asm: skip velvet and abyss for sure!
- post-asm: please definitely do an advanced post-assembly analysis like BUSCO, it will help your future groups that depend on your data
- A blunt approach of do a bunch of stuff for all samples is OK, but really not clever or ideal... consider altering your initial approach. Assembly can take quite a long while for an individual sample (unlike the next main step of gene prediction). You might consider creating a carefully selected subpanel of read sets (maybe 20%), have **good justification** why those are representative and will handle all the rest, and do more thorough analysis on those. For example, sorting by size, the smallest set I'd go start-to-finish on because it should be the fastest to work out many issues. The largest handles the opposite - tons of data, and some intermediates necessary too to draw conclusions. After comprehensive evaluation of the subpanel, just do the top 2 or 3 for the remaining read sets, and apply the same eval criteria to decide which are best to pass onto the next group. But if you have the compute resources to run all on all, go for it!
- *never* use SPAdes v3.12.0 https://github.com/ablab/spades/issues/273 Notice it was never listed as a bug in their version releases to acknowledge they made an error and corrected it

### Grade:
- to be determined by @hsong343
- no significant issues by me
