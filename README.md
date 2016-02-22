# Base of Chef

including
- bases (iptables, selinux, create user and so on)
- yum (expected CentOS)
- Nginx
- logrotate
- Ruby 2.2.0(by rbenv)
- MySQL 5.6


# Prepare the required tools by gem

```
$ bundle install
```

# Execute chef recipies

```
$ bundle exec knife solo prepare <serverIP>
$ bundle exec knife solo cook <serverIP>
```

# After provisioning, what you need to do are..

- change hostname
- server key settings
- reboot
