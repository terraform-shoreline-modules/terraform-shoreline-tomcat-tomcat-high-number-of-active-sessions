
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Tomcat High Number of Active Sessions.
---

This incident occurs when the Tomcat server is experiencing an unusually high number of active sessions. Active sessions refer to the number of users currently accessing a web application hosted on the Tomcat server. When the number of active sessions exceeds the server's capacity, it can lead to slow response times, unresponsive applications, or even server crashes. This incident requires immediate attention to resolve the issue and prevent any further impact on the web application's performance.

### Parameters
```shell
export CATALINA_HOME="PLACEHOLDER"

export TOMCAT_PORT="PLACEHOLDER"

export PATH_TO_TOMCAT_SERVER_LOG_FILE="PLACEHOLDER"

export PATH_TO_TOMCAT_CONFIG_FILE="PLACEHOLDER"

export MAX_SESSIONS="PLACEHOLDER"
```

## Debug

### Check the number of active sessions on the Tomcat server
```shell
sudo ${CATALINA_HOME}/bin/catalina.sh sessioncount
```

### Check the current CPU and memory usage of the Tomcat server
```shell
top -p $(pgrep java)
```

### Check the current network connections to the Tomcat server
```shell
sudo netstat -anp | grep ${TOMCAT_PORT}
```

### Check the server log for any errors or warnings related to high session count
```shell
sudo tail -f ${CATALINA_HOME}/logs/catalina.out | grep -i "session"
```

### Check the server log for any errors or warnings related to memory usage
```shell
sudo tail -f ${CATALINA_HOME}/logs/catalina.out | grep -i "memory"
```

### Check the server log for any errors or warnings related to CPU usage
```shell
sudo tail -f ${CATALINA_HOME}/logs/catalina.out | grep -i "cpu"
```

## Repair

### Check the server logs to identify the source of the high number of active sessions. This can help determine if the issue is caused by a specific application or user activity.
```shell


#!/bin/bash



# Define variables

LOG_FILE=${PATH_TO_TOMCAT_SERVER_LOG_FILE}



# Check for high number of active sessions in the log file

if grep -q "High Number of Active Sessions" "$LOG_FILE"; then

    # Identify the source of the high number of active sessions

    SOURCE=$(grep "High Number of Active Sessions" "$LOG_FILE" | awk '{print $5}')

    echo "The high number of active sessions is caused by $SOURCE."

else

    echo "No high number of active sessions detected in the server logs."

fi


```

### Increase the maximum number of active sessions allowed by the Tomcat server to handle the increased traffic. This can be done by modifying the server's configuration file.
```shell
bash

#!/bin/bash



# Define the path to the Tomcat configuration file

config_file=${PATH_TO_TOMCAT_CONFIG_FILE}



# Define the maximum number of active sessions allowed

max_sessions=${MAX_SESSIONS}



# Update the configuration file with the new value

sed -i "s/<Connector port=\"8080\" protocol=\"HTTP\/1.1\"/<Connector port=\"8080\" protocol=\"HTTP\/1.1\" maxActiveSessions=\"$max_sessions\"/g" "$config_file"



# Restart the Tomcat server to apply the changes

systemctl restart tomcat


```