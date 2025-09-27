%[text] %[text:anchor:H_8B1BEA20] ## Applied Machine Learning - MNIST Data Set
%[text] %[text:anchor:H_89354E30] ### Assignment: Exercise 4-4 (Brunton & Kutz, 2019)
%[text] Script author: Emmanuel Rodriguez
%[text] [emmanueljrodriguez.com](https://emmanueljrodriguez.com/)
%[text] Date: 14DEC2023
%[text] Location: Renton, Seattle, WA
%%
%[text] Version history
%[text] % 14DEC2023: Initial creation
%[text] % 08JUN2025: Completed the 'Analysis \> Load Data' section
%%
%[text] %[text:anchor:H_BD8A9C1D] ## To Do:
%[text] - This problem needs to be completed; you may need to remote into a cluster, so that you can work remotely. - **Ref: OneNote notes 2/25/2023 19:51**
%[text] - - ERODRIGUEZ2, 28DEC2023 21:00
%[text] - Fix issue: The 'Misc' file, under path: MatlabLum \> SDK \> Misc, is not being added to the Matlab path when calling Lum's `AddPathsMatlabLum()` function. I'm having to resort to adding this directory manually via the `addpath` function. An 'automated' Custom Path is always preferred. -ERODRIGUEZ2, 12MAY2025 20:56 \
%%
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] %[text:anchor:H_7671DFB0] ### Requirements
%[text] Using the MNIST data set, use various $Ax=B$ (regression) solvers to map from the image space to the label space.
%[text] By promoting sparsity, rank which pixels in the MNIST set are most informative for correctly labeling the digits.
%[text] - Apply the most significant pixels to the test data set, to evaluate the model's accuracy.
%[text] - Iterate the analysis with each digit individually to find the most important pixels for each digit. \
%[text] <u>Background</u>:
%[text] Modified National Institute of Standards and Technology (MNIST) is a widely used dataset in the field of machine learning and computer vision. It is a collection of handwritten digits (0-9) and is often referred to as the "Hello World" of machine learning due to its simplicity and use as a benchmark for various algorithms.
%%
%[text] %[text:anchor:H_F20B510B] ### Analysis
%[text] %[text:anchor:H_BBAD6E4F] #### Load Data
clear % Clears workspace
clc % Clears command window
close all % Closes all figures
%%
% Add custom paths
addpath('MatlabLum/SDK/Misc')  % Files repo: https://github.com/mannyjrod/MatlabLum.git
%%
tic % start timer to measure elapsed time in performing the computation

%% Data files
fileNameTrainingSetImages = 'train-images-idx3-ubyte.gz';
fileNameTrainingSetLabels = 'train-labels-idx1-ubyte.gz';

fileNameTestSetImages = 't10k-images-idx3-ubyte.gz';
fileNameTestSetLabels = 't10k-labels-idx1-ubyte.gz';

downloadBaseURL = 'http://yann.lecun.com/exdb/mnist';

outputFileName = 'MNISTInfo.mat'; % The output file name will be saved as a MAT-file with
% the name set to 'MNISTInfo'; a MAT-file is a type of binary file to store MATLAB workspace
% variables and data.

% This file acts as a container for functions, matrices, and other data, to
% allow workspace data to be saved and reused across different sessions by
% loading the data back into the MATLAB environment.
%%
% **Note: As of 5/11/25, the URL server
% 'http://yann.lecun.com/exdb/mnist/[fileNameXYZ]' does not contain any
% data. 
% 
% **- This code section is being omitted from the project code execution, 
% and the data files should be called from the local machine.**

