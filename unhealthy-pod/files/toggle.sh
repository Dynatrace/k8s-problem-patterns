#!/bin/bash

value1="{{ .Values.faultInjection.toggler.value1 }}"
value2="{{ .Values.faultInjection.toggler.value2 }}"
ns="{{ .Values.namespace | default .Release.Namespace }}"

# We do that back and forth switching to create a "change" event for the configmap so it should be wrong 90% of the time but also look like it has been recently changed to a wrong value
kubectl patch configmap -n "$ns" "{{ include "demo-app.fullname" . }}-app-config" --type merge -p "{\"data\":{\"connection-string\":\"$value1\"}}"
sleep {{ .Values.faultInjection.toggler.sleep | quote }}
kubectl patch configmap -n "$ns" "{{ include "demo-app.fullname" . }}-app-config" --type merge -p "{\"data\":{\"connection-string\":\"$value2\"}}"
