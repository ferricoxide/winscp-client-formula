# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
include:
{%- if grains.os_family == "Windows" %}
  - {{ tplroot }}.config.win_clean
{%- endif %}

Avoid being a null-router (config/clean) - WinSCP Client:
  test.nop: []
