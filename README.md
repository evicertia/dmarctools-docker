# dmarctools-docker
Docker image for dmarc analyzing / managing tools.

how to use it

run shell execute

docker run --rm -it -v ./data:/data dmarctools shell

run checkspf and dmarc report for a single domain

docker run --rm -v ./data:/data dmarctools checkdmarc prueba.com

run parsedmarc

docker run --rm -v ./data:/data dmarctools parsedmarc -c /data/parsedmarc.ini --debug /data/dm_82F7wW4Vom.xml

docker run --rm -v ./data:/data d6n13l0l1v3/dmarctools:v0.1 parsedmarc -c /data/parsedmarc.ini --debug --verbose

docker run --rm -p 8080:8080 -v ./data:/data d6n13l0l1v3/dmarctools:v0.2 parsedmarc -c /data/parsedmarc.ini --debug --verbose --server
