# Java-specific configuration

if [[ -d /usr/lib/jvm/java ]]; then
    export JAVA_HOME=/usr/lib/jvm/java
fi

if [[ -d /usr/lib/jvm/default-java ]]; then
    export JAVA_HOME=/usr/lib/jvm/default-java
fi

# This is a ugly hack to ensure that applications relying on JAVA_HOME
# environment variable are transparently kept in sync with the java version
# that is selected using:
#
#     update-alternatives --config java

