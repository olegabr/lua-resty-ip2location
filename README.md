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
  local ip2location = require 'resty.ip2location'
  local cjson = require('cjson') 

  -- ip2location.IP2LOCATION_FILE_IO and ip2location.IP2LOCATION_CACHE_MEMORY are also available
  local ip2loc = ip2location.new("/usr/share/ip2location/IPV6-COUNTRY.BIN", ip2location.IP2LOCATION_SHARED_MEMORY)

  --support ipv6 e.g. 2001:4860:0:1001::3004:ef68
  local record,err = ip2loc:lookup(ngx.var.arg_ip or ngx.var.remote_addr)
  if not record then 
    ngx.log(ngx.ERR,'failed to lookup by ip ,reason:',err)
    ip2loc:close()
    return
  end

  ngx.say("full :",cjson.encode(record))
  if ngx.var.arg_node then
    ngx.say("node name:",ngx.var.arg_node," ,value:", cjson.encode(record[ngx.var.arg_node] or {}))
  end
  ip2loc:close()
```

```bash
  #ipv4
  $ curl 'http://localhost?ip=114.114.114.114&node=country_long'
  #ipv6
  #$ curl 'http://localhost?ip=2001:4860:0:1001::3004:ef68&node=country_long'
  full :{"domain":"This parameter is unavailable for selected data file. Please upgrade the data file.","longitude":0,"latitude":0,"mnc":"This parameter is unavailable for selected data file. Please upgrade the data file.","areacode":"This parameter is unavailable for selected data file. Please upgrade the data file.","weatherstationcode":"This parameter is unavailable for selected data file. Please upgrade the data file.","city":"This parameter is unavailable for selected data file. Please upgrade the data file.","timezone":"This parameter is unavailable for selected data file. Please upgrade the data file.","mcc":"This parameter is unavailable for selected data file. Please upgrade the data file.","isp":"This parameter is unavailable for selected data file. Please upgrade the data file.","region":"This parameter is unavailable for selected data file. Please upgrade the data file.","elevation":0,"zipcode":"This parameter is unavailable for selected data file. Please upgrade the data file.","mobilebrand":"This parameter is unavailable for selected data file. Please upgrade the data file.","netspeed":"This parameter is unavailable for selected data file. Please upgrade the data file.","country_long":"China","country_short":"CN","iddcode":"This parameter is unavailable for selected data file. Please upgrade the data file.","weatherstationname":"This parameter is unavailable for selected data file. Please upgrade the data file.","usagetype":"This parameter is unavailable for selected data file. Please upgrade the data file."}
 node name:country_long ,value:"China"
```

prettify
```json
{
	"domain": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"longitude": 0,
	"latitude": 0,
	"mnc": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"areacode": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"weatherstationcode": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"city": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"timezone": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"mcc": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"isp": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"region": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"elevation": 0,
	"zipcode": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"mobilebrand": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"netspeed": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"country_long": "China",
	"country_short": "CN",
	"iddcode": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"weatherstationname": "This parameter is unavailable for selected data file. Please upgrade the data file.",
	"usagetype": "This parameter is unavailable for selected data file. Please upgrade the data file."
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