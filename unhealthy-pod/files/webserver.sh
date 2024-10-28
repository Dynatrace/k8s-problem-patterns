#!/bin/bash

# Define the file to check
FILE_TO_CHECK="/config/connection-string"

log_message() {
  local message="$1"
  local current_time
  current_time=$(date +"%Y-%m-%d %H:%M:%S")
  echo "$current_time - $message" >&2
}

read -r request_first_line
log_message "INFO: Received request: ${request_first_line}"

# Liveness should always work
if [[ "${request_first_line}" == *" /live"* ]]; then
  echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nLiveness OK."
  exit 0
fi

# Ensure the file exists and is readable
if [[ ! -r $FILE_TO_CHECK ]]; then
  log_message "ERROR: Status file not readable or does not exist"
  exit 1
fi

# Read the content of the file
STATUS=$(< "$FILE_TO_CHECK")

# Generate the HTTP response based on the file content and log the response to stderr
case "$STATUS" in
  "{{ .Values.faultInjection.toggler.value1 }}")
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nThe status is OK."
    log_message "INFO: Successful connection via \"$STATUS\""
    ;;
  "{{ .Values.faultInjection.toggler.value2 }}")
    echo -e "HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/plain\r\n\r\nThe status is NOK."
    log_message "ERROR: Failed to connect: invalid connect-string \"$STATUS\""
    ;;
  *)
    echo -e "HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/plain\r\n\r\nInvalid status in file."
    log_message "ERROR: Failed to connect: other error"
    ;;
esac
