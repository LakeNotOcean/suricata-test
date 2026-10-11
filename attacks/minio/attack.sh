python3 -m venv venv
source venv/bin/activate
pip3 install boto3 requests
python3 minio_cve_exploit.py http://172.20.0.103:9000