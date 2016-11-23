require 'models/services/motion2d_control_loop'
require 'models/services/joints_control_loop'
require 'models/blueprints/control'

class OroGen::Skid4Control::SimpleController
    provides Rock::Services::JointsOpenLoopController, :as => 'controller'
    provides Rock::Services::Motion2DOpenLoopControlledSystem, :as => 'controlled_system'
end

#using_task_library 'controldev'
#class OroGen::Skid4Control::FourWheelController
#    provides Base::ActuatorControllerSrv, :as => 'controller'
#    provides Base::FourWheelControlledSystemSrv, :as => 'controlled_system'
#end
#
#class OroGen::Skid4Control::ConstantSpeedController
#    provides Base::ActuatorControllerSrv, :as => 'controller'
#    provides Base::Motion2DControlledSystemSrv, :as => 'controlled_system'
#end
