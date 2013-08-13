require 'thor'
require 'awesome_print'
require 'bwcli/configuration'

module BWCLI
  class Me < Thor

    no_tasks do
      def configuration
        @configuration ||= BWCLI::Configuration.new
      end
    end

    desc "me", "Users credentials"
    method_option :p, :banner => 'parameter', :required => false
    def me
      return ap configuration.oauth.me[options[:p]] unless options[:p].nil?
      ap configuration.oauth.me
    end
    default_task :me

  end
end