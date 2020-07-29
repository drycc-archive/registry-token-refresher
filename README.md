
# Registry Token Refresher
[![Build Status](https://travis-ci.org/drycc/registry-token-refresher.svg?branch=master)](https://travis-ci.org/drycc/registry-token-refresher)

Drycc (pronounced DAY-iss) Workflow is an open source Platform as a Service (PaaS) that adds a developer-friendly layer to any [Kubernetes](http://kubernetes.io) cluster, making it easy to deploy and manage applications on your own servers.

For more information about the Drycc Workflow, please visit the main project page at https://github.com/drycc/workflow.

We welcome your input! If you have feedback, please [submit an issue][issues]. If you'd like to participate in development, please read the "Development" section below and [submit a pull request][prs].

# About
The Registry Token Refresher service creates the [imagePullSecret][imagePullSecrets] and updates it at regular interval of time for each app(namespace) created by Drycc Workflow. The secrets are used by [dockerbuilder][dockerbuilder] and [controller][controller] for authenticating with the private registry.

This service is run only when using Amazon's [ECR][ecr] or Google's [GCR][gcr] as they provide short lived tokens for authentication.

[issues]: https://github.com/drycc/workflow/issues
[prs]: https://github.com/drycc/workflow/pulls
[imagePullSecrets]: http://kubernetes.io/docs/user-guide/images/#specifying-imagepullsecrets-on-a-pod
[dockerbuilder]: https://github.com/drycc/dockerbuilder
[controller]: https://github.com/drycc/controller
[ecr]: http://docs.aws.amazon.com/AmazonECR/latest/userguide/ECR_GetStarted.html
[gcr]: https://cloud.google.com/container-registry/
[v2.18]: https://github.com/drycc/workflow/releases/tag/v2.18.0
