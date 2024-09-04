Tested with kibana-8.13.0-SNAPSHOT-linux-aarch64.tar.gz. Ran with placing said build in the kibana-dev folder.

1. In Kibana with a feature branch checked out, run `yarn build --skip-os-packages`.
1. When the build is done, find the path to the Linux aarch64 archive shown in the many lines of logged text.
1. Copy the archive to the `kibana-dev` folder.
1. Run `yarn build:ubuntu` to test kibana on regular ubuntu linux
1. Run `yarn build:oracle` to test kibana on oracle and related linux variants, as of now build for this image could be pretty slow
1. When all services have started, get into an interactive session in Kibana with `yarn shell`
1. In the session, type `cd kibana-dev` then `tar xzf kibana-<version>-SNAPSHOT-linux-aarch64.tar.gz`
1. Set the configuration with `cp kibana.yml kibana-<version>-SNAPSHOT/config/kibana.yml`
1. Type `cd kibana-<version>-SNAPSHOT` then `bin/kibana` and watch the magic happen.
