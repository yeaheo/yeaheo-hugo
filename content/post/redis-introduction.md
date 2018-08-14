+++
title = "redis 简单介绍"
date = 2018-07-28T10:12:52+08:00
tags = ["redis"]
categories = ["redis"]
menu = ""
disable_comments = true
banner = "cover/redis002.jpg"
description = "redis 是一个开源（BSD许可）的内存中的数据结构存储系统,它可以用作数据库、缓存和消息中间件。 它支持多种类型的数据结构，如 字符串（strings)、散列（hashes）、列表（lists）、集合（sets）、序集合（sorted sets）与范围查询、bitmaps、hyperloglogs 和 地理空间（geospatial）索引半径查询。"
+++

- redis 是完全开源免费的，遵守 BSD 协议，是一个高性能的 `key-value` 数据库。

### redis 特点
- redis 与其他 `key-value` 缓存产品有以下三个特点：
- redis 支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。
- redis 不仅仅支持简单的 `key-value` 类型的数据，同时还提供 `list`，`set`，`zset`，`hash` 等数据结构的存储。
- redis 支持数据的备份，即 `master-slave` 模式的数据备份。

### redis 优势
- **性能极高**
- redis 能读的速度是 `110000次/s`, 写的速度是 `81000次/s` 。
- **丰富的数据类型**
- redis 支持二进制案例的 `Strings`, `Lists`, `Hashes`, `Sets` 及 `Ordered Sets` 数据类型操作。
- **原子**
- redis 的所有操作都是原子性的，意思就是要么成功执行要么失败完全不执行。单个操作是原子性的。多个操作也支持事务，即原子性，通过 `MULTI` 和 `EXEC` 指令包起来。
- **丰富的特性**
- redis还支持 `publish/subscribe`, 通知, key 过期等等特性。

### redis 与其他 key-value 存储的不同
- redis 有着更为复杂的数据结构并且提供对他们的原子性操作，这是一个不同于其他数据库的进化路径。 redis 的数据类型都是基于基本数据结构的同时对程序员透明，无需进行额外的抽象。
- redis 运行在内存中但是可以持久化到磁盘，所以在对不同数据集进行高速读写时需要权衡内存，因为数据量不能大于硬件内存。在内存数据库方面的另一个优点是，相比在磁盘上相同的复杂的数据结构，在内存中操作起来非常简单，这样 redis 可以做很多内部复杂性很强的事情。同时，在磁盘格式方面他们是紧凑的以追加的方式产生的，因为他们并不需要进行随机访问。
