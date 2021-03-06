# Shrturl - a URL shortener

see it in action at https://cg-shrturl.herokuapp.com/

## Stack
- Ruby 3.0.2
- Rails 6.1.4
- Rspec 5
- Postgres 14.1
- Redis 6.2.5
- Sidekiq 6.3.1

## Installation

Options:
1. [Docker](#option-1-docker-installation) (recommended)
2. [Manual](#option-2-manual-installation)

### Option 1: Docker Installation

1. install and run Docker
2. run `docker-compose run web rake db:create db:migrate` in the project root directory
3. run `docker-compose up` to boot the web server
4. access web app at http://localhost:3000
 
### Option 2: Manual Installation

1. install dependencies as per [Stack](#stack)
2. set database environment variables (see [`database.yml`](config/database.yml)):
   - `DATABASE_HOST`
   - `DATABASE_USERNAME`
   - `DATABASE_PASSWORD`
4. run `rake db:create db:migrate`
5. run `foreman start` (see [`.foreman`](.foreman) for default configuration)
6. access web app at http://localhost:3000

## Deploying
1. set config vars as found in [`.env.sample`](.env.sample)

## Considerations

### Geocoder API Limits
This project uses Geocoder to geocode `ClickEvent` from IP Addresses, which relies on a free 3rd party API.
This API has rate limits, and if there is a high rate of click events it may exceed the quota.

Currently the project handles it by attempting the geocode lookup after a delay,
which assumes that it was just a spike in clicks. However, if the overall traffic
increases, we will need to either upgrade to a 
[paid API](https://github.com/alexreisner/geocoder/blob/master/README_API_GUIDE.md#local-ip-address-lookups),
or fallback to alternative APIs or a local database lookup.
