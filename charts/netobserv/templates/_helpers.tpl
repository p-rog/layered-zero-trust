{{- define "netobserv.name" -}}
netobserv
{{- end }}

{{- define "netobserv.labels" -}}
app.kubernetes.io/name: {{ include "netobserv.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Resolve LokiStack PVC storageClassName:
explicit value, else the cluster default StorageClass, else fail.
*/}}
{{- define "netobserv.lokiStorageClassName" -}}
{{- $sc := .Values.loki.storageClassName | default "" -}}
{{- if $sc -}}
{{- $sc -}}
{{- else -}}
{{- $default := "" -}}
{{- range (lookup "storage.k8s.io/v1" "StorageClass" "" "").items | default list -}}
{{- $annotations := .metadata.annotations | default dict -}}
{{- if eq (index $annotations "storageclass.kubernetes.io/is-default-class" | default "") "true" -}}
{{- $default = .metadata.name -}}
{{- end -}}
{{- end -}}
{{- if not $default -}}
{{- fail "loki.storageClassName is empty and no default StorageClass was found; set loki.storageClassName in charts/netobserv values" -}}
{{- end -}}
{{- $default -}}
{{- end -}}
{{- end }}
