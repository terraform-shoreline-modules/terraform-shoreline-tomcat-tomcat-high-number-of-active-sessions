resource "shoreline_notebook" "tomcat_high_number_of_active_sessions" {
  name       = "tomcat_high_number_of_active_sessions"
  data       = file("${path.module}/data/tomcat_high_number_of_active_sessions.json")
  depends_on = [shoreline_action.invoke_active_sessions_script,shoreline_action.invoke_update_tomcat_config]
}

resource "shoreline_file" "active_sessions_script" {
  name             = "active_sessions_script"
  input_file       = "${path.module}/data/active_sessions_script.sh"
  md5              = filemd5("${path.module}/data/active_sessions_script.sh")
  description      = "Check the server logs to identify the source of the high number of active sessions. This can help determine if the issue is caused by a specific application or user activity."
  destination_path = "/agent/scripts/active_sessions_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_tomcat_config" {
  name             = "update_tomcat_config"
  input_file       = "${path.module}/data/update_tomcat_config.sh"
  md5              = filemd5("${path.module}/data/update_tomcat_config.sh")
  description      = "Increase the maximum number of active sessions allowed by the Tomcat server to handle the increased traffic. This can be done by modifying the server's configuration file."
  destination_path = "/agent/scripts/update_tomcat_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_active_sessions_script" {
  name        = "invoke_active_sessions_script"
  description = "Check the server logs to identify the source of the high number of active sessions. This can help determine if the issue is caused by a specific application or user activity."
  command     = "`chmod +x /agent/scripts/active_sessions_script.sh && /agent/scripts/active_sessions_script.sh`"
  params      = ["PATH_TO_TOMCAT_SERVER_LOG_FILE"]
  file_deps   = ["active_sessions_script"]
  enabled     = true
  depends_on  = [shoreline_file.active_sessions_script]
}

resource "shoreline_action" "invoke_update_tomcat_config" {
  name        = "invoke_update_tomcat_config"
  description = "Increase the maximum number of active sessions allowed by the Tomcat server to handle the increased traffic. This can be done by modifying the server's configuration file."
  command     = "`chmod +x /agent/scripts/update_tomcat_config.sh && /agent/scripts/update_tomcat_config.sh`"
  params      = ["PATH_TO_TOMCAT_CONFIG_FILE","MAX_SESSIONS"]
  file_deps   = ["update_tomcat_config"]
  enabled     = true
  depends_on  = [shoreline_file.update_tomcat_config]
}