% Download data
% if (~exist(fileNameTrainingSetImages)) % If this file name does not exist, then perform...
%     disp(['Downloading ', fileNameTrainingSetImages]); % Display message to user
%     websave(fileNameTrainingSetImages, [downloadBaseURL, '/', fileNameTrainingSetImages]); % saves the training set of images from the url and saves it to the specified file name.
% end
% 
% if (~exist(fileNameTrainingSetLabels)) % If this file name does not exist, then perform...
%     disp(['Downloading ', fileNameTrainingSetLabels]);
%     websave(fileNameTrainingSetLabels, [downloadBaseURL, '/', fileNameTrainingSetLabels]); % saves the training set of images from the url and saves it to the specified file name.
% end
% 
% if (~exist(fileNameTestSetImages))
%     disp(['Downloading ', fileNameTestSetImages]);
%     websave(fileNameTestSetImages, [downloadBaseURL, '/', fileNameTestSetImages]);
% end
% 
% if (~exist(fileNameTestSetLabels))
%     disp(['Downloading ', fileNameTestSetLabels]);
%     websave(fileNameTestSetLabels, [downloadBaseURL, '/', fileNameTestSetLabels]);
% end
%%
% Test code:
%gunzip(fileNameTrainingSetImages,'outputFolderTrainingSetImages')
%%
% Note: Prior to running the below code block, the data files were manually
% given the .gz file extension; the first argument in the 'gunzip' function
% the gzipfilename must match the file's variable name exactly, which
% as assigned above in the data files section, includes the file extension
% in the file name.
%%
%% Unzip data
disp('Unzipping data') %[output:77d81fc1]

% Use the sub-routine 'SeperateFileNameAndExtension' and give it the file name
% as the input argument, which will seperate the file name and the
% extension; the output argument outputFolderTrainingSetImages will be set
% to the file name as a string type.

[outputFolderTrainingSetImages, ~] = SeperateFileNameAndExtension(fileNameTrainingSetImages) %[output:3effadc0]
if(~exist(outputFolderTrainingSetImages))
    gunzip(fileNameTrainingSetImages, outputFolderTrainingSetImages)
end

[outputFolderTrainingSetLabels, ~] = SeperateFileNameAndExtension(fileNameTrainingSetLabels) %[output:3d91605f]
if(~exist(outputFolderTrainingSetLabels))
    gunzip(fileNameTrainingSetLabels, outputFolderTrainingSetLabels)
end

[outputFolderTestSetImages, ~] = SeperateFileNameAndExtension(fileNameTestSetImages) %[output:6af948c6]
if(~exist(outputFolderTestSetImages))
    gunzip(fileNameTestSetImages, outputFolderTestSetImages)
end

[outputFolderTestSetLabels, ~] = SeperateFileNameAndExtension(fileNameTestSetLabels) %[output:9d364b1f]
if(~exist(outputFolderTestSetLabels))
    gunzip(fileNameTestSetLabels,outputFolderTestSetLabels)
end
%%
%% Save relevant information

% Create a structure data array, and store the various output folders as
% fields within the structure.
MNISTInfo.outputFolderTrainingSetImages = outputFolderTrainingSetImages;
MNISTInfo.outputFolderTrainingSetLabels = outputFolderTrainingSetLabels;
MNISTInfo.outputFolderTestSetImages = outputFolderTestSetImages;
MNISTInfo.outputFolderTestSetLabels = outputFolderTestSetLabels;

% I.e., 
% Structure data array: MNISTInfo
% Field within structure: outputFolderTrainingSetImages
%%
cwd = pwd; % the function 'pwd' identfies the path to the working directory, or current folder.
MNISTInfo.ApplicationDirectory = fileparts(cwd); % 'fileparts' gets parts of file name,
% returns the path name, file name, and extension for the specified file.

% I'm storing this info in the 'MNISTInfo' structure under the
% 'ApplicationDirectory' field.
%%
save(outputFileName,"MNISTInfo") % Save variables from workspace to file
disp(['Saved to ', outputFileName]) %[output:87e9ec31]
% Saves the current workspace to a MAT-file, in the above line the .mat
% file is named 'MNISTInfo'.
%%
toc % read elapsed time from stopwatch %[output:81f97080]
disp('Done loading data! :)') %[output:32e53bca]
%%
%[text] %[text:anchor:H_4b5d] #### Parse Dataset
%%
%[text] The MNIST dataset is stored as raw data (bytes) and must be parsed to obtain individual images and labels.
%[text] - \[In computing, to **parse** means to take a piece of data - often a string of text or code - and analyze its structure in order to extract meaning, break it into components, or transform it into a more usable form.\] \
%%
% Lets clear things out, and load the workspace -- just for the practice.
% :)
clear
clc
close all
%%
tic % start timer

