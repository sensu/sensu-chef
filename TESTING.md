## Testing the cookbook

This cookbook has tests in the source repository. To run the tests, first install the required gems:

```
git clone git://github.com/sensu/sensu-chef.git
cd sensu-chef
bundle install
```

There are two kinds of tests in use: unit and integration tests.

### Unit Tests

The cookbook is unit tested with rspec. To run these tests, use rake:

```
bundle exec rake spec
```

### Integration Tests

Integration tests are setup to run under test-kitchen:

```
bundle exec rake kitchen:all
```

This tests a number of different suites, some of which require special credentials or virtual machine configurations. Please see the caveats and known issues below for additional details.

### Local development tools

The project includes tools like Rubocop and Foodcritic to help with uniformity and quality of code changes. Because these tools presently report a number of existing violations, they are not enabled as part of our automatic testing as of this writing. During local development it is recommended that you run `bundle exec guard` to automatically test your changes using these tools.

### Caveats and known issues

* The centos-511 platform is also excluded from the `sysv` suite because the "rabbitmqctl" executable is not in root's path, which causes rabbitmq configuration to fail.
* Testing the `enterprise` and `enterprise-dashboard` suites require valid Sensu Enterprise repository credentials exported as the values of `SENSU_ENTERPRISE_USER` and `SENSU_ENTERPRISE_PASS` respectively.
* Testing the `enterprise` suite requires allocating ~3gb of memory to the test system.
* Testing Windows platforms requires you to Bring Your Own Basebox.
