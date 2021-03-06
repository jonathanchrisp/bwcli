require 'thor'
require 'hashie'
require 'awesome_print'
require 'bwapi'
require 'bwcli/configuration'
require 'bwcli/config'
require 'bwcli/me'
require 'bwcli/projects'

module BWCLI

  # BWCLI command
  class BW < Thor

    no_tasks do
      def configuration
        @configuration ||= BWCLI::Configuration.new
      end
    end

    desc "config", "User configuration"
    subcommand "config", Config

    desc "me", "Me endpoint"
    subcommand "me", Me

    desc "projects", "Project endpoints"
    subcommand "projects", Projects

    include Thor::Actions

  end
end