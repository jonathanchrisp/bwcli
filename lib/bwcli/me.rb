require 'bwcli/configuration'

module BWCLI

  # Me subcommand
  class Me < Thor

    no_tasks do
      def configuration
        @configuration ||= BWCLI::Configuration.new
      end
    end

    desc "me", "Users credentials"
    def me
      ap configuration.oauth.me
    end
    default_task :me

  end
end