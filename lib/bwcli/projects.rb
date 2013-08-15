require 'bwcli/configuration'

module BWCLI

  # Projects subcommand
  class Projects < Thor

    no_tasks do
      def configuration
        @configuration ||= BWCLI::Configuration.new
      end
    end

    desc "projects", "Users projects"
    method_option :i, :banner => 'project id', :required => false, :type => :numeric
    def projects
      if options[:i].nil?
        ap configuration.oauth.projects
      else
        configuration.oauth.project options[:i]
      end
    end
    default_task :projects

  end
end