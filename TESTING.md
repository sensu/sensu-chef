## Testing the cookbook

This cookbook has tests in the source repository. To run the tests:

```
git clone git://github.com/sensu/sensu-chef.git
cd sensu-chef
bundle install
```

There are two kinds of tests in use: unit and integration tests.

### Unit Tests

The resource/provider code is unit tested with rspec. To run these tests, use rake:

```
bundle exec rake spec
```

### Integration Tests

Integration tests are setup to run under test-kitchen:

```
bundle exec kitchen test
```

This tests a number of different suites, some of which require special credentials or virtual machine configurations. Please see the caveats and known issues below for additional details.

### Caveats and known issues

* Testing the `enterprise` and `enterprise-dashboard` suites require valid Sensu Enterprise repository credentials exported as the values of `SENSU_ENTERPRISE_USER` and `SENSU_ENTERPRISE_PASS` respectively.
* Testing the `enterprise` suite requires allocating ~3gb of memory to the test system.
* Testing Windows platforms requires you to Bring Your Own Basebox. See https://github.com/boxcutter/windows for a Packer template.
* Be advised that even once you have a Windows basebox built from one of the boxcutter, you may not be able to install the required version of Microsoft .Net Framework without manual intervention (e.g. attaching installation media as a shared folder and exporting the path as the value of the `SENSU_WINDOWS_DISM_SOURCE` environment variable. See [this issue on the sensu/sensu-build project](https://github.com/sensu/sensu-build/issues/149) for more details.
