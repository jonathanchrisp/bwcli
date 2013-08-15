[![Gem Version](https://badge.fury.io/rb/bwcli.png)](http://badge.fury.io/rb/bwcli) 
[![Dependency Status](https://gemnasium.com/jonathanchrisp/bwcli.png)](https://gemnasium.com/jonathanchrisp/bwcli)
[![Code Climate](https://codeclimate.com/github/jonathanchrisp/bwcli.png)](https://codeclimate.com/github/jonathanchrisp/bwcli)

# bwcli

__PLEASE NOTE THAT THIS PROJECT IS NOT OFFICIALLY SUPPORTED BY BRANDWATCH__

A command line interface to interact with the Brandwatch API


## Documentation 
http://rubydoc.info/gems/bwcli/

## Getting Started

In order to interact with the `BWAPI` from the command line we first need to setup a current user in the `.bwcli` config file. Please note that the config file enables us to hold multiple users which we can easily switch between.

### Add new user to config

In order to use `bwcli` you need to have a `.bwcli` file in your root directory, don't worry I've got your back. When you create a new user the file will be created automatically. So, to get the show on the road add a user to your config file:

```ruby
bwcli config add -u username@domain.com -p your_password -e enviroment
```

When you create a user for the first time `bwcli` will automatically set this user as your `current user`. When you add new users to your config, `bwcli` will ask whether you want to set this user as your current user.

### View user config

Returns the users currently stored in the config file along with the current user if set.

```ruby
bwcli config list
```

### Set current user

Sets the user as the current user. The `set` or `switch` command can be used.

```ruby
bwcli config set -u anotheruser@domain -e environment
```

### Remove user

Removes the specific user from the config file, no warning is given.

```ruby
bwcli config remove -u anotheruser@domain -e environment
```

### View current user

Returns the current user set in the config file.

```ruby
bwcli config user
```

### Authenticate current user

Please note that when ever you make a request to an endpoint `bwcli` will ensure you are authenticated with brandwatch so the login command doesn't need to run everytime.

```ruby
bwcli config login
```

### Reset user config

Wipe your config file and restart, warning is given and the user must respond with a `yes` or `y` to confirm.

```ruby
bwcli config reset
```

## Next Steps

Once you have your current user setup you can make API requests to Brandwatch. Currently at present only the `me` and `projects` endpoint are implemented.

### Me Endpoint

Returns user information.

```ruby
bwcli me
```

### All Projects

Returns all projects the user currently has shared.


```ruby
bwcli projects
```

### Specific Projects

Returns the specific project specified, user must pass option for `-i` parameter.

```ruby
bwcli projects -i 12345678
```

## Feedback
I would be more than happy to recieve feedback, please email me at: jonathan.chrisp@gmail.com or jonathan@brandwatch.com
