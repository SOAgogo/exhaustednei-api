# Animal adoption platform

Application that allows *some missing pets* can find its warm hosue and *other pets lovers* can adopt the pets from the original pets keepers

## Overview

Animal adoption platform will pull data from the data source from agriculture burreau of Taiwanese goverment 

## Objectives
* Offer the channels to inform the pet lovers to adopt the missing pets

### Short-term usability goals

- the platform for adopting animals
- Analyze data from goverment and try to send the notifications to the potential clients who want to adopt pets.


### Long-term goals

- Perform static analysis of folders/files: e.g., flog, rubocop, reek for Ruby

## Setup

- Run `ruby lib/correct_data_init.rb` in rakefile once then you don't need to do that after that because the government would update data everyday
- Ensure correct version of Ruby install (see `.ruby-version` for `rbenv`)
- Run `bundle install`

## Running tests

To run tests:

```shell
rake spec
```
