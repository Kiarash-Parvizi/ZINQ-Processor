# ZINQ Processor
a simple single-cycle processor designed for educational purposes

## run and test:
### make sure you have [Parvaj](https://github.com/machitgarha/parvaj) currectly installed by running:
```
git submodule update --init --recursive
cd scripts
composer install
```
### Requirements
```
- PHP 7.4+
- Composer
- GHDL
- GtkWave
```
### run unit-test
```
scripts/start-unit-test.php <test-entity-name> [<workdir>] [<simulation-options>]
```

## data-path:
![](about/single-cycle/datapath.jpg)

## controller:
[//]: # "![](about/single-cycle/controller.jpg)"

