Conjurl - URL shortener API and redirect server

* Features

Takes long URLs and shortends them. The shortened URL can then be used
anywhere!

* API

* Development

** Stack

- Ruby 2.3.3
- Rails 5.02
- Postgresql 9.5.x

** Configuration

See config/setting.yml and config/settings/<env>.yml.

Optionally, you can configure the length of the shortened URLs and the
alphabet used to generate the short URL keys.

** Setup

```
rails db:create
```

** Run server

```
$ rails server
```

** Running the tests

```
$ rspec
```

* Production Deployment Instructions

** Using AWS Elastic Beanstalk:

Using the AWS Elastic Beanstalk CLI (`eb`):
```
$ eb create conjurl-prod-2 --single -i t2.micro -r us-east-2 --keyname conjurl-prod --platform 'ruby-2.3-(puma)' --database --database.username dbconjurl --database.password <YOUR_SUPER_SECURE_PASSWORD> --database.engine postgres --database.size 5
$ eb setenv SECRET_KEY_BASE=`rails secret` CONJURL_URL_REDIRECT_SERVICE_HOST=`eb status | grep CNAME: | awk '{ print $2 }'`
```

