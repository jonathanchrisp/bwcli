require 'bwcli/configuration'

module BWCLI

  # Me subcommand
  class Me < Thor

    no_tasks do
      def configuration
        @configuration ||= BWCLI::Configuration.new
      end
      alias :conf :configuration
    end

    desc "me", "Users credentials"
    def me
      ap conf.oauth.me
    end
    default_task :me

  end
end