Name
---
lua-resty-ip2location - A Lua library for reading [ip2location's Geolocation database format](https://www.ip2location.com/)  (aka ip2location).

Installation
---
```bash
opm get olegabr/lua-resty-ip2location
```

Synopsis
---
```
  local geo = require 'resty.ip2location'

  -- geo.IP2LOCATION_FILE_IO and geo.IP2LOCATION_CACHE_MEMORY are also available
  local ip2location = geo.new("/usr/share/ip2location/IPV6-COUNTRY.BIN", geo.IP2LOCATION_SHARED_MEMORY)

  --support ipv6 e.g. 2001:4860:0:1001::3004:ef68
  local record,err = ip2location:lookup(ngx.var.arg_ip or ngx.var.remote_addr)
  if not record then 
    ngx.log(ngx.ERR,'failed to lookup by ip ,reason:',err)
    ip2location:close()
    return
  end

  ngx.say("full :",cjson.encode(record))
  if ngx.var.arg_node then
    ngx.say("node name:",ngx.var.arg_node," ,value:", cjson.encode(record[ngx.var.arg_node] or {}))
  end
  record:close()
  ip2location:close()
```

```bash
  #ipv4
  $ curl localhost/ip=114.114.114.114&node=city
  #ipv6
  #$ curl localhost/ip=2001:4860:0:1001::3004:ef68&node=country
  full :{"city":{"geoname_id":1799962,"names":{"en":"Nanjing","ru":"Нанкин","fr":"Nankin","pt-BR":"Nanquim","zh-CN":"南京","es":"Nankín","de":"Nanjing","ja":"南京市"}},"subdivisions":[{"geoname_id":1806260,"names":{"en":"Jiangsu","fr":"Province de Jiangsu","zh-CN":"江苏省"},"iso_code":"32"}],"country":{"geoname_id":1814991,"names":{"en":"China","ru":"Китай","fr":"Chine","pt-BR":"China","zh-CN":"中国","es":"China","de":"China","ja":"中国"},"iso_code":"CN"},"registered_country":{"geoname_id":1814991,"names":{"en":"China","ru":"Китай","fr":"Chine","pt-BR":"China","zh-CN":"中国","es":"China","de":"China","ja":"中国"},"iso_code":"CN"},"location":{"time_zone":"Asia\/Shanghai","longitude":118.7778,"accuracy_radius":50,"latitude":32.0617},"continent":{"geoname_id":6255147,"names":{"en":"Asia","ru":"Азия","fr":"Asie","pt-BR":"Ásia","zh-CN":"亚洲","es":"Asia","de":"Asien","ja":"アジア"},"code":"AS"}}
  node name:city ,value:{"geoname_id":1799962,"names":{"en":"Nanjing","ru":"Нанкин","fr":"Nankin","pt-BR":"Nanquim","zh-CN":"南京","es":"Nankín","de":"Nanjing","ja":"南京市"}}
```

prettify
```json
full: {
    "city": {
        "geoname_id": 1799962,
        "names": {
            "en": "Nanjing",
            "ru": "Нанкин",
            "fr": "Nankin",
            "pt-BR": "Nanquim",
            "zh-CN": "南京",
            "es": "Nankín",
            "de": "Nanjing",
            "ja": "南京市"
        }
    },
    "subdivisions": [{
            "geoname_id": 1806260,
            "names": {
                "en": "Jiangsu",
                "fr": "Province de Jiangsu",
                "zh-CN": "江苏省"
            },
            "iso_code": "32"
        }
    ],
    "country": {
        "geoname_id": 1814991,
        "names": {
            "en": "China",
            "ru": "Китай",
            "fr": "Chine",
            "pt-BR": "China",
            "zh-CN": "中国",
            "es": "China",
            "de": "China",
            "ja": "中国"
        },
        "iso_code": "CN"
    },
    "registered_country": {
        "geoname_id": 1814991,
        "names": {
            "en": "China",
            "ru": "Китай",
            "fr": "Chine",
            "pt-BR": "China",
            "zh-CN": "中国",
            "es": "China",
            "de": "China",
            "ja": "中国"
        },
        "iso_code": "CN"
    },
    "location": {
        "time_zone": "Asia\/Shanghai",
        "longitude": 118.7778,
        "accuracy_radius": 50,
        "latitude": 32.0617
    },
    "continent": {
        "geoname_id": 6255147,
        "names": {
            "en": "Asia",
            "ru": "Азия",
            "fr": "Asie",
            "pt-BR": "Ásia",
            "zh-CN": "亚洲",
            "es": "Asia",
            "de": "Asien",
            "ja": "アジア"
        },
        "code": "AS"
    }
}
node name: city, value: {
    "geoname_id": 1799962,
    "names": {
        "en": "Nanjing",
        "ru": "Нанкин",
        "fr": "Nankin",
        "pt-BR": "Nanquim",
        "zh-CN": "南京",
        "es": "Nankín",
        "de": "Nanjing",
        "ja": "南京市"
    }
}

```

Prerequisites
---
- [IP2Location C library][https://github.com/chrislim2888/IP2Location-C-Library]
- [openresty][https://openresty.org]
- [ip2location Databases][https://www.ip2location.com/]

Bug Reports
---
Please report bugs by filing an issue with our GitHub issue tracker at https://github.com/olegabr/lua-resty-ip2location/issues

If the bug is casued by the IP2Location C library  tracker at https://github.com/chrislim2888/IP2Location-C-Library/issues

Copyright and License
=====================

This module is licensed under the MIT license.

Copyright (C) 2018-, by Oleg Abrosimov <olegabrosimovnsk@gmail.com>.

All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.