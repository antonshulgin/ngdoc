# NgDoc

Basic IRC Bot that links stuff from [docs.angularjs.org](https://docs.angularjs.org).

## Usage

```shell
$perl init.pl <server> <port> <nickname> \"<#channel1,#channel2,#etc>\"
```

Once the bot joins a channel, the lookup feature is available by mentioning its nickname, as in:

```
<nickname> <search term>
```

## Dependencies

- [LWP::Simple](https://metacpan.org/pod/LWP::Simple)
