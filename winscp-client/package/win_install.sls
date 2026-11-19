# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as winscp_client with context %}

{%- set config = winscp_client.get('config') or {} %}
{%- set pkg_map = winscp_client.get('pkg') or {} %}
{%- set install_prefix = config.get(
      'install_root', 'C:\\Program Files (x86)\\WinSCP'
    ) %}
{%- set winscp_version = pkg_map.get('version', '') %}
{%- set temp_dir = salt['environ.get'](
      'TEMP', 'C:\\Windows\\Temp'
    ) %}
{%- set installer_path = [
      temp_dir, 'winscp-installer.exe'
    ] | join('\\') %}
{%- set check_path = [
      install_prefix, 'WinSCP.exe'
    ] | join('\\') %}

{#- Determine the download URI: use explicit download_uri if valid URL, else construct from version #}
{%- set raw_uri = pkg_map.get('download_uri', '') %}
{%- if raw_uri and (raw_uri.endswith('.exe') or raw_uri.endswith('/download')) %}
  {%- set download_uri = raw_uri %}
{%- elif winscp_version %}
  {%- set download_uri = 'https://winscp.net/download/WinSCP-' ~ winscp_version ~ '-Setup.exe/download' %}
{%- else %}
  {%- set download_uri = '' %}
{%- endif %}

{%- set download_sig = pkg_map.get('download_sig', '') %}
{%- set skip_verify = false if download_sig else true %}

{%- if not download_uri %}
Enforce Explicit Version Contract:
  test.fail_without_changes:
    - name: 'Unable to determine WinSCP version or download URI. Define in Pillar.'
    - failhard: True

{%- else %}
  {%- set cmd_args = [
        "/VERYSILENT",
        "/NORESTART",
        "/CLOSEAPPS",
        "/SUPPRESSMSGBOXES",
        "/SP-",
        "/ALLUSERS",
        ['/DIR=', '"', install_prefix, '"'] | join
      ] | join(" ") %}
  {%- set cmd_exec = [
        "Start-Process",
        "-FilePath '" ~ installer_path ~ "'",
        "-ArgumentList '" ~ cmd_args ~ "'",
        "-NoNewWindow",
        "-Wait"
      ] | join(" ") %}
  {%- set ps_check_code = [
        "$p = '" ~ check_path ~ "';",
        "if (Test-Path $p) {",
        "$v = '" ~ winscp_version ~ "';",
        "if (-not $v) { exit 0 };",
        "$pv = (Get-Item $p).VersionInfo.ProductVersion;",
        "$fv = (Get-Item $p).VersionInfo.FileVersion;",
        "if (($pv -and $pv.StartsWith($v)) -or ($fv -and $fv.StartsWith($v))) { exit 0 }",
        "};",
        "exit 1"
      ] | join(" ") %}
  {%- set unless_cmd = "powershell -NoProfile -ExecutionPolicy Bypass -Command " ~ ps_check_code | quote %}

Download WinSCP Installer:
  file.managed:
    - name: {{ installer_path | json }}
    - source: {{ download_uri | json }}
    - makedirs: True
    - skip_verify: {{ skip_verify }}
    {%- if download_sig %}
    - source_hash: {{ download_sig | json }}
    {%- endif %}
    - unless: {{ unless_cmd | json }}

Run WinSCP Installer:
  cmd.run:
    - name: {{ cmd_exec | json }}
    - require:
      - file: Download WinSCP Installer
    - shell: powershell
    - unless: {{ unless_cmd | json }}

Remove WinSCP Cached Installer:
  file.absent:
    - name: {{ installer_path | json }}
    - onchanges:
      - cmd: Run WinSCP Installer

{%- endif %}
