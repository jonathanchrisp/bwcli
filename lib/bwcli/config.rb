require 'bwcli/configuration'

module BWCLI
  class Config < Thor

    no_tasks do
      def configuration
        @configuration ||= BWCLI::Configuration.new
      end
    end

    desc "user", "Returns the current user"
    def user
      configuration.list_current_user
    end

    desc "login", "Authenticate current user"
    def login
      configuration.oauth
    end

    desc "token", "Returns the current user token"
    def token
      configuration.current_user_access_token
    end

    desc "list", "List users"
    def list
      configuration.list_users
    end

    desc "add", "Add a new user"
    method_option :e, :banner => 'Environment', :required => true
    method_option :u, :banner => 'Username', :required => true
    method_option :p, :banner => 'Password', :required => true
    def add
      configuration.add_user options[:e], options[:u], options[:p]
      configuration.set_current_user options[:e], options[:u] if yes? "Would you like set this user as the current user?"
    end

    desc "switch", "Switch to user"
    method_option :u, :banner => 'Username', :required => true
    method_option :e, :banner => 'Environment', :required => true
    def switch
      configuration.set_current_user options[:e], options[:u]
    end

    desc "remove", "Remove a new user"
    method_option :e, :banner => 'Environment', :required => true
    method_option :u, :banner => 'Username', :required => true
    def remove
      configuration.remove_user options[:e], options[:u]
    end

    desc "reset", "Reset the configuration file"
    def reset
      configuration.reset if yes? "Are you sure you want to reset your config?"
    end

    include Thor::Actions

  end
end