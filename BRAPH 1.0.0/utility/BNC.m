classdef BNC
    % BNC : Set of constants and auxiliary methods for Braph
    %
    % BNC properties (Constants):
    %   BN_NAME            -   Braph name
    %   COLOR              -   Braph default color
    %   FONT               -   Braph default font
    %
    %   BUILT              -   Braph number (sequential number)
    %   VERSION            -   Braph version (release number)
    %   DATE               -   Braph release date
    %   AUTHORS            -   Braph authors
    %   COPYRIGHT          -   Braph copyright
    % 
    %   CHAR               -   string denoting character format
    %   LOGICAL            -   string denoting logical format
    %   NUMERIC            -   string denoting numeric format
    %   OPTIONS            -   string denoting options format
    %
    %   MSG_GETDIR         -   select directory message
    %   MSG_PUTDIR         -   select directory message
    %
    %   MAT_EXTENSION      -   string denoting MAT file extension
    %   MAT_MSG_GETFILE    -   string denoting MAT file selection
    %   MAT_MSG_PUTFILE    -   string denoting MAT file selection
    %
    %   XML_EXTENSION      -   string denoting XML file extension
    %   XML_MSG_GETFILE    -   string denoting XML file selection
    %   XML_MSG_PUTFILE    -   string denoting XML file selection
    %
    %   TXT_EXTENSION      -   string denoting TXT file extension
    %   TXT_MSG_GETFILE    -   string denoting TXT file selection
    %   TXT_MSG_PUTFILE    -   string denoting TXT file selection
    %
    %   XLS_EXTENSION      -   string denoting XLS file extension
    %   XLS_MSG_GETFILE    -   string denoting XLS file selection
    %   XLS_MSG_PUTFILE    -   string denoting XLS file selection
    %
    % BNC methods:
    %   isCharFormat       -   (Static) checks if format is character
    %   toCharFormat       -   (Static) converts to character format   
    %   isLogicalFormat    -   (Static) checks if format is logical 
    %   toLogicalFormat    -   (Static) converts to logical format
    %   isNumericFormat    -   (Static) checks if format is numeric
    %   toNumericFormat    -   (Static) converts to numeric format
    %   isOptionFormat     -   (Static) checks if format is option
    %   toOptionFormat     -   (Static) converts to option format
    %   fileExists         -   (Static) checks if file exists
    %   dirExists          -   (Static) checks if directory exists 
    %   fullfile           -   (Static) builds a file name
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % Braph
        BN_NAME = 'Braph'
        COLOR = [.9 .4 .1]
        FONT = 'Helvetica'

        % version number
        BUILT = 52
        VERSION = '1.0.0'
        DATE = '2016-04-21'
        AUTHORS = 'Mite Mijalkov, Ehsan Kakaei, Joana Braga Pereira, Eric Westman, Giovanni Volpe'
        COPYRIGHT = ['Copyright 2014-' datestr(now,'yyyy')]
        
        % data formats
        CHAR = 'char'
        LOGICAL = 'logical'
        NUMERIC = 'numeric'
        OPTIONS = 'options'  % cell array of alternative strings
        
        % file formats and dialogs
        MSG_GETDIR = 'Select directory'
        MSG_PUTDIR = 'Select directory'
        
        MAT_EXTENSION = '*.mat';
        MAT_MSG_GETFILE = 'Select MAT file';
        MAT_MSG_PUTFILE = 'Select MAT file';

        XML_EXTENSION = '*.xml'
        XML_MSG_GETFILE = 'Select XML file'
        XML_MSG_PUTFILE = 'Select XML file'
        
        TXT_EXTENSION = '*.txt'
        TXT_MSG_GETFILE = 'Select TXT file'
        TXT_MSG_PUTFILE = 'Select TXT file'
        
        XLS_EXTENSION = {'*.xlsx';'*.xls'}
        XLS_MSG_GETFILE = 'Select Excel file'
        XLS_MSG_PUTFILE = 'Select Excel file'
    end
    methods (Static)
        function bool = isCharFormat(value)
            % ISCHARFORMAT checks if format is character
            %
            % BOOL = ISCHARFORMAT(VALUE) returns true if the string VALUE
            %   is BNC.CHAR and false otherwise.
            %
            % See also BNC, char.
            
            bool = strcmpi(value,BNC.CHAR);
        end
        function str = toCharFormat(value)
            % TOCHARFORMAT converts to character format
            %
            % STR = TOCHARFORMAT(VALUE) converts the input VALUE 
            %   to the string of characters STR.
            %
            % See also BNC, char.
            
            str = char(value);
        end
        function bool = isLogicalFormat(value)
            % ISLOGICALFORMAT checks if format is logical
            %
            % BOOL = ISLOGICALFORMAT(VALUE) returns true if the string VALUE
            %   is BNC.LOGICSAL and false otherwise.
            %
            % See also BNC, logical.
            
            bool = strcmpi(value,BNC.LOGICAL);
        end
        function bool = toLogicalFormat(value)
            % TOLOGICALFORMAT converts to logical format
            %
            % BOOL = TOLOGICALFORMAT(VALUE) converts the input VALUE 
            %   to the logical boolean data type.
            %
            % See also BNC, logical.
            
            if islogical(value) || isnumeric(value)
                bool = logical(value);
            else
                bool = logical(str2num(char(value)));
            end
        end
        function bool = isNumericFormat(value)
            % ISNUMERICFORMAT checks if format is numeric
            %
            % BOOL = ISNUMERICFORMAT(VALUE) returns true if the string VALUE
            %   is BNC.NUMERIC and false otherwise.
            %
            % See also BNC, str2num.
            
            bool = strcmpi(value,BNC.NUMERIC);
        end
        function x = toNumericFormat(value)
            % TONUMERICFORMAT converts to numeric format
            %
            % X = TONUMERICFORMAT(VALUE) converts the input VALUE 
            %   to the numeric variable X.
            %
            % See also BNC, str2num.
            
            if isnumeric(value)
                x = value;
            else
                x = str2num(value);
            end
        end
        function bool = isOptionFormat(value)
            % ISOPTIONFORMAT checks if format is option
            %
            % BOOL = ISOPTIONFORMAT(VALUE) returns true if the string VALUE
            %   is BNC.OPTIONS and false otherwise.
            %
            % See also BNC.
            
            bool = strcmpi(value,BNC.OPTIONS);
        end
        function x = toOptionFormat(value,options)
            % TOOPTIONFORMAT converts to option format
            %
            % X = TOOPTIONFORMAT(VALUE,OPTIONS) returns the element
            %   of OPTIONS that is equal to VALUE, if it exists. Otherwise,
            %   it returns the first element of options.
            %
            % See also BNC.
            
            x = options{1};
            for i = 1:1:length(options)
                if strcmp(char(value),options{i})
                    x = options{i};
                end
            end
        end
       function success = fileExists(file)
            % FILEEXISTS checks if file exists
            %
            % SUCCESS = FILEEXISTS(FILE) returns true if the file specified
            %   by FILE exists and a file-not-found message box otherwise.
            %
            % See also BNC, exist, msgbox.
            
            success = exist(file,'file');
            if ~success
                msgbox(['The file ' file ' does not exist'], ...
                    'Error: File not found', ...
                    'error', ...
                    'modal');
            end
        end
        function success = dirExists(path)
            % DIREXISTS checks if directory exists
            %
            % SUCCESS = DIREXISTS(PATH) returns true if the directory specified
            %   by PATH exists and a directory-not-found message box otherwise.
            %
            % See also BNC, exist, msgbox.
            
            success = exist(path,'dir');
            if ~success
                msgbox(['The directory ' path ' does not exist'], ...
                    'Error: Directory not found', ...
                    'error', ...
                    'modal');
            end
        end
        function file = fullfile(path,file)
            % FULLFILE builds a file name
            %
            % FILE = FULLFILE(PATH,FILE) builds a full file name from the
            %   directory specified by PATH and file name specified by FILE. 
            %   If both PATH and FILE are empty, it returns the empty string.
            %
            % See also BNC, fullfile.
            
            if ~isempty(path) || ~isempty(file)
                file = fullfile(path,file);
            else
                file = '';
            end
        end        
    end
end