require 'rock/models/services/joints_control_loop'
require 'rock/models/devices/bus/can'

module Rock
    module Devices
        module Actuators
            device_type 'Thrusters' do
                provides Rock::Services::JointsOpenLoopControlledSystem
                provides Rock::Devices::Bus::CAN::ClientInSrv
                provides Rock::Devices::Bus::CAN::ClientOutSrv
            end
        end
    end
end
