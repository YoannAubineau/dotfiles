# Java-specific configuration

export JAVA_HOME=/usr/lib/jvm/default-java

# This is a ugly hack to ensure that applications relying on JAVA_HOME
# environment variable are transparently kept in sync with the java version
# that is selected using:
#
#     update-alternatives --config java

