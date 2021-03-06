class Chef
  module Formatters
    class Appd < Formatters::Base

      cli_name(:appd)

      def resource_action_start(resource, action, notification_type = nil, notifier = nil)
        if print_resource?(resource)
          
          resource_recipe = "#{resource.cookbook_name.downcase} #{resource.recipe_name.downcase.gsub(/_/, "").chomp if resource.recipe_name.downcase != "default"}:"
      
          if resource_recipe != @current_recipe
            puts "Configure #{resource_recipe}" if action != :nothing
            @current_recipe = resource_recipe
          end

          print "* #{action} '#{resource.name}' #{resource.resource_name if [:execute, :bash].include?(resource.resource_name) }..." if action != :nothing
        end
      end

      def resource_up_to_date(resource, action)
        puts "\b\b\b\b (nothing to do)" if print_resource?(resource)
      end

      def resource_updated(resource, action)
        puts "\b\b\b\b (done)" if print_resource?(resource)
      end

      def resource_skipped(resource, action, conditional)
        puts "\b\b\b\b (skipped)" if print_resource?(resource) && action != :nothing
      end

      private

      def print_resource?(resource)
        return (resource.cookbook_name && resource.recipe_name)
      end
    end
  end
end