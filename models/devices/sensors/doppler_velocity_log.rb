import_types_from 'base'

module Rock
    module Devices
        module Sensors
            device_type 'DopplerVelocityLog' do
                output_port 'ground_distance', '/base/samples/RigidBodyState'
                output_port 'velocity_samples', '/base/samples/RigidBodyState'
            end
        end
    end
end
