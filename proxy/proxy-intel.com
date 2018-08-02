proxy:
child-prc.intel.com port:913

proxy for apt:
/etc/apt/apt.conf

Acquire::http::Proxy "http://wilson_ke:password@10.0.0.1:63333";
Acquire::https::Proxy "http://wilson_ke:password@10.0.0.1:63333";
Acquire::ftp::Proxy "http://wilson_ke:password@10.0.0.1:63333";
