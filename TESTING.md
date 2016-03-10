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
bundle exec rake kitchen:all
```

This tests a number of different suites, some of which require special credentials or virtual machine configurations. Please see the caveats and known issues below for additional details.

### Caveats and known issues

* Testing the `enterprise` and `enterprise-dashboard` suites require valid Sensu Enterprise repository credentials exported as the values of `SENSU_ENTERPRISE_USER` and `SENSU_ENTERPRISE_PASS` respectively.
* Testing the `enterprise` suite requires allocating ~3gb of memory to the test system.
* Windows tests are currently considered a special case, and therefore ommited when running the `kitchen:all` rake task. You may test them manually via `bundle exec kitchen converge` but `verify` and `test` will fail.
* Testing Windows platforms requires you to Bring Your Own Basebox. See https://github.com/joefitzgerald/packer-windows for a Packer template that includes OpenSSH.
* Testing Windows platforms currently uses the converge-only windows_chef_zero provisioner. Running `kitchen verify` or `kitchen test` on instances using this provisioner will fail.
