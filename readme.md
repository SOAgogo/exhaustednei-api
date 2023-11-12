# Animal adoption platform

Application that allows *some missing pets* can find its warm hosue and *other pets lovers* can adopt the pets from the original pets keepers

## Overview

Animal adoption platform will pull data from the data source from agriculture burreau of Taiwanese goverment 

## Objectives
* Offer the channels to inform the pet lovers to adopt the missing pets

### Short-term usability goals

- the platform for adopting animals
- Analyze data from goverment and try to send the notifications to the potential clients who want to adopt pets.

### database design:
- At this moment, we only have many-to-one relationship between shelters and animals. In the future, probably we could have
  more relationships like potential adopters and animals etc ...
- **this is the figure of database design** :
  ![soa](https://github.com/SOAgogo/exhaustednei/assets/48583047/1fd00b65-b0d4-46a2-acbb-eb53467cf4e1)

### Long-term goals

- Perform static analysis of folders/files: e.g., flog, rubocop, reek for Ruby



## Running tests

To run tests:

```shell
rake spec
```
