Conjurl - URL shortener API and redirect server

# Features

Takes long URLs and shortens them. The shortened URL can then be used
anywhere!

# API Usage Example

Using [HTTPie](http://httpie.org):
```
# Create a new short URL:
$ http -b localhost:3000/api/short_urls target_url=http://popurls.com
{
    "created_at": "2017-04-14T22:04:13Z",
    "self": "http://localhost:3000/api/short_urls/DtTtabRy",
    "short_url": "http://localhost:3000/DtTtabRy",
    "target_url": "http://popurls.com"
}
# Find it again:
$ http localhost:3000/api/short_urls/DtTtabRy
{
    "created_at": "2017-04-14T22:04:13Z",
    "self": "http://localhost:3000/api/short_urls/DtTtabRy",
    "short_url": "http://localhost:3000/DtTtabRy",
    "target_url": "http://popurls.com"
}
# Navigate to target page via the short URL (Mac OSX):
$ http localhost:3000/api/short_urls/DtTtabRy | jq -r 'short_url' | xargs open
```

# Development

## Dependencies

- Ruby 2.3.3
- Rails 5.0.2
- Postgresql 9.5.x

## Configuration

Optionally, you can configure the length of the shortened URLs and the
alphabet used to generate the short URL keys.

See config/setting.yml and config/settings/<env>.yml.

## Setup

```
rails db:create
```

## Run the tests

```
$ rspec
```

## Run server (localhost)

```
$ rails server
```

# Production Deployment Instructions

## Using AWS Elastic Beanstalk:

Run the following from the project directory to deploy the latest Git-committed changes to a new AWS Elastic Beanstalk environment:
```
$ eb create conjurl-prod-2 --single -i t2.micro -r us-east-2 --keyname conjurl-prod --platform 'ruby-2.3-(puma)' --database --database.username dbconjurl --database.password <YOUR_SUPER_SECURE_PASSWORD> --database.engine postgres --database.size 5
$ eb setenv SECRET_KEY_BASE=`rails secret` CONJURL_URL_REDIRECT_SERVICE_HOST=http://`eb status | grep CNAME: | awk '{ print $2 }'`
```
To deploy Git-committed updates to the current AWS Elastic Beanstalk environment:
```
$ eb deploy
```
