FROM dammeax/xpspark
RUN yum -y install gcc python-devel git java-1.8.0-openjdk-devel npm fontconfig which; yum clean all
RUN pip install --upgrade matplotlib seaborn
RUN curl -s http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz | tar xz -C /usr/local/
RUN ln -s /usr/local/apache-maven-3.3.9/bin/mvn /usr/local/bin/mvn
RUN export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=1024m"
RUN mvn clean package -DskipTests -Pspark-2.2 -Phadoop-2.7 -Pyarn -Ppyspark -Psparkr -Pr -Pscala-2.11 -f /var/zeppelin/pom.xml
#RUN ln -s /opt/zeppelin-0.7.3-bin-all /opt/zeppelin
#WORKDIR /opt/zeppelin-0.7.3-bin-all
RUN cp conf/shiro.ini.template conf/shiro.ini
RUN sed -i 's/admin = password1/xp = vlab4xp/' conf/shiro.ini
RUN sed -i 's/user1 = password2, role1, role2//' conf/shiro.ini
RUN sed -i 's/user2 = password3, role3//' conf/shiro.ini
RUN sed -i 's/user3 = password4, role2//' conf/shiro.ini
RUN cp conf/zeppelin-site.xml.template conf/zeppelin-site.xml
RUN sed -i '/<name>zeppelin.anonymous.allowed<\/name>/{n;s/<value>.*<\/value>/<value>false<\/value>/;}' conf/zeppelin-site.xml
