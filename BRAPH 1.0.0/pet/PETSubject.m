classdef PETSubject < ListElement
    % PETSubject < ListElement : PET subject
    %   PETSubject represents a subject with PET data.
    %
    % PETSubject properties (Constants):
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
    % PETSubject properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % PETSubject methods:
    %   PETSubject          -   constructor
    %   setProp             -   sets property value < ListElement
    %   getProp             -   gets property value, format and tag < ListElement
    %   getPropValue        -   string of property value < ListElement 
    %   getPropFormat       -   string of property format < ListElement
    %   getPropTag          -   string of property tag < ListElement
    %   toXML               -   creates XML Node from ListElement < ListElement
    %   fromXML             -   loads ListElement from XML Node < ListElement
    %   clear               -   clears list element < ListElement
    %   disp                -   displays PET subject
    %   copy                -   deep copy < matlab.mixin.Copyable
    %
    % PETSubject methods (Static):
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
        
        % {PETSubject.GENDER_NA PETSubject.GENDER_MALE PETSubject.GENDER_FEMALE} gender
        GENDER = 3
        GENDER_TAG = 'gender'
        GENDER_FORMAT = BNC.OPTIONS
        GENDER_NA = 'not assigned'
        GENDER_MALE = 'male'
        GENDER_FEMALE = 'female'
        GENDER_OPTIONS = {PETSubject.GENDER_NA PETSubject.GENDER_MALE PETSubject.GENDER_FEMALE}
        GENDER_DEFAULT = PETSubject.GENDER_NA
        
        % data (row vector corresponding to brain regions in brain atlas)
        DATA = 4
        DATA_TAG = 'data'
        DATA_FORMAT = BNC.NUMERIC
        DATA_DEFAULT = ones(1,1)

        % notes
        NOTES = 5
        NOTES_TAG = 'notes'
        NOTES_FORMAT = BNC.CHAR
        NOTES_DEFAULT = '---'

    end
    methods
        function sub = PETSubject(varargin)
            % PETSUBJECT() creates a PET subject with default properties
            %
            % PETSubject(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     PETSubject.CODE      -   char
            %     PETSubject.AGE       -   numeric
            %     PETSubject.GENDER    -   options (PETSubject.GENDER_MALE,PETSubject.GENDER_FEMALE)
            %     PETSubject.DATA      -   numeric
            %     PETSubject.NOTES     -   char
            %
            % See also PETSubject, ListElement.
            
            sub = sub@ListElement(varargin{:});
        end
        function disp(sub)
            % DISP displays PET subject
            %
            % DISP(SUB) displays the PET subject SUB and its properties
            %   on the command line.
            %
            % See also PETSubject, PETCohort.

            sub.disp@ListElement()
        end        
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of PETSubject.
            %
            % See also PETSubject.

            N = 5;
        end        
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of PETSubject.
            %
            % See also PETSubject, ListElement.
            
            tags = {PETSubject.CODE_TAG ...
                PETSubject.AGE_TAG ...
                PETSubject.GENDER_TAG ...
                PETSubject.DATA_TAG ...
                PETSubject.NOTES_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of PETSubject.
            %
            % See also PETSubject, ListElement.
            
            formats = {PETSubject.CODE_FORMAT ...
                PETSubject.AGE_FORMAT ...
                PETSubject.GENDER_FORMAT ...
                PETSubject.DATA_FORMAT ...
                PETSubject.NOTES_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of PETSubject.
            %
            % See also PETSubject, ListElement.
            
            defaults = {PETSubject.CODE_DEFAULT ...
                PETSubject.AGE_DEFAULT ...
                PETSubject.GENDER_DEFAULT ...
                PETSubject.DATA_DEFAULT ...
                PETSubject.NOTES_DEFAULT};
        end
        function options = getOptions(prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of PETSubject.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also PETSubject, ListElement.
            
            Check.isinteger('The index prop must be a positive integer',prop,'>',0)
            
            switch prop
                case PETSubject.GENDER
                    options = PETSubject.GENDER_OPTIONS;
                otherwise
                    options = {};
            end
        end
    end
end