# Pokupon::Deamon

Welcome to my test project, this is deamon which tests sites availibility. When site is available (i.e. response status is 200) deamon wait 1 minute,
after that checks again. If domain is unavailable, there will be sent to email address from configuration file.

## Installation
Clone repository repository from git and go to **pokupon-deamon** directory
And then execute:
    $ bundle install

## Usage

To start a deamon:
    ```
   $ ruby lib/server-control.rb start
    ```
to stop a deamon
    ```
    $ ruby lib/server-control.rb stop
    ```
to get a status 
    ```
    $ ruby lib/server-control.rb status
    ```
to run in debug mode 
    ```
    $ ruby lib/server-control.rb run
    ```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pokupon-deamon.
