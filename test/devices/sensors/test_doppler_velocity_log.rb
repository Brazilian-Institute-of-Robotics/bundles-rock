require 'models/devices/sensors/doppler_velocity_log'

module Rock
    module Devices
        module Sensors
            describe DopplerVelocityLog do
                # # What one usually wants to test for a Device would be the
                # # extensions module.
                # it "allows to specify the baudrate" do
                #     dev = syskit_stub_device(DopplerVelocityLog)
                #     dev.baudrate(1_000_000) # 1Mbit
                #     assert_equal 1_000_000, dev.baudrate
                # end
            end
        end
    end
end
