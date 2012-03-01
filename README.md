# Lo-Teks

A Papertrail webhook to manage metrics from logs.

![Lo-Teks](http://cps-static.rovicorp.com/2/Open/Sony%20Pictures/Johnny%20Mnemonic/_derived_jpg_q90_410x410_m0/JohnnyMnemonic-Still2.jpg)

http://en.wikipedia.org/wiki/Johnny_Mnemonic_(film)


## Create an instance of this webhook on heroku

The easiest way to run this is to grab the code and run a copy on heroku:

    $ git clone git://github.com/papertrail/lotek.git
    $ cd lotek
    $ heroku create --stack cedar
    $ heroku addons:add memcache
    $ git push heroku master
    $ heroku config:add METRICS_EMAIL=<librato_metrics_email> METRICS_TOKEN=<librato_metrics_token>

## Step 6: Create a search alert and point it to the webhook

Create a Search Alert in Papertrail to fire every minute pointed at
the location specified by `Your Papertrail Webhook URL:`

For instance:

    http://holler-mountain-37.herokuapp.com/submit?....

Once you've done that, you should start to see metrics in your Librato Metrics
dashboard.


# License

Copyright (c) 2012 Eric Lindvall

Published under the MIT License, see LICENSE
