classdef EEGSubject < ListElement
    % EEGSubject < ListElement : EEG subject
    %   EEGSubject represents a subject with EEG data.
    %
    % EEGSubject properties (Constants):
    %   CODE                -   code numeric code
    %   CODE_TAG            -   code tag
    %   CODE_FORMAT         -   code format
    %   CODE_DEFAULT        -   code default value
    % 
    %   AGE                 -   age numeric code
    %   AGE_TAG             -   age tag
    %   AGE_FORMAT          -   age format
    %   AGE_DEFAULT         -   age default value
    %                          
    %   GENDER              -   gender numeric code
    %   GENDER_TAG          -   gender tag
    %   GENDER_FORMAT       -   gender format
    %   GENDER_NA           -   gender "not assigned" option
    %   GENDER_MALE         -   gender "male" option
    %   GENDER_FEMALE       -   gender "female" option
    %   GENDER_OPTIONS      -   array of gender option
    %   GENDER_DEFAULT      -   gender default value
    %
    %   DATA                -   data numeric code
    %   DATA_TAG            -   data tag
    %   DATA_FORMAT         -   data format
    %   DATA_DEFAULT        -   data default value
    %
    %   NOTES               -   notes numeric code
    %   NOTES_TAG           -   notes tag
    %   NOTES_FORMAT        -   notes format
    %   NOTES_DEFAULT       -   notes default value
    %
    % EEGSubject properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % EEGSubject methods:
    %   EEGSubject         -   constructor
    %   setProp             -   sets property value < ListElement
    %   getProp             -   gets property value, format and tag < ListElement
    %   getPropValue        -   string of property value < ListElement 
    %   getPropFormat       -   string of property format < ListElement
    %   getPropTag          -   string of property tag < ListElement
    %   toXML               -   creates XML Node from ListElement < ListElement
    %   fromXML             -   loads ListElement from XML Node < ListElement
    %   clear               -   clears list element < ListElement
    %   disp                -   displays EEG subject
    %   copy                -   deep copy < matlab.mixin.Copyable
    %
    % EEGSubject methods (Static):
    %   cleanXML           -   removes whitespace nodes from xmlread < ListElement
    %   propnumber         -   number of properties
    %   getTags            -   cell array of strings with the tags of the properties
    %   getFormats         -   cell array with the formats of the properties
    %   getDefaults        -   cell array with the defaults of the properties
    %   getOptions         -   cell array with options (only for properties with options format)
    %
    % See also ListElement.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % few-letter code (unique for each subject)
        CODE = 1
        CODE_TAG = 'code'
        CODE_FORMAT = BNC.CHAR
        CODE_DEFAULT = 'subject code'

        % age
        AGE = 2
        AGE_TAG = 'age'
        AGE_FORMAT = BNC.NUMERIC
        AGE_DEFAULT = 1
        
        % {EEGSubject.GENDER_NA EEGSubject.GENDER_MALE EEGSubject.GENDER_FEMALE} gender
        GENDER = 3
        GENDER_TAG = 'gender'
        GENDER_FORMAT = BNC.OPTIONS
        GENDER_NA = 'not assigned'
        GENDER_MALE = 'male'
        GENDER_FEMALE = 'female'
        GENDER_OPTIONS = {EEGSubject.GENDER_NA EEGSubject.GENDER_MALE EEGSubject.GENDER_FEMALE}
        GENDER_DEFAULT = EEGSubject.GENDER_NA
        
        % data (matrix: time (rows) x brain regions (columns))
        DATA = 4
        DATA_TAG = 'data'
        DATA_FORMAT = BNC.NUMERIC
        DATA_DEFAULT = []

        % notes
        NOTES = 5
        NOTES_TAG = 'notes'
        NOTES_FORMAT = BNC.CHAR
        NOTES_DEFAULT = '---'

    end
    methods
        function sub = EEGSubject(varargin)
            % EEGSUBJECT() creates a EEG subject with default properties.
            %
            % EEGSUBJECT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     EEGSubject.CODE      -   char
            %     EEGSubject.AGE       -   numeric
            %     EEGSubject.GENDER    -   options (EEGSubject.GENDER_NA,EEGSubject.GENDER_MALE,EEGSubject.GENDER_FEMALE)
            %     EEGSubject.DATA      -   numeric
            %     EEGSubject.NOTES     -   char
            %
            % See also EEGSubject, ListElement.
            
            sub = sub@ListElement(varargin{:});
        end
        function disp(sub)
            % DISP displays EEG subject
            %
            % DISP(SUB) displays the EEG subject SUB and its properties
            %   on the command line.
            %
            % See also EEGSubject, EEGCohort.

            sub.disp@ListElement()
        end        
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of EEGSubject.
            %
            % See also EEGSubject.

            N = 5;
        end        
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGSubject.
            %
            % See also EEGSubject, ListElement.
            
            tags = {EEGSubject.CODE_TAG ...
                EEGSubject.AGE_TAG ...
                EEGSubject.GENDER_TAG ...
                EEGSubject.DATA_TAG ...
                EEGSubject.NOTES_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of EEGSubject.
            %
            % See also EEGSubject, ListElement.
            
            formats = {EEGSubject.CODE_FORMAT ...
                EEGSubject.AGE_FORMAT ...
                EEGSubject.GENDER_FORMAT ...
                EEGSubject.DATA_FORMAT ...
                EEGSubject.NOTES_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of EEGSubject.
            %
            % See also EEGSubject, ListElement.
            
            defaults = {EEGSubject.CODE_DEFAULT ...
                EEGSubject.AGE_DEFAULT ...
                EEGSubject.GENDER_DEFAULT ...
                EEGSubject.DATA_DEFAULT ...
                EEGSubject.NOTES_DEFAULT};
        end
        function options = getOptions(prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of EEGSubject.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also EEGSubject, ListElement.
            
            Check.isinteger('The index prop must be a positive integer',prop,'>',0)
            
            switch prop
                case EEGSubject.GENDER
                    options = EEGSubject.GENDER_OPTIONS;
                otherwise
                    options = {};
            end
        end
    end
end