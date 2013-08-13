require 'bwapi'
require 'hashie'
require 'yaml'
require 'awesome_print'

module BWCLI
  class Configuration

    # Initialises the configuration class
    def initialize
      @config = Hashie::Mash.new(YAML.load_file File.join(File.expand_path("~"), ".bwcli"))
    rescue Errno::ENOENT
      abort "You dont have a .bwcli file!".red.underline
    end

    # Returns the config
    #
    # @return [Hash] config the current config
    def config
      @config
    end

    # Writes the config to file
    def write_config
      File.open(File.join(File.expand_path("~"), '.bwcli'), "w"){|f| YAML.dump(config, f)}
    end

    # Resets the config to an empty hash
    def reset
      @config = {}
      write_config
    end

    def oauth
      bw = BWAPI::Client.new :username => current_user.username, :password => current_user.password

      if current_user.access_token.nil? || current_user.access_token.empty?
        abort "Unable to login as #{current_user.username}".red unless bw.login
        set_access_token bw.access_token
      else
        bw.access_token = current_user.access_token
        abort "Unable to login as #{current_user.username}".red unless bw.login
      end

      return bw
    end

    # Returns the current user set in config hash
    #
    # @return [Hash] returns the current user
    def current_user
      abort "You have no current user set!".yellow unless current_user_exists?
      config.current_user
    end

    # Display the current users access_token
    def current_user_access_token
      abort "You have no current user set!".yellow unless current_user_exists?
      abort "There is no access token set for the current user".yellow if config.current_user.access_token.nil?
      puts "access_token: #{config.current_user.access_token}".yellow
    end

    # Add user to the config hash
    #
    # @param [String] env the environment
    # @param [String] username the username of the user
    # @param [String] pwd the password of the user
    def add_user env, username, pwd
      config[env] = {} unless env_exists? env
      abort "The #{username} already exists!".yellow if user_exists? env, username
      config[env][username] = { 'access_token' => '', 'password' => pwd }
      write_config
    end

    # Set current user
    #
    # @param [String] env the environment
    # @param [String] username the username of the user
    def set_current_user env, username
      abort "The #{username} doesn't exist! Please add!".yellow unless user_exists? env, username
      config.current_user = { 'username' => username, 'environment' => env, 'password' => config[env][username].password, 'access_token' => config[env][username].access_token }
      write_config
    end

    # Sets access token for current user
    #
    # @param [String] token the access token to store in  config hash
    def set_access_token token
      current_user.access_token = token
      write_config
    end

    # List all users within the config hash
    def list_users
      abort "You have no users within your config file!".yellow if config.empty?
      puts "\nUser Configuration".yellow
      config.each do |k, v|
        next if k == 'current_user'
        puts "\nEnvironment: #{k}".yellow
        print_hash_values v
      end

      list_current_user if current_user_exists?
    end

    # List the current user within the config hash
    def list_current_user
      abort "You have no current user set!".yellow unless current_user_exists?
      puts "\nCurrent User:".yellow
      config.current_user.each do |k,v|
        puts "#{k.yellow}: #{v}\n" unless v.nil?
      end
    end

    # Print out hash values
    def print_hash_values hash
      puts hash.yellow unless hash.is_a? Hash
      hash.each do |k, v|
        if v.is_a? Hash
          puts "User: #{k}:".yellow
          print_hash_values v
        else
          puts " - #{k}: #{v}"
        end
      end
    end

    # Remove user
    #
    # @param [String] env the environment
    # @param [String] username the username of the user
    def remove_user env, username
      abort "You have no users within your config file!".yellow if config.empty?
      abort "This user is currently set as the current user! Aborting!".yellow if current_user.username == username && current_user.env == env
      abort "The #{username} doesn't exist!".yellow unless user_exists? env, username
      config[env].delete username
      write_config
    end

    # Check whether the current user exists in the config hash
    #
    # @return [Boolean]
    def current_user_exists?
      return false if config.current_user.nil?
      return true
    end

    # Check whether a user exists in the config hash
    #
    # @param [String] env the environment
    # @param [String] username the username of the user
    # @return [Boolean]
    def user_exists? env, username
      return false  if config.nil?
      return true   if config[env].has_key? username
    end

    # Check whether a env exists in the config hash
    #
    # @param [String] env the environment
    # @return [Boolean]
    def env_exists? env
      return false if config.nil?
      config.has_key? env
    end

  end
end