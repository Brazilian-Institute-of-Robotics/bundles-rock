require 'rock/models/devices/gazebo/entity'
require 'rock/models/services/joints_control_loop'
require 'rock/models/services/pose'
require 'rock/models/services/velocity'

module Rock
    module Devices
        module Gazebo
            device_type 'Model' do
                provides Entity

                provides Rock::Services::Pose
                provides Rock::Services::Velocity,
                    'velocity_samples' => 'pose_samples'

                # Rename status_out and command_in to something that talks about
                # joints
                input_port 'joints_cmd', '/base/samples/Joints'
                output_port 'joints_status', '/base/samples/Joints'
                provides Rock::Services::JointsControlledSystem,
                    'command_in' => 'joints_cmd',
                    'status_out' => 'joints_status'
            end
        end
    end
end
