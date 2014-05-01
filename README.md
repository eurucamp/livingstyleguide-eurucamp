eurucamp’s Living Style Guide
=============================

Live version: <http://livingstyleguide.com/eurucamp/>


Run locally
-----------

```
git clone git@github.com:eurucamp/livingstyleguide-eurucamp.git
cd livingstyleguide-eurucamp
bundle
bundle exec middleman
```

Open <http://localhost:4567/> in your browser.

Deployment to S3
----------------

### Setup

Copy the sample S3 configuration file:

     cp .s3_sync.sample .s3_sync

and add your AWS credentials.

### Deploys

To deploy the site:

    bundle exec middleman build && bundle exec middleman s3_sync
