1. Update stack version in the `.env` file. For example, `STACK_VERSION=8.14.0-SNAPSHOT`
1. In Kibana with a feature branch checked out, run `yarn build --skip-os-packages`.
1. When the build is done, find the path to the Linux aarch64 archive shown in the many lines of logged text.
1. Copy the archive to the `kibana-dev` folder.
1. Run `docker-compose up -d --build`
1. When all services have started, get into an interactive session in Kibana with `docker-compose exec kibana /bin/bash`
1. In the session, type `cd kibana-dev` then `tar xzf kibana-8.13.0-SNAPSHOT-linux-aarch64.tar.gz`
1. Set the configuration with `cp kibana.yml kibana-8.13.0-SNAPSHOT/config/kibana.yml`
1. Type `cd kibana-8.13.0-SNAPSHOT` then `bin/kibana` and watch the magic happen.

Last tested with kibana-9.0.0-SNAPSHOT-linux-aarch64.tar.gz.
