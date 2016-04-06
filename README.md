You will need to install these gems first:

* haml
* rmagick
* sprite-factory

To run the debug IRB console, you will also need the `awesome_print` gem.

Then, to generate LoL schedule:

1. run `rake data`
2. run `rake build`

This will generate `index.html` and `icons.png`.

To deploy the schedule to S3 you will need the `aws-sdk` gem installed.
