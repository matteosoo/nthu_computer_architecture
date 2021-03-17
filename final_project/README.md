Final Project - Report
===
[![hackmd-github-sync-badge](https://hackmd.io/SNl-CwBbQZicLr0pMNERdA/badge)](https://hackmd.io/SNl-CwBbQZicLr0pMNERdA)

## Catalog
[TOC]

## Goal
* The cache behavior simulation
    1. Study and implement a cache policy (NRU replacement policy). [70%]
    2. Choose a cache indexing scheme to minimize cache conflict miss. [30%]

## Summary of the introduction
project將以C++模擬cache機制，首先也先理解LRU和NRU差異。

參考: https://zhuanlan.zhihu.com/p/68301223
* LRU：Least Recently Used 淘汰最早access的cache
    * use a **pointer** pointing at each block in turn
    * whenever an access to the block the pointer is pointing at, move the pointer to the next block 每次存取就把pointer指向下一個block
    * when need to replace, replace the block currently pointed at 當需要replace時，就取代目前所指向的block
    * However, implementing the least recently used (LRU) replacement policy in hardware is costly due to the **high hardware complexity**.
* NRU：Not Recently Used
    * 既然紀錄最早使用的cache很難，那麼NRU就把時間分成週期的概念，如果最近一個週期都沒有被使用，那就乾脆當作一直沒有使用。
    * 換句話說就是，不一定要最早被使用的被淘汰，只要不是最近被使用的被淘汰就好了。

    ![](https://i.imgur.com/jpdTQwx.png)

* 以上圖的一個NRU例子
    * 起始: 將一用於記錄nru-bit的boolean array, 全部設成 '1'
    * 若cache miss 發生, 由左至右搜尋nru-bit為1之項目, 將data replace並把nru-bit改為 '0'
        * 若nru-bit全部搜尋完都為0, 則將所有nru-bits重新reset全為1(回到*起始*)
    * 若cache hit 發生, set nru-bit為 '0'

## Algorithm flow-chart
* 1. main 先讀取 cache.org 和 reference.lst 資訊
* 2. call cache_miss function 計算 cache miss 次數
    * 2.1 利用 2-d boolean array `nru_list[cache_sets][associativity];` 將NRU_list 全部設為 '1'
    * 2.2 $for$ i = 第一筆資料 $to$ 最後一筆資料 $do$
        * 2.2.1 `tag`: using `tag_bits` and `reference_list` to extract
        * 2.2.2 `index`: using `indexing_bit_count`, `reference_list` to extract
        * 2.2.3 $if$ `cache hit` $then$ 維持nru-bit為 ‘0’
        * 2.2.4 $if$ `cache miss` $then$ `total_miss_count`+1 且由左至右found nru-bit '1'
            * 2.2.4.1 $if$ found '1', $then$ replace block and set nru-bit to '0'
            * 2.2.4.2 $if$ NOT found '1', $then$ set all nru-bits to '1' 並 replace the first block and set the first nru-bit to '0'
    * 2.3 return `total_miss_count`
* 3. main 將結果寫入 index.rpt 輸出

## Description of data structure
在此簡單分成2個function，其一是main function 作為I/O用，其二是cache_miss function 作為計算cache miss 次數用。

### main function
* read config/cache.org
    * 原有資訊如下
        ```
        Address_bits: 8
        Block_size: 4
        Cache_sets: 8
        Associativity: 1
        ```
    * 藉由這些資訊我們可以計算 block的 offsets_bits以及 cache的 index_bits。
    * offsets_bits = $log_24$ = 2
    * indexing_bit_count = $log_28$ = 3
    * tag_bits 用以唯一識別 block address, 也可推論出為 8 - 2 - 3 = 3
* read bench/reference.lst
    * 讀取cache資料
    * 頭尾分別為".benchmark testcase1"以及".end"
        ```
        .benchmark testcase1
        00101100
        00100000
        00101100
        00100000
        .end
        ```
* write index.rpt
    * 結果要如下格式
        ```
        Address bits: 8
        Block size: 4
        Cache sets: 8
        Associativity: 1

        Offset bit count: 2
        Indexing bit count: 3
        Indexing bits: 4 3 2

        .benchmark testcase1
        00101100 miss
        00100000 miss
        00101100 hit
        00100000 hit
        .end

        Total cache miss count: 2
        ```

### cache_miss function
```c
int cache_miss(int cache_sets, int associativity, int reference_list_length, int tag_bits, int indexing_bit_count)
{
    ...
}
```
cache_miss function使用了幾個integer變數在以下分別一一說明

1. cache_sets: 如 cache.org 所讀到的資料
3. associativity: 如 cache.org 所讀到的資料
4. reference_list_length: default = 99999, 因助教有說明 reference list 會有幾萬行 
5. tag_bits: 在 read bench/reference.lst 有推論說明
6. indexing_bit_count: 在 read bench/reference.lst 有推論說明

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
* Note: `project_advance.cpp` has some bugs not been fixed yet.


###### tags: `computer architecture`
