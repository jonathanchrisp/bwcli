require 'thor'
require 'awesome_print'
require 'bwcli/configuration'

module BWCLI
  class Projects < Thor

    no_tasks do
      def configuration
        @configuration ||= BWCLI::Configuration.new
      end
    end

    desc "projects", "Users projects"
    method_option :i, :banner => 'project id', :required => false
    method_option :p, :banner => 'parameter', :required => false
    def projects
      if (options[:p].nil? && options[:i].nil?)
        ap configuration.oauth.projects
      elsif options[:p].nil?
        ap configuration.oauth.project options[:i]
      else
        project = configuration.oauth.project options[:i]
        ap project[options[:p]]
      end
    end
    default_task :projects

  end
end