-- Copyright (C) Anjia (anjia0532)

local json                = require('cjson') 
local json_encode         = json.encode
local json_decode         = json.decode

local ngx_log             = ngx.log
local ngx_ERR             = ngx.ERR
local ngx_CRIT            = ngx.CRIT
local ngx_INFO            = ngx.INFO


local ffi                 = require ('ffi')
local ffi_new             = ffi.new
local ffi_str             = ffi.string
local ffi_cast            = ffi.cast

-- for ip2location handle
local _M    ={}
_M._VERSION = '0.0.4'
local mt = { __index = _M }

-- for record
local _M2    ={}
local mt2 = { __index = _M2 }

ffi.cdef[[

/* http://lua-users.org/lists/lua-l/2011-11/msg00732.html */
struct _IO_FILE;
typedef struct _IO_FILE FILE;

/* https://github.com/chrislim2888/IP2Location-C-Library/blob/master/libIP2Location/IP2Loc_DBInterface.h#L17 */
enum IP2Location_mem_type
{
    IP2LOCATION_FILE_IO,
    IP2LOCATION_CACHE_MEMORY,
    IP2LOCATION_SHARED_MEMORY
};

struct in6_addr_local
{
    union
    {
        uint8_t addr8[16];
        uint8_t addr16[8];
    } u;
};


/* All below function are private function IP2Location library */
struct in6_addr_local IP2Location_readIPv6Address(FILE *handle, uint32_t position);
uint32_t IP2Location_read32(FILE *handle, uint32_t position);
uint8_t IP2Location_read8(FILE *handle, uint32_t position);
char *IP2Location_readStr(FILE *handle, uint32_t position);
float IP2Location_readFloat(FILE *handle, uint32_t position);
int32_t IP2Location_DB_set_file_io();
int32_t IP2Location_DB_set_memory_cache(FILE *filehandle);
int32_t IP2Location_DB_set_shared_memory(FILE *filehandle);
int32_t IP2Location_DB_close(FILE *filehandle);
void IP2Location_DB_del_shm();

/* https://github.com/chrislim2888/IP2Location-C-Library/blob/master/libIP2Location/IP2Location.h#L105 */
typedef struct
{
    FILE *filehandle;
    uint8_t databasetype;
    uint8_t databasecolumn;
    uint8_t databaseday;
    uint8_t databasemonth;
    uint8_t databaseyear;
    uint32_t databasecount;
    uint32_t databaseaddr;
    uint32_t ipversion;
    uint32_t ipv4databasecount;
    uint32_t ipv4databaseaddr;
    uint32_t ipv6databasecount;
    uint32_t ipv6databaseaddr;
    uint32_t ipv4indexbaseaddr;
    uint32_t ipv6indexbaseaddr;
} IP2Location;

typedef struct
{
    char *country_short;
    char *country_long;
    char *region;
    char *city;
    char *isp;
    float latitude;
    float longitude;
    char *domain;
    char *zipcode;
    char *timezone;
    char *netspeed;
    char *iddcode;
    char *areacode;
    char *weatherstationcode;
    char *weatherstationname;
    char *mcc;
    char *mnc;
    char *mobilebrand;
    float elevation;
    char *usagetype;
} IP2LocationRecord;

/*##################
# Public Functions
##################*/
IP2Location *IP2Location_open(char *db);
int IP2Location_open_mem(IP2Location *loc, enum IP2Location_mem_type);
uint32_t IP2Location_close(IP2Location *loc);
IP2LocationRecord *IP2Location_get_country_short(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_country_long(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_region(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_city (IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_isp(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_latitude(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_longitude(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_domain(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_zipcode(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_timezone(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_netspeed(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_iddcode(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_areacode(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_weatherstationcode(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_weatherstationname(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_mcc(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_mnc(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_mobilebrand(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_elevation(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_usagetype(IP2Location *loc, char *ip);
IP2LocationRecord *IP2Location_get_all(IP2Location *loc, char *ip);
void IP2Location_free_record(IP2LocationRecord *record);
void IP2Location_delete_shm();
unsigned long int IP2Location_api_version_num(void);
char *IP2Location_api_version_string(void);
char *IP2Location_lib_version_string(void);

]]

-- fields
-- https://github.com/chrislim2888/IP2Location-C-Library/blob/master/libIP2Location/IP2Location.h#L72
local IP2LOCATION_COUNTRYSHORT         = 0x00001
local IP2LOCATION_COUNTRYLONG          = 0x00002
local IP2LOCATION_REGION               = 0x00004
local IP2LOCATION_CITY                 = 0x00008
local IP2LOCATION_ISP                  = 0x00010
local IP2LOCATION_LATITUDE             = 0x00020
local IP2LOCATION_LONGITUDE            = 0x00040
local IP2LOCATION_DOMAIN_              = 0x00080 -- DOMAIN is a math.h macro
local IP2LOCATION_ZIPCODE              = 0x00100
local IP2LOCATION_TIMEZONE             = 0x00200
local IP2LOCATION_NETSPEED             = 0x00400
local IP2LOCATION_IDDCODE              = 0x00800
local IP2LOCATION_AREACODE             = 0x01000
local IP2LOCATION_WEATHERSTATIONCODE   = 0x02000
local IP2LOCATION_WEATHERSTATIONNAME   = 0x04000
local IP2LOCATION_MCC                  = 0x08000
local IP2LOCATION_MNC                  = 0x10000
local IP2LOCATION_MOBILEBRAND          = 0x20000
local IP2LOCATION_ELEVATION            = 0x40000
local IP2LOCATION_USAGETYPE            = 0x80000

local IP2LOCATION_ALL = 0xfffff


-- you should install the libIP2Location to your system
local IP2LOCATION = ffi.load('libIP2Location.so')
-- https://github.com/chrislim2888/IP2Location-C-Library

-- access_type
_M.IP2LOCATION_FILE_IO = IP2LOCATION.IP2LOCATION_FILE_IO
_M.IP2LOCATION_CACHE_MEMORY = IP2LOCATION.IP2LOCATION_CACHE_MEMORY
-- access_type: default
_M.IP2LOCATION_SHARED_MEMORY = IP2LOCATION.IP2LOCATION_SHARED_MEMORY


-- returns a ip2location object. free it with close call
function _M.new(ip2location_country_geolite2_file, access_type)
   
  local file_name_ip2 = ffi_new('char[?]',#ip2location_country_geolite2_file,ip2location_country_geolite2_file)
  local ip2location = IP2LOCATION.IP2Location_open(ffi_cast('char * ', file_name_ip2))
  if not ip2location then
      ngx_log(ngx_ERR, "can not open database file: ", ip2location_country_geolite2_file)
      return nil, "can not open database file: " .. ip2location_country_geolite2_file
  end
  if nil == access_type then
    access_type = _M.IP2LOCATION_SHARED_MEMORY
  end
  if IP2LOCATION.IP2Location_open_mem(ip2location, access_type) == -1 then
    IP2LOCATION.IP2Location_close(ip2location)
    ngx_log(ngx_ERR, "can not open database file: ", ip2location_country_geolite2_file, ", access type: ", access_type)
    return nil, "can not open database file: " .. ip2location_country_geolite2_file .. ", access type: " .. access_type
  end
  return setmetatable({ ip2location=ip2location }, mt)
end

function _M:close()
  IP2LOCATION.IP2Location_close(self.ip2location)
  IP2LOCATION.IP2Location_DB_del_shm()
end

-- returns a record object. free it with close_lookup call
function _M:lookup(ip)
  local record = IP2LOCATION.IP2Location_get_all(self.ip2location, ffi_cast('char * ', ip))

  if not record then
    return nil, "no result found"
  end
  
  return setmetatable({ record=record }, mt2), nil
  --return json_decode(table.concat(record)),nil
end

function _M2:close()
  IP2LOCATION.IP2Location_free_record(self.record)
end

return _M
