Conjurl - URL shortener API and redirect server

# Overview

- Takes long URLs and providers a shorter URL that will redirect back
  to the original URL. The shortened URL can then be used anywhere!
- A user account can be created to manage and track the usage of your
  shortened URLs.
- For account-associated shortened URLs, reports statistics for click
  counts, referrer URLs, and referrer IP addresses for last 24 hours
  and lifetime of shortened URL.
- Easily deployable to AWS Elastic Beanstalk.

# API Usage Example

Using [HTTPie](http://httpie.org):
```

# Create an account:
$ http -b localhost:3000/api/accounts name="Linkoln Longfellow"
{
    "account": {
        "created_at": "2000-01-01T12:00:00Z",
        "name": "Linkoln Longfellow",
        "public_identifier": "4ad31240-051b-0135-379e-0088653f7810",
        "self_ref": "http://localhost:3000/api/accounts/4ad31240-051b-0135-379e-0088653f7810",
        "short_urls": 0,
        "short_urls_ref": "http://localhost:3000/api/accounts/4ad31240-051b-0135-379e-0088653f7810/short_urls"
    },
    "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjb25qdXJsLmNvbSIsImF1ZCI6ImNvbmp1cmwiLCJpYXQiOjE0OTIzNzg4NTQsInN1YiI6IjRhZDMxMjQwLTA1MWItMDEzNS0zNzllLTAwODg2NTNmNzgxMCJ9.I7iqvfG6z0mrgcu-5Vuyioof0ufJ1yCzztrUgaH35Wo"
}
$ AUTH='Authorization:Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjb25qdXJsLmNvbSIsImF1ZCI6ImNvbmp1cmwiLCJpYXQiOjE0OTIzNzg4NTQsInN1YiI6IjRhZDMxMjQwLTA1MWItMDEzNS0zNzllLTAwODg2NTNmNzgxMCJ9.I7iqvfG6z0mrgcu-5Vuyioof0ufJ1yCzztrUgaH35Wo'

# Create a new short URL:
$ http -b localhost:3000/api/short_urls target_url=http://popurls.com "$AUTH"
{
    "created_at": "2000-01-01T12:01:00Z",
    "self_ref": "http://localhost:3000/api/short_urls/weSyIE1u",
    "short_url": "http://localhost:3000/weSyIE1u",
    "statistics_ref": "http://localhost:3000/api/short_urls/weSyIE1u/statistics",
    "target_url": "http://popurls.com"
}

# Find it again:
$ http -b 'http://localhost:3000/api/short_urls/weSyIE1u' "$AUTH"
{
    "created_at": "2000-01-01T12:01:00Z",
    "self_ref": "http://localhost:3000/api/short_urls/weSyIE1u",
    "short_url": "http://localhost:3000/weSyIE1u",
    "statistics_ref": "http://localhost:3000/api/short_urls/weSyIE1u/statistics",
    "target_url": "http://popurls.com"
}

# Navigate to target page via the short URL (Mac OSX):
$ http localhost:3000/api/short_urls/weSyIE1u | jq -r 'short_url' | xargs open
<html><body>You are being <a href="http://popurls.com">redirected</a>.</body></html>

# Retrieve statistics:
$ http -b localhost:3000/api/short_urls/weSyIE1u/statistics "$AUTH"
{
    "last_24_hours": {
        "clicks": 1,
        "top_ip_addresses": {
            "::1": 1
        },
        "top_referrers": {
            "": 1
        },
        "unique_ip_addresses": 1,
        "unique_referrers": 0
    },
    "lifetime": {
        "clicks": 1,
        "top_ip_addresses": {
            "::1": 1
        },
        "top_referrers": {
            "": 1
        },
        "unique_ip_addresses": 1,
        "unique_referrers": 0
    },
    "self_ref": "http://localhost:3000/api/short_urls/weSyIE1u/statistics",
    "short_url": {
        "created_at": "2000-01-01T12:01:00Z",
        "self_ref": "http://localhost:3000/api/short_urls/weSyIE1u",
        "short_url": "http://localhost:3000/weSyIE1u",
        "statistics_ref": "http://localhost:3000/api/short_urls/weSyIE1u/statistics",
        "target_url": "http://popurls.com"
    }
}

# List all of your short URLs:
$ http -v -b localhost:3000/api/accounts/4ad31240-051b-0135-379e-0088653f7810/short_urls "$AUTH"
[
    "http://localhost:3000/api/short_urls/weSyIE1u"
]

# Check if the system is OK:
$ http localhost:3000/health
HTTP/1.1 200 OK
...
 ```

# Development

## Dependencies

- Ruby 2.3.3
- Rails 5.0.2
- Postgresql 9.5.x

## Configuration

Optionally, you can configure the length of the shortened URLs and the
alphabet used to generate the short URL keys.

See `config/setting.yml` and `config/settings/<env>.yml`.

## Setup

```
rails db:create
rails db:migrate
```

## Run the tests

```
$ rspec
```

## Run server (localhost)

```
$ rails server -p 3001
```

# Production Deployment Instructions

## Using AWS Elastic Beanstalk:

Install Elastic Beanstalk CLI. Instructions [here](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html).

Run the following from the project directory to deploy the latest Git-committed changes to a new AWS Elastic Beanstalk environment:
```
$ eb create conjurl-prod --single -i t2.micro -r us-east-2 --keyname conjurl-prod --platform 'ruby-2.3-(puma)' --database --database.username dbconjurl --database.password <YOUR_SUPER_SECURE_PASSWORD> --database.engine postgres --database.size 5
$ eb setenv SECRET_KEY_BASE=`rails secret` \
CONJURL_JWT_SECRET=<YOUR_SUPER_SECURE_JWT_SECRET> \
CONJURL_URL_REDIRECT_SERVICE_HOST=http://`eb status | grep CNAME: | awk '{ print $2 }'`
```

To deploy Git-committed updates to the current AWS Elastic Beanstalk environment:
```
$ eb deploy
```

NOTE: This is a toy application and it does not use HTTPS! If you are
horrified at this realization, feel free to configure the server to
use HTTPS. Here's
[how](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/configuring-https.html).
