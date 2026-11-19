# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as winscp_client with context %}

{%- set config = winscp_client.get('config') or {} %}
{%- set install_prefix = config.get(
      'install_root', 'C:\\Program Files (x86)\\WinSCP'
    ) %}
{%- set temp_dir = salt['environ.get'](
      'TEMP', 'C:\\Windows\\Temp'
    ) %}
{%- set installer_path = [
      temp_dir, 'winscp-installer.exe'
    ] | join('\\') %}

{%- set uninstaller_cmd = [
      "$local_unins = Get-ChildItem -Path '" ~ install_prefix ~ "'",
      "-Filter 'unins*.exe' | Select-Object -First 1;",
      "if ($local_unins) {",
      "Start-Process -FilePath $local_unins.FullName",
      "-ArgumentList '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'",
      "-NoNewWindow -Wait } else {",
      "Remove-Item -Path '" ~ install_prefix ~ "'",
      "-Recurse -Force -ErrorAction SilentlyContinue }"
    ] | join(' ') %}
{%- set onlyif_cmd = [
      "if (Test-Path '" ~ install_prefix ~ "') { exit 0 } else { exit 1 }"
    ] | join(' ') %}

Remove WinSCP Cached Installer:
  file.absent:
    - name: {{ installer_path | json }}

Execute WinSCP Uninstaller:
  cmd.run:
    - name: {{ uninstaller_cmd | json }}
    - onlyif: {{ onlyif_cmd | json }}
    - shell: powershell

Ensure WinSCP Installation Directory Removed:
  file.absent:
    - name: {{ install_prefix | json }}
    - require:
      - cmd: Execute WinSCP Uninstaller
