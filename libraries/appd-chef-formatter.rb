class Chef
  module Formatters
    class Appd < Formatters::Base

      cli_name(:appd)

      def resource_action_start(resource, action, notification_type = nil, notifier = nil)
        if resource.cookbook_name && resource.recipe_name
          resource_recipe = "#{resource.cookbook_name.downcase} #{resource.recipe_name.downcase if resource.recipe_name.downcase != "default"}:"
        else
          resource_recipe = "<Dynamically Defined Resource>"
        end

        if resource_recipe != @current_recipe
          puts "Configuring #{resource_recipe}"
          @current_recipe = resource_recipe
        end

        print "* #{action} '#{resource.name}' #{resource.resource_name if resource.resource_name != :execute}..." if action != :nothing
      end

      def resource_up_to_date(resource, action)
        puts "\b\b\b\b (nothing to do)"
      end

      def resource_updated(resource, action)
        puts "\b\b\b\b (done)"
      end
    end
  end
end