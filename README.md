# ngdoc

Basic IRC bot that links stuff from Angular JS API documentation.

## Usage

```shell
$perl init.pl <server> <port> <nickname> "<#channel1,#channel2,#etc>"
```

Once the bot joins a channel, the lookup feature is available by mentioning its nickname, as in:

```
<nickname> [angular version number] <search term>
```

## Dependencies

- [LWP::Simple](https://metacpan.org/pod/LWP::Simple)
