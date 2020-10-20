# OptimalEffort_Pupillometry
Optimal effort task designed to use with pupillometry device Eyelink 1000 eyetracker.

There are two phases to this experiment:
1) Capacity Phase
2) Performance Phase

In both phases, participants solve arithmetic summation problems. In the capacity phase, the difficulty of the arithmetic summation problems increase by one level as the participant correctly solves at least 1 out 5 questions at that level. The difficulty increases until the participant's accuracy at a given difficulty level is 0/5. The difficulty levels at which the participant scores .75, .5 and .25 correct are estimated by fitting a sigmoidal function to the Capacity phase accuracy data. 

In the Performance Phase, participants solve 4 different difficulty levels in blocks of 8 questions. Each block is presented twice. Following the performance of each block, participants indicate their perceived engagement, liking and ability during the block. Each question starts with the presentation of a task cue, and followed by the performance of the arithmetic problem. Participants make a free response and receive accurate feedback. Trial deadline is 18 sec. Pupil size is recorded during the presentation of the task cue, the fixation cross before task performance and performance feedback.


## Instructions

Download the OptEft_Pupil folder and run the 'Wrapper.m' on Matlab (Psychtoolbox installed). Run as a function, this script sets path to the folder the function is stored and its subfolder (PsychtoolNeces).

When prompted, enter Subject ID, indicate which session it is (1 for starting the from the beginning) and indicate whether you are using recording pupillometry measures or not. 

The data is live updated in OptimalEffort.mat in the project folder.

## Contributing

Fork this project and open a pull request.
