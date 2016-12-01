#!/bin/bash

die(){
  echo $1
  exit -1
}

if [ $# -gt 0 ]; then
   ELASTIC=$1
else
   die "elastic.sh requires a version"  
fi

echo "Installing elasticsearch v${ELASTIC} ..."

curl -L -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ELASTIC}.deb
dpkg -i elasticsearch-${ELASTIC}.deb
/etc/init.d/elasticsearch start
rm elasticsearch-${ELASTIC}.deb

#royrusso/elasticsearch-HQ/v1.0.0

# fix elasticsearch.yml

ed /etc/elasticsearch/elasticsearch.yml <<EOF
/^# network\.host\:/
+
i
#
network.host: 0.0.0.0
.
wq
EOF

update-rc.d elasticsearch defaults 95 10
service elasticsearch start
