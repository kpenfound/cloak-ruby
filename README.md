# README

This is a basic rails blog that uses cloak for CI/CD

Created with [the getting started guide](https://guides.rubyonrails.org/getting_started.html).

## Interesting things to look at here

### Rails things
The rails code is pretty boilerplate from the above guide. What makes this interesting is that the rails actions are executed by cloak.

[script/migrate.mjs](script/migrate.mjs) runs a `rails db:migrate` with cloak. This is executed with `yarn run migrate`.

Why would you run this instead of just running `yarn run migrate`?

Executing this with yarn means we can consistently control filesystem, environment, and secrets across execution environments. Cloak can retrieve my secrets directly rather than me needing to export them into my shell.

### Terraform things
The infrastructure for this rails blog is defined under [terraform/](terraform/). It creates our required resources in AWS such as:
- ECS Service
- RDS database
- Load balancer w/ https cert

Similar to the explaination above for rails, executing this in cloak lets us guarantee consistency across execution environments.

Running `yarn run tfplan` executes [script/tfplan.mjs](script/tfplan.mjs)

### Container things
We push containers
TODO
