:local ttl 605000
:local list direct
:local url "https://raw.githubusercontent.com/apnagaev/dnsfilter/refs/heads/main/antifilter/mikrotik/direct.txt"
:local path dr/direct.txt
#/tool fetch http-method=get url=$url dst-path=$path
:local content [/file get $path contents]

:foreach ip in=[:deserialize $content delimiter="\n"  from=dsv options=dsv.plain] do={
   :if ([:len $ip] > 0 && [:pick $ip 0 1] != "#" && $ip !="") do={
    :do {
        /ip firewall address-list add address=$ip timeout=$ttl list="direct-dns"
        :log info "$ip added"
    } on-error={
          /ip/firewall/address-list/set [find where address=$ip] timeout=$ttl
    }
}
}
:log info "direct routes update finished"
