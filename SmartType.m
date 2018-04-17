classdef SmartType < handle
    %SMARTTYPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data1 = zeros(8,1,'single');
        data2 =uint32([6;0]);
    end
    
    methods
        function obj = SmartType()
            %SMARTTYPE Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        function outputArg = joint(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            % set mode
            if nargin == 2
                s = size(inputArg);
                if s(1) == 8 && s(2) == (1)
                obj.data1 = inputArg;
                
                else
                   error("expect a input of shape 8 X 1, however, get %d x %d", s); 
                end
                
            outputArg = obj;
            % get mode
            else
                outputArg = obj.data1;
            end
            
        end
        function outputArg = pose(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            % set mode
            if nargin == 2
                s = size(inputArg);
                obj.data1 = inputArg;
                
            % get mode
            else
                outputArg = obj.data(1:10);
            end
            
        end
        function outputArg = pulse(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            % set mode
            if nargin == 2
                s = size(inputArg);
                if s(1) == 8 && s(2) == (1)
                obj.data(1:8) = inputArg
                
                else
                   disp("expect a input of shape 8 X 1"); 
                   return;
                end
                
            % get mode
            else
                outputArg = obj.data(1:8);
            end
            
        end
    end
end

