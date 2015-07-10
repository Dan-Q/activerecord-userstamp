# The +ControllerAdditions+ module, when included into a controller, adds an +before_action+
# callback (named +set_stamper+) and an +after_action+ callback (named +reset_stamper+). These
# methods assume a couple of things, but can be re-implemented in your controller to better suit
# your application.
#
# See the documentation for `set_stamper` and `reset_stamper` for specific implementation details.
module ActiveRecord::Userstamp::ControllerAdditions
  extend ActiveSupport::Concern

  included do
    before_filter :set_stamper
    after_filter :reset_stamper
  end

  private

  # The +set_stamper+ method as implemented here assumes a couple of things. First, that you are
  # using a +User+ model as the stamper and second that your controller has a +current_user+
  # method that contains the currently logged in stamper. If either of these are not the case in
  # your application you will want to manually add your own implementation of this method to the
  # private section of your +ApplicationController+
  def set_stamper
    ActiveRecord::Userstamp.config.default_stamper_class.stamper = current_user
  end

  # The +reset_stamper+ method as implemented here assumes that a +User+ model is being used as
  # the stamper. If this is not the case then you will need to manually add your own
  # implementation of this method to the private section of your +ApplicationController+
  def reset_stamper
    ActiveRecord::Userstamp.config.default_stamper_class.reset_stamper
  end
end

if defined?(ActionController)
  ActionController::Base.class_eval do
    include ActiveRecord::Userstamp::ControllerAdditions
  end
end