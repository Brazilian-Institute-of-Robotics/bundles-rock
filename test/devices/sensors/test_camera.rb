require 'models/devices/sensors/camera'

module Rock
    module Devices
        module Sensors
            describe Camera do
                # # What one usually wants to test for a Device would be the
                # # extensions module.
                # it "allows to specify the baudrate" do
                #     dev = syskit_stub_device(Camera)
                #     dev.baudrate(1_000_000) # 1Mbit
                #     assert_equal 1_000_000, dev.baudrate
                # end
            end
        end
    end
end
