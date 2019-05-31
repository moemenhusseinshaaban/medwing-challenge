# Medwing Challenge

Challenge is a rails application with version 5.2 and ruby version 2.3.1 for saving and analyzing thermostats readings of heating system of an apartment.

Challenge consists of three apis that apply, retrieve reading and calculate some statistics of all reading of specific thermostat

For each reading there is a generated sequence number for a specific thermostat which is returned as a reading_id for this specific reading,
and retrieving the data would be with the reading_id (the new sequence number for the thermostat) and the thermostat id as the sequence number and the thermostat id are unique together  

Challenge will be using JWT for authentication as thermostat must call (api/authenticate) api to get a Json Web Token to be able to access the required apis

Challenge is using RSWAG gem for documenting the apis and allow us to test the apis manually

Challenge is using Sidekiq to allow to save the reading record in a background job

Challenge is using Redis for caching the data to be able to be retrieved without even saved in the database, also allow us to cash the statistics in order to
retrieve statistics with complexity O(1)   

## Prerequisite


## Installation

```bash
$ git clone https://github.com/moemenhusseinshaaban/medwing-challenge.git
$ cd PATH_To_PROJECT/
$ bundle install
```
Execute the following commands for migrating the database

```bash
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

There are three records of thermostat seeded in database and printed out in terminal their household_token which will be used for authentication.

Suppose that the following will be printed out
"THERMO#1"
"THERMO#2"
"THERMO#3"


Executing the following command to apply the rswag json that will be rendered in the browser

```bash
$ rake rswag:specs:swaggerize
```

Executing the testing command to make sure that project is successfully working

```bash
$ bundle exec rspec
```

Execute the following command to run the background worker

```bash
$ bundle exec sidekiq
```

Execute the following command to run the server (default port is 3000)

```bash
$ rails s
```

Open the browser and go to the following url to open the swagger page
DOMAIN_NAME/api-docs

## Usage

- First use one of the household token of the thermostat (ex: THERMO#1) in the first api which will initialize the cache with the current values and retrieve and authentication token which will be used in the Authorization header parameter

- Use the token in the three apis as following format
 Authorization <authentication token>

- Apply first record in the post reading api, it will retrieve a reading id which maps to a sequence number generated for the specific thermostat

- Use the reading_id (sequence number) that is retrieved from the post api to retrieve the reading data.

- Call The statistics Api to get the statistics data required in the challenge
