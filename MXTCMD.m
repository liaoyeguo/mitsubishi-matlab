classdef MXTCMD < handle
    %MXTCMD Summary of this class goes here
    %   Detailed explanation goes here
    properties(Constant)
        
        %% some constant
        %cmd 
        MXT_CMD_NULL = uint16(0);
        MXT_CMD_MOVE = uint16(1);
        MXT_CMD_END = uint16(255);
        
        % send and recieve type
        MXT_TYPE_NULL = uint16(0);
        MXT_TYPE_POSE = uint16(1);
        MXT_TYPE_JOINT = uint16(2);
        MXT_TYPE_PULSE = uint16(3);
        MXT_TYPE_FPOSE = uint16(4);
        MXT_TYPE_FJOINT = uint16(5);
        MXT_TYPE_FPULSE = uint16(6);
        MXT_TYPE_FB_POSE = uint16(7);
        MXT_TYPE_FB_JOINT = uint16(8);
        MXT_TYPE_FB_PULSE = uint16(9);
        MXT_TYPE_CMDCUR = uint16(10);
        MXT_TYPE_FBKCUR = uint16(11);
        
        MXT_IO_NULL = uint16(0);
        MXT_IO_OUT = uint16(1);
        MXT_IO_IN = uint16(2);
    end
    properties
        %% data sended to controller
        command = MXTCMD.MXT_CMD_NULL;
        sendType = MXTCMD.MXT_TYPE_NULL;
        recvType1 = MXTCMD.MXT_TYPE_NULL;
        reserve = uint16(0);
        data1 = SmartType();
        sendIOType = MXTCMD.MXT_IO_NULL;
        recvIOType = MXTCMD.MXT_IO_NULL;
        bitTop = uint16(0);
        bitMask = uint16(0);
        IOData = uint16(0);
        tCount = uint16(0);
        cCount = uint32(0);
        recvType2 = MXTCMD.MXT_TYPE_NULL;
        data2 = SmartType();
        recvType3 = MXTCMD.MXT_TYPE_NULL; 
        data3 = SmartType();
        recvType4 = MXTCMD.MXT_TYPE_NULL;
        data4 = SmartType();
        
    end
    
    methods
        function obj = MXTCMD()
            %MXTCMD Construct an instance of this class
            %   Detailed explanation goes here
            obj.data1 = SmartType();
        end
        
        function outputArg = toMsg(obj)
            % generate 196 byte msg to send to controller in 'uint8'
            % format.
            outputArg = typecast([obj.command; obj.sendType; obj.recvType1; obj.reserve;
                         typecast(obj.data1.data1, 'uint16'); typecast(obj.data1.data2, 'uint16');obj.sendIOType; obj.recvIOType; 
                         obj.bitTop; obj.bitMask; obj.IOData;
                         obj.tCount; typecast(obj.cCount, 'uint16').'; obj.recvType2; obj.reserve;
                         typecast(obj.data2.data1, 'uint16'); typecast(obj.data2.data2, 'uint16');obj.recvType3; obj.reserve; typecast(obj.data3.data1, 'uint16');
                         typecast(obj.data3.data2, 'uint16');obj.recvType4; obj.reserve; typecast(obj.data4.data1, 'uint16');typecast(obj.data4.data2, 'uint16')
            ], 'uint8');
        end
        
        function obj = loadMsg(obj, data)
            % data is asume to be a 196-d double vector get by fread(f, size, 'uint8')
            dataUint8 = cast(data, 'uint8');
            parsed = typecast(dataUint8, 'uint16');
            obj.command = parsed(1);
            obj.sendType = parsed(2);
            obj.recvType1 = parsed(3);
            dataTmp = parsed(5:20);
            obj.data1.data1 = typecast(dataTmp, 'single');
            dataTmp = parsed(21:24);
            obj.data1.data2 = typecast(dataTmp, 'uint32');
            obj.sendIOType = parsed(25);
            obj.recvIOType = parsed(26);     
            obj.IOData = parsed(27);
            obj.bitTop = parsed(28);
            obj.bitMask = parsed(29);
            obj.tCount = parsed(30);
            obj.cCount = parsed(31:32); 
            obj.recvType2 = parsed(33);
            dataTmp = parsed(35:50);
            obj.data2.data1 = typecast(dataTmp, 'single');
            dataTmp = parsed(51:54);
            obj.data2.data2 = typecast(dataTmp, 'uint32');
            obj.recvType3 = parsed(55);
            dataTmp = parsed(57:72);
            obj.data3.data1 = typecast(dataTmp, 'single');
            dataTmp = parsed(73:76);
            obj.data3.data2 = typecast(dataTmp, 'uint32');
            obj.recvType4 = parsed(77);
            dataTmp = parsed(79:98);
            obj.data4.data1 = typecast(dataTmp, 'single');
            dataTmp = parsed(95:98);
            obj.data4.data2 = typecast(dataTmp, 'uint32');

        end
    end
end

