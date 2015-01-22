package com.xtdstudios.network {
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLVariables;
import flash.utils.Dictionary;

public class ConnectionManager {
    private var m_requestsMap:Dictionary;

    public function ConnectionManager() {
        m_requestsMap = new Dictionary();
    }

    public function cancelRequest(requestId:String):Boolean {
        var rcm:RemoteConnectionManager = m_requestsMap[requestId];
        if (rcm) {
            delete m_requestsMap[requestId];
            rcm.close(); // should we wrap this in try block ??
            return true;
        }
        else
            return false;
    }

    public function cancelAllRequests():void {
        for (var requestId:String in m_requestsMap) {
            cancelRequest(requestId);
        }
    }

    public function doGetRequest(url:String, parameters:URLVariables, onSuccess:Function, onError:Function = null, onProgress:Function = null, payloadData:* = null):void {
        var rcm:RemoteConnectionManager = new RemoteConnectionManager();
        registerConnectorEvents(rcm, onSuccess, onError, onProgress, payloadData);
        rcm.doGetRequest(url, parameters);
    }

    public function doPostRequest(url:String, parameters:URLVariables, onSuccess:Function, onError:Function = null, onProgress:Function = null, payloadData:* = null):void {
//        if (isNetworkActive(apiUrl))
//        {
        var rcm:RemoteConnectionManager = new RemoteConnectionManager();
        registerConnectorEvents(rcm, onSuccess, onError, onProgress, payloadData);
        rcm.doPostRequest(url, parameters);
//        }
    }

    private function registerConnectorEvents(rcm:RemoteConnectionManager, onSuccess:Function, onError:Function, onProgress:Function, payloadData:*):void {
        function getCallback(callback:Function, payloadData:*):Function {
            return function (data:*):void {
                if (payloadData != null) {
                    callback(data, payloadData);
                }
                else {
                    callback(data);
                }
            }
        }
        function createResponse(e:HTTPStatusEvent, body: *): Response {
            return new Response(e.responseURL, e.redirected, e.status, e.responseHeaders, body);
        }
        m_requestsMap[rcm.requestId] = rcm;
//        rcm.addEventListener(Event.OPEN, function (e:Event):void {
//            trace("openHandler: " + e);
//        });
//        rcm.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function (e:HTTPStatusEvent):void {
//            trace("httpStatusHandler: " + e);
//            var headers: Array = e.responseHeaders;
//            trace("e.responseHeaders:  "+headers);
//            var i:int;
//            for (i = 0; i < headers.length; i++) {
//                var h = headers[i];
//                trace("headers["+i+"]:  "+h.name+" = "+h.value);
//
//            }
//        });
        rcm.addEventListener(Event.COMPLETE, function (e:Event):void {
            if (m_requestsMap[rcm.requestId]) {
                delete m_requestsMap[rcm.requestId];

                var loader:URLLoader = URLLoader(e.target);
                getCallback(onSuccess, payloadData)(createResponse(rcm.responseStatusEvent, loader.data));
            }
        });

        if (onError != null) {
            rcm.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
                if (m_requestsMap[rcm.requestId]) {
                    delete m_requestsMap[rcm.requestId];
                    getCallback(onError, payloadData)(e);
                }
            });
            rcm.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (e:SecurityErrorEvent):void {
                if (m_requestsMap[rcm.requestId]) {
                    delete m_requestsMap[rcm.requestId];
                    getCallback(onError, payloadData)(e);
                }
            });
        }
        if (onProgress != null) {
            rcm.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void {
                if (m_requestsMap[rcm.requestId]) {
                    getCallback(onError, payloadData)(e);
                }
            });
        }
    }
}
}
