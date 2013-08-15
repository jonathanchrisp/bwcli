require 'yaml'
require "openssl"
require "digest"

module BWCLI

  # Configuration class to maintain config
  class Configuration

    # Initialises the configuration class
    def initialize
      @config_file = File.join(File.expand_path("~"), ".bwcli")
      @config = Hashie::Mash.new(YAML.load_file @config_file)
    rescue Errno::ENOENT
      File.new(@config_file, "w")
      puts "\nAs you didn't have a .bwcli file, I created one for you!\n".green
      retry
    end

    # Add user to the config hash
    #
    # @param [String] env the environment
    # @param [String] username the username of the user
    # @param [String] pwd the password of the user
    def add_user env, username, pwd
      config[env] = {} unless env_exists? env
      abort "The #{username} already exists!".yellow if user_exists? env, username
      config[env][username] = { 'access_token' => '', 'password' => encrypt_password(username, pwd) }
      write_config
    end

    # Returns the api endpoint for the current user
    #
    # @return [String] the api endpoint
    def api_endpoint
      case current_user.environment
      when 'int', 'integration'
        'http://newapi.int.brandwatch.com'
      when 'rel', 'release', 'stage'
        'http://newapi.rel.brandwatch.com'
      else
        'http://newapi.brandwatch.com'
      end
    end

    # Creates and returns bwapi instance
    #
    # @return [Object] bwapi the bwapi instance
    def bwapi
      abort "You have no current user set!".yellow unless current_user_exists?
      abort "There is no access token set for the current user".yellow if config.current_user.access_token.nil?
      abort "There is no environment set for the current user".yellow if config.current_user.environment.nil?

      return @bwapi ||= BWAPI::Client.new(:username => current_user.username, :password => decrypt_password(current_user.username, current_user.password), :api_endpoint => api_endpoint)
    end

    # Returns the config
    #
    # @return [Hash] config the current config
    def config
      @config
    end

    # Returns the current user set in config hash
    #
    # @return [Hash] returns the current user
    def current_user
      abort "You have no current user set!".yellow unless current_user_exists?
      config.current_user
    end

    # Check whether the current user exists in the config hash
    #
    # @return [Boolean]
    def current_user_exists?
      return false if config.current_user.nil?
      return true
    end

    # Check whether a env exists in the config hash
    #
    # @param [String] env the environment
    # @return [Boolean]
    def env_exists? env
      return false if config.nil?
      config.has_key? env
    end

    # List all users within the config hash
    def list_users
      abort "You have no users within your config file!".yellow if config.empty?
      puts "\nUser Configuration"
      config.each do |k, v|
        next if k == 'current_user'
        puts "\nEnvironment: #{k}"
        print_hash_values v
      end

      list_current_user if current_user_exists?
    end

    # List the current user within the config hash
    def list_current_user
      abort "You have no current user set!".yellow unless current_user_exists?
      puts "\nCurrent User"
      config.current_user.each do |k,v|
        if k == 'password'
          puts "#{k.yellow}: ** HIDDEN **".yellow
        else
          puts "#{k.yellow}: #{v}".yellow unless v.nil?
        end
      end
    end

    # Authenticates current user
    def oauth
      if current_user.access_token.nil? || current_user.access_token.empty?
        abort "Unable to login as #{current_user.username}".red unless bwapi.login
        set_access_token bwapi.access_token
      else
        bwapi.access_token = current_user.access_token
        abort "Unable to login as #{current_user.username}".red unless bwapi.login
      end

      return bwapi
    end

    # Resets the config to an empty hash
    def reset
      @config = {}
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
      config[current_user.environment].access_token = token
      write_config
    end

    # Remove user
    #
    # @param [String] username the username of the user
    # @param [String] env the environment
    def remove_user username, env
      abort "You have no users within your config file!".yellow if config.empty?
      abort "This user is currently set as the current user! Aborting!".yellow if current_user.username == username && current_user.env == env
      abort "The #{username} doesn't exist!".yellow unless user_exists? env, username
      config[env].delete username
      write_config
    end

    # Check whether a user exists in the config hash
    #
    # @param [String] env the environment
    # @param [String] username the username of the user
    # @return [Boolean]
    def user_exists? env, username
      return false  if config.nil? || config.empty?
      return true   if config[env].has_key? username
    end

    # Writes the config to file
    def write_config
      File.open(@config_file, "w"){|f| YAML.dump(config, f)}
    end

    private

    def encrypt_password key, pwd
      key = Digest::SHA256.digest(key) if(key.kind_of?(String) && 32 != key.bytesize)
      aes = OpenSSL::Cipher.new('AES-256-CBC')
      aes.encrypt
      aes.key = key
      return aes.update(pwd) + aes.final
    end

    def decrypt_password key, pwd
      key = Digest::SHA256.digest(key) if(key.kind_of?(String) && 32 != key.bytesize)
      aes = OpenSSL::Cipher.new('AES-256-CBC')
      aes.decrypt
      aes.key = key
      return aes.update(pwd) + aes.final
    end

    # Print out hash values
    def print_hash_values hash
      puts hash unless hash.is_a? Hash
      hash.each do |k, v|
        if v.is_a? Hash
          puts "User:".yellow + " #{k}"
          print_hash_values v
        else
          if k == 'password'
            puts "#{k.yellow}: ** HIDDEN **"
          else
            puts "#{k.yellow}: #{v}\n" unless v.nil?
          end
        end
      end
    end

  end
end