require 'models/devices/sensors/inertial_measurement_unit'

module Rock
    module Devices
        module Sensors
            describe InertialMeasurementUnit do
                # # What one usually wants to test for a Device would be the
                # # extensions module.
                # it "allows to specify the baudrate" do
                #     dev = syskit_stub_device(InertialMeasurementUnit)
                #     dev.baudrate(1_000_000) # 1Mbit
                #     assert_equal 1_000_000, dev.baudrate
                # end
            end
        end
    end
end
