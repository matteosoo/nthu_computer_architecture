Final Project - Report
===
[![hackmd-github-sync-badge](https://hackmd.io/SNl-CwBbQZicLr0pMNERdA/badge)](https://hackmd.io/SNl-CwBbQZicLr0pMNERdA)

## Catalog
[TOC]

## Goal
* The cache behavior simulation
    1. Study and implement a cache policy (NRU replacement policy). [70%]
    2. Choose a cache indexing scheme to minimize cache conflict miss. [30%]

## Algorithm flow-chart

## Description of data structure

## Demo (How to run)
1. Environments
    * c++ compile with g++
    * The nthucad server will be used as the demonstration platform. (ssh://nthucad.cs.nthu.edu.tw `port 22`)
    * Login to ic21 : `$ ssh -X ic21` for getting gcc permission
2. Compile
    * `$ g++44 project.cpp -std=c++0x -o project`
3. Execute
    * `$ ./project config/cache1.org bench/reference1.lst index.rpt`
    * `project` is your binary code.
    * `cache1.org`, `reference1.lst` are input files.
    * `index.rpt` is the output file name. 
    * Those input files are ASCII format.
4. Verify
    * `$ ./verify config/cache1.org bench/reference1.lst index.rpt`
    * `$ cat index.rpt` could check the report on terminal.


###### tags: `computer architecture`
