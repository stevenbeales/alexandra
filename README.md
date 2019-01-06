# Alexandra

A custom Amazon Alexa skill powered by a custom Ruby on Rails application. 

### Table of Contents

1. [Get the Repo](#get-the-repo)
2. [Dependencies](#dependencies)
3. [Configuration](#configuration)
4. [Start the Database](#start-the-database)
5. [Start the Server](#start-the-server)
6. [Running Tests](#running-tests)
7. [Setup to Test Against Amazon Alexa](setup-to-test-against-amazon-alexa)
8. [Getting Your Changes Deployed](getting-your-changes-deployed)

## Get the Repo

Fork the repository onto your own GitHub account! Navigate to [project repository](https://github.com/sbeales/alexandra) and select Fork on the top right corner of the page.

Download the project locally. Clone the project onto your machine!
```
git clone git@github.com:<username>/alexandra.git
```

To run or do work on the project, make sure you're in the project directory.
```
cd Alexandra
```

## Dependencies

First, got that [Homebrew](http://brew.sh/)?  If not, install it!  We'll use Homebrew to install pretty much everything needed for this project.

Next up, what about [`rbenv`](https://github.com/rbenv/rbenv)(Ruby Version Manager)?  If you don't have it installed, run this:
```
$ brew update
$ brew install rbenv
```

This project is built on Ruby 2.5.3:
```
$ rbenv install 2.5.3
```

Make sure you have [Bundler](http://bundler.io/) installed for Ruby 2.5.3 as well!
```
$ gem install bundler
```

We'll be using [Postgres](http://www.postgresql.org/) (Version 11.0+) as our database:
```
$ brew install postgres
```

That does it for system dependencies.  Now you'll just need to install the app dependencies for Ruby:
```
$ bundle install
```

## Configuration

To configure the project, first copy the example secrets file.
```
cp config/secrets.example.yml config/secrets.yml
```

Next, do the same with the database configuration file.
```
cp config/database.example.yml config/database.yml
```

Lastly, set up the database.
```
rake db:create db:migrate
```

## Start the Database

```
$ pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
```

I suggest opening your shell config and adding an alias (something like `pgstart`) so you don't have to type that whole command out.

## Start the Server

```
$ rails s
```

Now the application will be available at `localhost:3000`

## Running Tests

```
$ bundle exec rspec
```

## Setup to Test Against Amazon Alexa

First, create an Amazon Developer Account, create a new Alexa skill, and drag and drop `alexa_interaction_model.json` into the code editor in the Interaction Model Beta configuration tab. You can use the tools in the Test tab to test server responses by typing in specific Alexa requests. You will also be able to test the skill on any Alexa enabled device that is registered using your developer account.

*Note: To test the skill, you must specify a Service Endpoint in the Configuration tab. The skill must be hosted on a server or cloud platform that supports https requests. For local testing [ngrok](https://ngrok.com) is a fantastic tool.*

## Getting Your Changes Deployed

Open a Pull Request and wait for a review. If accepted, the main branch of the repository will be updated and your code will be deployed on the next version release of Alexandra.
