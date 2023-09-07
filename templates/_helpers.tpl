{{/* _helpers.tpl */}}
{{- define "finder.fullname" -}}
{{- if .Values.global.nameOverride }}
{{- .Values.global.profile | trunc 63 | trimSuffix "-" }}-{{- .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}-{{- .Values.global.network | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Generate a common label for your resources.
If profile is "cypress", include it in the label.
*/}}

{{- define "finder.labels" -}}
app.kubernetes.io/name={{ template "finder.name" . }}
app.kubernetes.io/instance={{ .Release.Name }}
{{- if eq .Values.global.network "cypress" }}
app.kubernetes.io/profile=cypress
{{- end }}
{{- end }}
