# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as winscp_client with context %}

include:
{%- if grains.os_family == "Windows" %}
  - {{ tplroot }}.package.win_install
{%- endif %}

Avoid being a null-router (package/install) - WinSCP Client:
  test.nop: []
