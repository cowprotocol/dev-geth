dev-geth is a small program to help with running [geth] in dev mode to
serve as an environment for automated tests in the [services] repo.
Geth doesn't provide a way to reset the dev environment,
other than restarting the geth program itself.
dev-geth exposes an HTTP port to which a POST request can be made in order
to restart geth and provide a clean testing environment. Note that
restarting the program will wait until geth starts responding to RPC
requests before returning 200 to the caller.

Geth is the only node with dev mode which implements the
`eth_createAccessList` endpoint. When hardhat adds support for
`eth_createAccessList`, this can be removed from our infrastructure.

[geth]: https://geth.ethereum.org/
[services]: https://github.com/cowprotocol/services
