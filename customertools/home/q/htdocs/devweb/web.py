#!/home/q/python27/bin/python
# -*- coding:utf-8 -*-

from flup.server.fcgi import WSGIServer
import dbschemasync
import json

def web_app(environ, start_response):
    start_response('200 OK', [('msg-Type', 'application/json')])

    msg = "Hello World! Python in Nginx Fast-CGI"
    request_param = ""

    method = environ["REQUEST_METHOD"]
    uri = environ["PATH_INFO"]
    if method == 'GET':
        request_param = environ["QUERY_STRING"]
        ret = "true"
        try:
            if uri == "/cgitools/syncdbschema": 
                ret = "false"
                msg = "sync db schema request only support post method!"
        
        #######other logic start#########
    
        #######other logic end###########
        except:
            ret = "false"
            msg = "unhandling exception!"

    elif method == 'POST':
        request_param = environ["wsgi.input"].read()
        ret = "true"
        try:
            if uri == "/cgitools/syncdbschema":
                (ret, msg) = dbschemasync.sync(request_param)

        #######other logic start#########
    
        #######other logic end###########
        except:
            ret = "false"
            msg = "unhandling exception!"
    else:
        ret = "false"
        msg = "requst method ["+method+"] not support!"

    result = {"ret":ret, "message":msg,"request":request_param,"uri":uri}
    return [json.dumps(result)]


if __name__  == '__main__':
    #直接用python运行  
    #WSGIServer(web_app, multithreaded=True, multiprocess=False, bindAddress=('127.0.0.1', 12321)).run()  
    #fastcgi方式运行 
    WSGIServer(web_app).run()