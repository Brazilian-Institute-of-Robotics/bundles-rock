require 'rock/models/services/joints_control_loop'
require 'rock/models/services/transformation'
require 'rock/models/devices/gazebo'

class OroGen::RockGazebo::WorldTask
    # Customizes the configuration step.
    #
    # The orocos task is available from orocos_task
    #
    # The call to super here applies the configuration on the orocos task. If
    # you need to override properties, do it afterwards
    #
    # def configure
    #     super
    # end
end

# Handling of a gazebo model on the Rock side
#
# ModelTasks are {Rock::Services::JointsControlledSystem}, that is they report
# the state of their joints, and accept joint commands
#
# They also can export transformations between two arbitrary links. This is
# modelled on the syskit side by a dynamic service. One first instanciates the
# service with e.g.
#
# @example
#   model = OroGen::RockGazebo::ModelTask.specialize
#   model.require_dynamic_service 'link_export, as: 'new_service_name',
#       port_name: 'whatever_you_want_but_uses_the_service_name_by_default"
#
# This creates the relevant port (under 'port_name'), and declares an associated
# transformation between the 'new_service_name_source' frame and the
# 'new_service_name_target' frame. One therefore deploys the generated component
# with e.g.
#
# @example
#   model.use_frames(
#     'new_service_name_source' => 'world',
#     'new_service_name_target' => 'camera')
#
# Note that in most cases you won't have to access this interface directly, the
# rock_gazebo plugin does it for you through a high-level API on the profiles.
class OroGen::RockGazebo::ModelTask
    driver_for Rock::Devices::Gazebo::Model, as: 'model'

    # Declare a dynamic service for the link export feature
    #
    # One uses it by first require'ing
    dynamic_service Rock::Devices::Gazebo::Link, as: 'link_export' do
        name      = self.name
        port_name = options.fetch(:port_name, name)
        frame_basename = options.fetch(:frame_basename, name)
        nans = [Float::NAN] * 9
        options[:cov_position]    ||= Types.base.Matrix3d.new(data: nans.dup)
        options[:cov_orientation] ||= Types.base.Matrix3d.new(data: nans.dup)
        options[:cov_velocity]    ||= Types.base.Matrix3d.new(data: nans.dup)

        driver_for Rock::Devices::Gazebo::Link, "link_state_samples" => port_name
        component_model.transformer do
            transform_output port_name, "#{frame_basename}_source" => "#{frame_basename}_target"
        end
    end

    transformer do
        transform_output 'pose_samples', 'body' => 'world'
    end

    def configure
        super

        exports = Array.new

        # Setup the link export based on the instanciated link_export services
        # The source/target information is stored in the transformer
        each_required_dynamic_service do |srv|
            # Find the task port that on which the service port is mapped
            task_port = srv.link_state_samples_port.to_component_port
            # And get the relevant transformer information
            if transform = find_transform_of_port(task_port)
                if !transform.from || !transform.to
                    model_transform = self.class.find_transform_of_port(task_port)
                    raise ArgumentError, "you did not select the frames for #{model_transform.from} or #{model_transform.to}, needed for #{srv.name}"
                end
                device = find_device_attached_to(srv)
                exports << Types.rock_gazebo.LinkExport.new(
                    port_name: task_port.name,
                    source_link: transform.from,
                    target_link: transform.to,
                    source_frame: transform.from,
                    target_frame: transform.to,
                    port_period: Time.at(device.period || 0),
                    cov_position: srv.model.dynamic_service_options[:cov_position],
                    cov_orientation: srv.model.dynamic_service_options[:cov_orientation],
                    cov_velocity: srv.model.dynamic_service_options[:cov_velocity])
            else
                raise ArgumentError, "cannot find the transform information for #{task_port}"
            end
        end

        properties.use_sim_time = !!Conf.gazebo.use_sim_time?
        properties.exported_links = exports
    end

    stub do
        def configure(*)
            super
            model.each_output_port do |p|
                if !has_port?(p.name)
                    create_output_port p.name, p.type
                end
            end
        end
    end
end

class OroGen::RockGazebo::LaserScanTask
    driver_for Rock::Devices::Gazebo::Ray, as: 'sensor'

    transformer do
        frames 'sensor'
        associate_ports_to_frame 'laser_scan_samples', 'sensor'
    end

    def configure
        super
        properties.use_sim_time = !!Conf.gazebo.use_sim_time?
    end
end

class OroGen::RockGazebo::ImuTask
    driver_for Rock::Devices::Gazebo::Imu, as: 'sensor'

    transformer do
        frames 'sensor', 'inertial'
        associate_ports_to_transform 'orientation_samples', 'sensor' => 'inertial'
        associate_ports_to_frame 'imu_samples', 'sensor'
    end

    def configure
        super
        properties.use_sim_time = !!Conf.gazebo.use_sim_time?
    end
end

class OroGen::RockGazebo::CameraTask
    driver_for Rock::Devices::Gazebo::Camera, as: 'sensor'

    transformer do
        frames 'sensor'
        associate_ports_to_frame 'frame', 'sensor'
    end

    def configure
        super
        properties.use_sim_time = !!Conf.gazebo.use_sim_time?
    end
end

class OroGen::RockGazebo::GPSTask
    driver_for Rock::Devices::Gazebo::GPS, as: 'gps'

    transformer do
        frames 'gps', 'nwu', 'utm'
        associate_ports_to_transform 'position_samples', 'gps' => 'nwu'
        associate_ports_to_transform 'utm_samples', 'gps' => 'utm'
    end

    def configure
        super
        properties.use_sim_time = !!Conf.gazebo.use_sim_time?
        properties.latitude_origin  = Types.base.Angle.new(rad: Conf.sdf.world.spherical_coordinates.latitude_deg * Math::PI / 180)
        properties.longitude_origin = Types.base.Angle.new(rad: Conf.sdf.world.spherical_coordinates.longitude_deg * Math::PI / 180)
        properties.nwu_origin = Conf.sdf.global_origin
        properties.utm_zone   = Conf.sdf.utm_zone
        properties.utm_north  = Conf.sdf.utm_north?
    end
end

