Syskit.warn "Some of the services from the Base:: module that were defined in models/blueprints/sensors are now defined under models/services/, and have been renamed to match the new Syskit naming conventions"

module Base
    backward_compatible_constant :CompensatedIMUSensorsSrv, "Rock::Services::IMUCompensatedSensors" , 'rock/models/services/imu_compensated_sensors'
    backward_compatible_constant :CalibratedIMUSensorsSrv, "Rock::Services::IMUCalibratedSensors" , 'rock/models/services/imu_calibrated_sensors'
    backward_compatible_constant :ImageProviderSrv, "Rock::Services::Image" , 'rock/models/services/image'
    backward_compatible_constant :LaserRangeFinderSrv, "Rock::Services::LaserScan" , 'rock/models/services/laser_scan'
    backward_compatible_constant :SonarScanProviderSrv, "Rock::Services::SonarBeam" , 'rock/models/services/sonar_beam'
end

