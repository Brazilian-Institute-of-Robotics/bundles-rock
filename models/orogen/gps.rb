require 'rock/models/devices/gps/mb500'
require 'rock/models/devices/gps/generic'

class OroGen::Gps::BaseTask
    def configure
        super

        if Conf.utm_local_origin?
            orocos_task.origin = Conf.utm_local_origin
        end
    end
end

class OroGen::Gps::MB500Task
    driver_for Rock::Devices::GPS::MB500, as: 'driver'
end

class OroGen::Gps::GPSDTask
    driver_for Rock::Devices::GPS::Generic, as: 'driver'
end
