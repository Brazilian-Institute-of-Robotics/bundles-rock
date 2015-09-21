require 'rock/models/services/image'

module Rock
    module Devices
        module Sensors
            device_type 'Camera' do
                provides Rock::Services::Image
            end
        end
    end
end
