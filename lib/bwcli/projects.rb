require 'bwcli/configuration'

module BWCLI

  # Projects subcommand
  class Projects < Thor

    no_tasks do
      def configuration
        @configuration ||= BWCLI::Configuration.new
      end
      alias :conf :configuration
    end

    desc "projects", "Users projects"
    method_option :i, :banner => 'project id', :required => false, :type => :numeric
    def projects
      if options[:i].nil?
        ap conf.oauth.projects
      else
        ap conf.oauth.project options[:i]
      end
    end
    default_task :projects

  end
end