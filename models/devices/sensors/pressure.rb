require 'rock/models/services/z_provider'

module Rock
    module Devices
        module Sensors
            device_type 'Pressure' do
                provides Rock::Services::ZProvider
            end
        end
    end
end
