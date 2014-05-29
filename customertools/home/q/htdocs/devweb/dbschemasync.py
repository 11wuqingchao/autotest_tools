#!/home/q/python27/bin/python
# -*- coding:utf-8 -*-

import json
import subprocess

def sync(request_param):
    ret = "true"
    paramdict = {}
    try:
        paramdict = json.loads(request_param)
    except (TypeError, ValueError):
        ret = "false"
        msg = "request parameter format is invalidate!"        
        return (ret, msg)
    
    host = paramdict['host']
    try:
        subprocess.check_output(["/home/q/htdocs/devweb/shemasync.sh",host])
        msg = "sync db schema succed!"
    except subprocess.CalledProcessError,e:
        ret = "false"
        msg =  e.output 
    return (ret, msg)
