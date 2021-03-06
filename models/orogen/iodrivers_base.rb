require 'rock/models/devices/bus/raw_io'
require 'rock/models/services/raw_io'
class OroGen::IodriversBase::Task
    provides Rock::Devices::Bus::RawIO::ClientSrv, as: 'raw_io_bus',
        'to_bus' => 'io_raw_out',
        'from_bus' => 'io_raw_in'

    provides Rock::Services::RawIO, as: 'raw_io',
        'raw_out' => 'io_raw_out',
        'raw_in' => 'io_raw_in'
end

