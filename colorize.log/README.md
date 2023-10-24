# EDA log colorizers


## Vivado ![vivado](https://img.shields.io/badge/-Vivado-FF1010.svg?logo=xilinx&logoColor=ffffff)

![Vivado log colorizers](/image/vivado-colorize.png?raw=true[])


### SED syntax explanation

* `'/\(^#.*\)/d'` - delete all command echo in log
* `"s/\('[\*\/._a-zA-Z0-9]*'\)/\o033[2m\1\o033[22m/g"` - highligth module and signal names inside single quotes
* `"s/\('[\*\/._a-zA-Z0-9]*\[[0-9]*\]'\)/\o033[2m\1\o033[22m/g"` - highligth vectored signal names inside single quotes (xxx[z])
* Highligting tables:
  * `'s/\(^|.*\)/\o033[1m\1\o033[0m/'`
  * `'s/\(^----.*\)/\o033[1m\1\o033[0m/'`
  * `'s/\(^====.*\)/\o033[1m\1\o033[0m/'`
  * `'s/\(^\+.*\)/\o033[1m\1\o033[0m/'`
* Emphasizing build milestones:
  * `'s/\(^Phase.*\)/\o033[7m\1\o033[27m/'`
  * `'s/\(^Start.*\)/\o033[7m\1\o033[27m/'`
* `'s/\(^WNS.*\)/\o033[36m\1\o033[39m/'` - for highlight custom messages
* Handle standard messages: INFOs, WARNINGs, CRITICAL WARNINGs, ERRORs
  * `'s/\(^INFO.*\)/\o033[92m\1\o033[39m/'` - INFOs
  * `'s/\(^WARNING.*\)/\o033[34m\1\o033[39m/'` - WARNINGs
  * `'s/\(.*CRITICAL.*\)/\o033[35m\1\o033[39m/'` -  CRITICAL WARNINGs
  * `'s/\(^ERROR.*\)/\o033[31m\1\o033[39m'` - ERRORs


#### About echoed-command outputs in log


to remove # messages use:
```
    -e '/\(^#.*\)/d'
```

to hidden # messages use (using non-contrast font for light bg):
```
    -e 's/\(^#.*\)/\o033[37m\1\o033[39m/'
```

