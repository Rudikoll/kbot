{{- define "kbot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kbot.fullname" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kbot.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{ include "kbot.selectorLabels" . }}
{{- end }}

{{- define "kbot.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kbot.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
