import_types_from 'base'

module Rock
    module Devices
        module Sensors
            device_type 'InertialMeasurementUnit' do
                output_port 'calibrated_sensors', '/base/samples/IMUSensors'
            end
        end
    end
end
