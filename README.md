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

## Database Design
- we only have exact one many-to-one relationship between animals and shelter and the design is like following figure
![soa](https://github.com/SOAgogo/exhaustednei/assets/48583047/4fdb1cce-7124-49ca-9309-e6718011c823)


## Running tests

To run tests:

```shell
rake spec
```
