require 'bwcli/configuration'

module BWCLI

  # Config subcommand
  class Config < Thor

    no_tasks do
      def configuration
        @configuration ||= BWCLI::Configuration.new
      end
      alias :conf :configuration
    end

    desc "user", "Returns the current user"
    def user
      conf.list_current_user
    end

    desc "login", "Authenticate current user"
    def login
      conf.oauth
    end

    desc "list", "List users"
    def list
      conf.list_users
    end

    desc "add", "Add a new user"
    method_option :e, :banner => 'Environment', :required => true
    method_option :u, :banner => 'Username', :required => true
    method_option :p, :banner => 'Password', :required => true
    def add
      conf.add_user options[:e], options[:u], options[:p]

      # Set as current user if no current user exists
      return conf.set_current_user options[:e], options[:u] unless conf.current_user_exists?

      # If current user exists check to switch
      conf.set_current_user options[:e], options[:u] if yes? "Would you like set this user as the current user?"
    end

    desc "switch", "Switch to user"
    method_option :u, :banner => 'Username', :required => true
    method_option :e, :banner => 'Environment', :required => true
    def switch
      conf.set_current_user options[:e], options[:u]
    end

    desc "remove", "Remove a new user"
    method_option :u, :banner => 'Username', :required => true
    method_option :e, :banner => 'Environment', :required => true
    def remove
      conf.remove_user options[:u], options[:e]
    end

    desc "reset", "Reset the conf file"
    def reset
      conf.reset if yes? "Are you sure you want to reset your config?"
    end

    include Thor::Actions

  end
end