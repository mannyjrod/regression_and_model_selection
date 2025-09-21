function safeAddPath(folderPath)
% Author: Copilot
% Date, location: Sat. 20SEP2025 17:11, RV, Renton, WA

% safeAddPath(folderPath)
% Validates folder existence before adding to MATLAB path.
% If folder exists, adds it to the path and confirms success.
% If folder does not exist, displays a warning with diagnostics.

    if nargin == 0 || ~ischar(folderPath)
        error('safeAddPath:InvalidInput', 'Input must be a valid folder path string.');
    end

    if isfolder(folderPath)
        addpath(folderPath);
        disp(['✅ Folder added to path: ', folderPath]);
    else
        warning('safeAddPath:FolderNotFound', ...
            ['⚠️ Folder does not exist: ', folderPath]);
        disp(['Current working directory: ', pwd]);
        disp('Please verify the folder name and its relative or absolute location.');
    end
end

%[appendix]{"version":"1.0"}
%---
