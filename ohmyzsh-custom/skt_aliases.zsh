alias hook-start="bash /opt/tomcat/apache-tomcat-6.0.24/bin/catalina.sh jpda start"
alias hook-stop="bash /opt/tomcat/apache-tomcat-6.0.24/bin/catalina.sh jpda stop"
alias hook-logs="tail -f /opt/tomcat/apache-tomcat-6.0.24/logs/Skyhook.log"
alias hook-logs-clear="rm /opt/tomcat/apache-tomcat-6.0.24/logs/Skyhook.log"  


function hook-build-run {
    bash /opt/tomcat/apache-tomcat-6.0.24/bin/catalina.sh jpda stop

    echo
    echo "Compiling hook: "
    cd ~/Sources/Skytouch/skytouch-hook/
    mvn clean package -U -Dxml.catalog.ignoreMissing=true -Dcobertura.skip=true -Dmaven.test.skip=true

    echo
    echo "Removing old hook war"
    rm /opt/tomcat/apache-tomcat-6.0.24/stage/skyhook.war
    cp target/skyhook.war /opt/tomcat/apache-tomcat-6.0.24/stage/

    echo "Starting hook"
    bash /opt/tomcat/apache-tomcat-6.0.24/bin/catalina.sh jpda start
}

