# Shrturl - a URL shortener

## Stack
- Ruby 3.0.2
- Rails 6.1.4
- Rspec 5
- Postgres 13.3

## Installation

Options:
1. [Docker](#option-1-docker-installation) (recommended)
2. Manual

### Option 1: Docker Installation

1. install and run Docker
2. run `docker-compose run web rake db:create db:migrate` in the project root directory
3. run `docker-compose up` to boot the web server
4. access web app at http://localhost:3000
 
### Option 2: Manual Installation

1. install dependencies as per [Stack](#stack)
2. run `rake db:create db:migrate`
3. run `rails server`
4. access web app at http://localhost:3000
