classdef RobotClient < handle
    %ROBOTCLIENT 此处显示有关此类的摘要
    %   此处显示详细说明
    properties(Constant)
        RETRY = 30;
    end
    properties
        u;
        IPAddr = "192.168.0.20";
        portAddr = 10000;
        state;
    end
    
    methods
        function obj = RobotClient()
            %RobotClient Construct an instance of this class
            %   Detailed explanation goes here           
        end
        
        function obj = init(obj)
            obj.u = udp(obj.IPAddr, obj.portAddr);
        end
        
        function [obj, state] = connect(obj)
            % connect to controller and set obj.state with newest robot
            % state
            fopen(obj.u);
            cmd = MXTCMD();
            cmd.command = MXTCMD.MXT_CMD_NULL;
            cmd.recvType1 = MXTCMD.MXT_TYPE_JOINT;
            cmd.recvType2 = MXTCMD.MXT_TYPE_POSE;
            cmd.recvType3 = MXTCMD.MXT_TYPE_FJOINT;
            cmd.recvType4 = MXTCMD.MXT_TYPE_FPOSE;
            [recv, success] = obj.sendAndRecv(cmd);
            if success
                obj.state = [recv.data1.data1;recv.data1.data2;recv.data2.data1;recv.data2.data2;recv.data3.data1;recv.data3.data2;recv.data4.data1;
                    recv.data4.data2];
                state = obj.state;
            else 
                disp("can not connect to controller");
                obj.close();
                return;
            end            
        end
        
        function obj = close(obj)
           fclose(obj.u); 
        end
        
        function state = robotState(obj)
            cmd = MXTCMD();
            cmd.command = MXTCMD.MXT_CMD_NULL;
            cmd.recvType1 = MXTCMD.MXT_TYPE_JOINT;
            cmd.recvType2 = MXTCMD.MXT_TYPE_POSE;
            cmd.recvType3 = MXTCMD.MXT_TYPE_FJOINT;
            cmd.recvType4 = MXTCMD.MXT_TYPE_FPOSE;
            [recv, success] = obj.sendAndRecv(cmd);
            state = [];
            if success
                state = recv;
            else 
                disp("can not connect to controller");
                return;
            end
        end
        
        function q = jointState(obj)
            rbState = obj.robotState();
            q = rbState.data1.data1(1:6);
        end
        
        function pose = poseState(obj)
            rbState = obj.robotState();
            pose = [rbState.data2.data1(1:3)/1000;rbState.data2.data1(4:6)];
        end
        
        function q = moveJoint(obj, q)
             q0 = obj.jointState();
             delta = q - q0;
             maxELe = max(abs(delta));
             t =ceil(maxELe / 0.01);
             if t == 0
                traj = q';
             else
                traj = jtraj(q0, q, t);
             end
             
             state = obj.followTrajJoint(traj);
             q = [state.data1.data1(1:6)];
        
        end
        
        function finalPose = movePose(obj, pose)
             pose0 = obj.poseState();
             maxELe = max(abs(pose(1:3) - pose0(1:3)));
             t =ceil(maxELe / 0.002);
             T0 = transl([pose0(1:3)]) * eul2tform([pose0(6), pose0(5), pose0(4)]);
             TFinal = transl([pose(1:3)]) * eul2tform([pose(6), pose(5), pose(4)]);
             if t == 0
                traj = T0;
             else
                traj = ctraj(T0, TFinal, t);
             end
             
             state = obj.followTrajCartesian(traj);
             finalPose = state.data2.data1(1:6);
        end
        
        function [recv, success] = sendAndRecv(obj, cmd)
            sendText = cmd.toMsg();
            fwrite(obj.u, sendText, 'uint8');
            retry = RobotClient.RETRY;
            success = 0;
            recv = MXTCMD();
            while(retry)
                if obj.u.BytesAvailable == 196
                    recvtext = fread(obj.u, obj.u.BytesAvailable, 'uint8');
                    recv.loadMsg(recvtext);
                    success = 1;
                    break;
                else
                    retry = retry - 1;                
                end                
            end
            flushinput(obj.u);
        end
        
        
        
        function state = followTrajJoint(obj, traj)
            trajSize = size(traj);
            len = trajSize(1);
            cmd = MXTCMD();
            cmd.command = MXTCMD.MXT_CMD_MOVE;
            cmd.sendType = MXTCMD.MXT_TYPE_JOINT;
            cmd.recvType1 = MXTCMD.MXT_TYPE_JOINT;
            cmd.recvType2 = MXTCMD.MXT_TYPE_POSE;
            cmd.recvType3 = MXTCMD.MXT_TYPE_FJOINT;
            cmd.recvType4 = MXTCMD.MXT_TYPE_FPOSE;
            for i = 1:len
                cmd.data1.joint([traj(i,:) 0 0]');   
                [recv, success] = obj.sendAndRecv(cmd);
            end
            state = recv;
        end
        
        function state = followTrajCartesian(obj, traj)
            trajSize = size(traj);
            len = trajSize(3);
            cmd = MXTCMD();
            cmd.command = MXTCMD.MXT_CMD_MOVE;
            cmd.sendType = MXTCMD.MXT_TYPE_POSE;
            cmd.recvType1 = MXTCMD.MXT_TYPE_JOINT;
            cmd.recvType2 = MXTCMD.MXT_TYPE_POSE;
            cmd.recvType3 = MXTCMD.MXT_TYPE_FJOINT;
            cmd.recvType4 = MXTCMD.MXT_TYPE_FPOSE;
            for i = 1:len
                translation = tform2trvec(traj(:,:,i));
                ypr = tform2eul(traj(:,:,i));
                cmd.data1.pose([translation * 1000,ypr(3), ypr(2), ypr(1), 0, 0]');   
                [recv, success] = obj.sendAndRecv(cmd);
            end
            state = recv;
        end
    end
    
end

