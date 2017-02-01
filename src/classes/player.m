classdef player < handle
    properties(Dependent)
        name
        familyName
        country
        town
    end
    properties(Access=private)
        name_
        familyName_
        country_
        town_
    end
    
    methods
        
        % Basic information
        function C = basicInfo(name, familyName, country, town)
            if nargin > 0
                C.name_ = name;
                C.familyName_ = familyName;
                C.country_ = country;
                C.town_ = town;
            end            
        end
        
        function C = set.name(C, name)
            C.name_ = name;
        end 
        
        function name = get.name(C)
            name = C.name_;
        end
        
        function C = set.familyName(C, familyName)
            C.familyName_ = familyName;
        end 
        
        function familyName = get.familyName(C)
            familyName = C.familyName_;
        end        

        function C = set.country(C, country)
            C.country_ = country;
        end 
        
        function country = get.country(C)
            country = C.country_;
        end            

        function C = set.town(C, town)
            C.country_ = town;
        end 
        
        function town = get.town(C)
            town = C.town_;
        end               
        
    end
      
      
end