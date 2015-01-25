eurucamp’s Living Style Guide
=============================

Live version: <http://style-guide.eurucamp.org/latest>


Run locally
-----------

```
git clone git@github.com:eurucamp/livingstyleguide-eurucamp.git
cd livingstyleguide-eurucamp
bundle
bundle exec middleman
```

Open <http://localhost:4567/> in your browser.

Deployment
----------

Every commit on the branch `master` is automatically deployed and and pushed to <http://style-guide.eurucamp.org/latest>. A list of older artefacts is available at <http://style-guide.eurucamp.org>.

#### Manual deployment to S3

* Copy the sample S3 configuration file and fill in the correct credentials:

     `cp .s3_sync.sample .s3_sync`

* Build and deploy the site:

    `bundle exec middleman build && bundle exec middleman s3_sync`

## Logo

Don't use the eurucamp logo for your instance to avoid confusion.

## License

Please see the accompanying `LICENSE` file.