%% User selections
sampleBetweenDiagnostics = 500;
outputFileName = 'MNISTData.mat';
%%
%% Load parameters
temp = load('MNISTInfo.mat'); % Load the 'Load Data' section's workspace variables to the TEMP structure. 
MNISTInfo = temp.MNISTInfo; % Create a second variable to hold the structure; this avoids unintended overwriting of the original structure.

% *** Recall: "dot notation" in object-oriented programming... (ref. Gaddis, p. 530)
% LHS of dot is the name of the CLASS variable being called, e.g., 'temp'
% RHS of dot is the name of the METHOD being called, e.g., 'MNISTInfo'
%%
%% Parse data

% Training Set Images
fileName = [MNISTInfo.outputFolderTrainingSetImages];%, '/', MNISTInfo.outputFolderTrainingSetImages];
disp(['Now reading from ', fileName])
%[text] **Important note:** Deviated from Lum's code by setting only the top-level file name to the `fileName` variable. A *warning* was being thrown when appending the file name with the lower-level file (of the same name).
%%
% 20SEP2025 17:15  -- come back to this, not sure why a
% train-images-idx3-ubyte folder isn't being created...

% Use the 'safeAddPath' routine to validate folder existence before adding
% to path; if it exists, the file will be added to the directory.

safeAddPath(fileName); % Add the Training Set Images file name (path) to the search path.
%[text] Some notes on adding to the **search path:**
%[text] - `addpath` function is used to **dynamically add folders to the search path,** which tells MATLAB where to look for functions, scripts, and other files that aren't in the current working directory.
%[text] - `addpath` is my way of saying, "Hey MATLAB, include this folder when you go looking for stuff." \
%%
% Now append the file:
fileName = [fileName, '/', 'train-images-idx3-ubyte']; % Append the file name with the lower-level file in order for the FOPEN function to WORK.
%%
%[text] %[text:anchor:H_09dc] <u>Background and Terminology</u>
%[text] Recall: The objective of this section is to develop a data **parser** - in the case of the MNIST dataset, the parser's objective is to transform the raw data files into usable form.
%[text] As such, any pragmatic programmer will bake-in a `try, catch` block to "check" the data file's parameters for *adherence* to MNIST documentation.
%[text] - E.g., Is the file being read a *training image* file as expected? Does it have the expected size (\# of pixels)? And what is the quantity of training files? \
%[text] `machinefmt` - The argument used in the `fopen` function sets the order for reading bytes or bits in a file.
%[text] - Big-endian order refers to where the most significant byte (the "big end") is stored, or read, first. The most significant byte at the lowest address. \
imshow('big- v. little-endianness.png')
imshow('32-bit_integer_format.png')
%[text] `try, catch` - statement
%[text] - For practice using this scheme, see 'Error\_Handling\_practice.mlx' \
%[text] `magicNumber` - For the MNIST dataset, the first four bytes of the *training-images-idx3-ubyte* file contain the magic number which has been set to `2051`.
imshow('magicNumber.png')
%%
% try, catch -- this statement is used for error handling, allows
% the execution of code (in the 'try' block) while catching and managing
% potential errors (in the 'catch' block). It prevents abrupt program
% termination and enables alternative actions when an error occurs, or an exception is thrown.

% TRY-CATCH block with multiple (4) ASSERT conditions and unique, value-embedded
% cause messages:
try
    % Initalize base exception
    baseException = MException('Validation:HeaderCheckFailed', ...
        'One ore more header values failed validation.');
    % Set FOPEN function parameters
    permission = 'r'; % type of access to be used as input argument into the 'fopen' function; e.g., reading, writing, reading and writing, the 'r' opens the file for reading
    machinefmt = 'b'; % order for reading bytes in the file; 'b' designates Big-endian ordering, which according to Lum, MNIST documentation states data is stored in this format
    
    fileID = fopen(fileName, permission, machinefmt); % Opens the file
    %% Four 'elements' of the file will be run through this TRY block;
    %
    % 1. magicNumber is checked against 2051, which is the value of the
    % first 4 bits in the 32-bit integer for the TRAINING image files 
    % (the labels files' magic number is 2049).
    % 
    % 2. the next set of 4 bits contain the quantity of files
    %
    % 3. the next set of 4 bits contain the number of rows, which should 
    % be 28, for a 28x28 pixel image
    %
    % 4. then the next set of 4 bits contain the number of columns, which
    % again should be 28.
    %

    magicNumber = fread(fileID, 1, 'int32'); % Reads data from binary file into variable
    % 'magicNumber', and we are reading only one element / size '1' of class and size set
    % to 32-bit integer, signed.
    % Re: Use of the variable name 'magicNumber' -- referring to a literal
    % constant value that appears directly in code without explanation;
    % considered bad practice when it's unclear what the number represents,
    % since it is a mysterious value hardcoded into logic.

    numItems = fread(fileID, 1, 'int32');
    numRows = fread(fileID, 1, 'int32');
    numCols = fread(fileID, 1, 'int32');
    % **NOTE: Once one 32-bit integer is read from the file, the next call
    % to read a 32-bit integer reads the "next" 32-bit integer; this
    % is why the input arguments to the FREAD function remain the same for
    % the four elements, once one has been read, then the reader will read
    % the next, and so on.

    % Assertion 1: Magic Number
    try
        assert(magicNumber == 2051, ...
            'Validation:InvalidMagicNumber', ...
            ['Magic number mismatch: Expected 2051 for training image file, but received ', ...
            num2str(magicNumber), '.']);
    catch cause1
        baseException = addCause(baseException, cause1);
    end

    % Assertion 2: Number of Items
    try
        assert(numItems == 60000, ...
            'Validation:UnexpectedItemCount', ...
            ['Item count mismatch: Expected 60,000 images, but received ', ...
            num2str(numItems), '.']);
    catch cause2
        baseException = addCause(baseException, cause2);
    end

    % Assertion 3: Number of Rows
    try
        assert(numRows == 28, ...
            'Validation:InvalidRowDimension', ...
            ['Row dimension mismatch: Expected 28 pixels per image row, but received ', ...
            num2str(numRows), '.']);
    catch cause3
        baseException = addCause(baseException, cause3);
    end

    % Assertion 4: Number of Columns
    try
        assert(numCols == 28, ...
            'Validation:InvalidColumnDimension', ...
            ['Column dimension mismatch: Expected 28 pixels per image column, but received ', ...
            num2str(numCols), '.']);
    catch cause4
        baseException = addCause(baseException, cause4);
    end

    % Only throw if any assertion failed.
    if ~isempty(baseException.cause)
        throw(baseException);
    else
        disp('✅ All header values passed validation.');
    end

    fclose(fileID);

catch ME
    % Display full error report, including all causes

    disp('❌ Validation Error Encountered:');
    disp(getReport(ME, 'extended'));
end
% (I LOVE COPILOT!!)
%%
% 9/1/25 -- Continue with the above TRY-CATCH block; next is to embed the
% following:

    TrainingSetImages = uint8(zeros(numRows, numCols, numItems)); % UINT8 converts the input argument values to type uint8;
    % This is initializing an array of [numRows x numCols x numItems] of
    % zeros of type 'uint8' (unsigned 8-bit integer).
    for k = 1:numItems
        A = uint8(zeros(numRows, numCols));
        for m = 1:numRows
            for n = 1:numCols
                A(m,n) = fread(fileID, 1, 'uint8');
            end
        end

        TrainingSetImages(:,:,k) = A;

        if(mod(k, samplesBetweenDiagnostics)==0)
            disp([num2str(k/numItems*100), '% complete'])
        end
    end

    assert(max(max(max(TrainingSetImages))) <= 255)
    assert(min(min(min(TrainingSetImages))) >= 0)

    fclose(fileID);

    % (Using Lum's code-base as a guide.) -ERODRIGUEZ2, 1SEP2025 17:25
%%
%[text] Side note:
%[text] `uint8` stands for "unsigned 8-bit integer"
%[text] - Unsigned: It cannot represent negative numbers - only zero or positive values.
%[text] - 8-bit: The number is stored using 8 binary digits, which gives it a range of 0 to 255.
%[text] - Integer: It only holds whole numbers.
%[text] - Application:
%[text] - -- Common in image processing: Most grayscale images use `uint8`, where each pixel has a value between 0 (black) and 255 (white). \
%%
clear % Clears workspace
clc % Clears command window
close all % Closes all figures

% Open file
fid = fopen('t10k-images-idx3-ubyte','r');

% Read file
A = fread(fid,1,'uint32');
totalImages = swapbytes(uint32(A)); % Total images

% Read in number of rows
numRows = swapbytes(uint32(A));

% Read in number of columns
numCols = swapbytes(uint32(A));
%%
clear all;

% Open file
fid = fopen('t10k-images-idx3-ubyte','r');

% Reduce file data size for memory purposes
red = .001; % Reduction factor, 10%

% Read file
A = fread(fid,1,'uint32');
totalImages = swapbytes(uint32(A)); % Total images
totalImages = totalImages*red;

% Read in number of rows
numRows = swapbytes(uint32(A));
numRows = numRows*red;

% Read in number of columns
numCols = swapbytes(uint32(A));
numCols = numCols*red;

ds = datastore('train-images-idx3-ubyte');
tt = tall(ds);
%%
%
images = zeros(numRows, numCols, totalImages, 'uint8');
for k = 1 : totalImages
    %//Read in numRows*numCols pixels at a time
    A = fread(fid, numRows*numCols, 'uint8');
    %//Reshape so that it becomes a matrix
    %//We are actually reading this in column major format
    %//so we need to transpose this at the end
    images(:,:,k) = reshape(uint8(A), numCols, numRows)';
end

%//Close the file
fclose(fid);
%%
%[text] %[text:anchor:H_DE839934] ### References and Resources
%[text] Brunton, S. L., & Kutz, J. N. (2019). *Data-Driven Science and Engineering.* Cambridge: Cambridge University Press.
%[text] Chapra, S. C., & Canale, R. P. (2014). *Numerical Methods for Engineers* (7th ed.). New York: McGraw-Hill Higher Education.
%[text] "The MNIST Database," YouTube video: [https://www.youtube.com/watch?v=NS2FI6vR3BY](https://www.youtube.com/watch?v=NS2FI6vR3BY) 
%[text] Lum, C. *GitHub repository*: [https://github.com/clum/YouTube/tree/main/AIML09](https://github.com/clum/YouTube/tree/main/AIML09) 
%[text] Magic number in the MNIST Dataset explanation: [https://medium.com/the-owl/converting-mnist-data-in-idx-format-to-python-numpy-array-5cb9126f99f1](https://medium.com/the-owl/converting-mnist-data-in-idx-format-to-python-numpy-array-5cb9126f99f1) 
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":35.4}
%---
%[output:77d81fc1]
%   data: {"dataType":"text","outputData":{"text":"Unzipping data\n","truncated":false}}
%---
%[output:3effadc0]
%   data: {"dataType":"textualVariable","outputData":{"name":"outputFolderTrainingSetImages","value":"'train-images-idx3-ubyte'"}}
%---
%[output:3d91605f]
%   data: {"dataType":"textualVariable","outputData":{"name":"outputFolderTrainingSetLabels","value":"'train-labels-idx1-ubyte'"}}
%---
%[output:6af948c6]
%   data: {"dataType":"textualVariable","outputData":{"name":"outputFolderTestSetImages","value":"'t10k-images-idx3-ubyte'"}}
%---
%[output:9d364b1f]
%   data: {"dataType":"textualVariable","outputData":{"name":"outputFolderTestSetLabels","value":"'t10k-labels-idx1-ubyte'"}}
%---
%[output:87e9ec31]
%   data: {"dataType":"text","outputData":{"text":"Saved to MNISTInfo.mat\n","truncated":false}}
%---
%[output:81f97080]
%   data: {"dataType":"text","outputData":{"text":"Elapsed time is 895.446395 seconds.\n","truncated":false}}
%---
%[output:32e53bca]
%   data: {"dataType":"text","outputData":{"text":"Done loading data! :)\n","truncated":false}}
%---
