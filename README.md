# winscp-client-formula

A Saltstack formula designed to install and configure the [WinSCP](https://winscp.net/) file-transfer utility (and to uninstall the utility, later). WinSCP is a free, open-source file transfer and remote file management utility for Windows. It provides both an interactive graphical interface and a scriptable command-line environment for transferring files securely between a local machine and remote servers over protocols including SFTP, SCP, FTP, FTPS, WebDAV, and Amazon S3.

It is primarily expected that this formula will be run via [P3](https://www.plus3it.com/)'s "[watchmaker](https://watchmaker.readthedocs.io/en/stable/)" framework.

This formula is able to install the WinSCP file-transfer utility on Windows[^1] desktop operating environments:

[^1]: As of this README's writing, this functionality has only been tested on Windows Server 2022


## Available states

- [winscp-client](#winscp-client)
- [winscp-client.clean](#winscp-client.clean)
- [winscp-client.package](#winscp-client.package)
- [winscp-client.package.clean](#winscp-client.package.clean)
- [winscp-client.config](#winscp-client.config)
- [winscp-client.config.clean](#winscp-client.config.clean)

### winscp-client

Executes the `package` and `config` states to install and configure the WinSCP file-transfer utility. This includes the utility's binaries and user-configuration template files.

### winscp-client.clean

Executes the `package` and `config` states' `clean` actions to fully uninstall the WinSCP file-transfer utility. This includes uninstalling the binaries and user-configuration template files.

### winscp-client.package

Executes the `package` state to install the WinSCP file-transfer utility. This includes only the utility's binaries.

### winscp-client.package.clean

Executes the `package` state's `clean` function to uninstall the WinSCP file-transfer utility. This includes only the utility's binaries.

### winscp-client.config

Executes the `config` state to install the WinSCP file-transfer utility. This includes only the utility's user-configuration template files.

### winscp-client.config.clean

Executes the `config` state's `clean` function to uninstall the WinSCP file-transfer utility. This includes only the utility's user-configuration template files.
