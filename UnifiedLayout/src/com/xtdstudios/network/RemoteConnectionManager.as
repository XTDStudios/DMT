package com.xtdstudios.network {
import com.xtdstudios.common.GUID;

import flash.events.HTTPStatusEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

public class RemoteConnectionManager extends URLLoader {
//		public static const contentType:URLRequestHeader = new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    private var m_requestId:String;
    private var requestHeaders:Array;
    private var _responseStatusEvent: HTTPStatusEvent;

    public function RemoteConnectionManager() {
        m_requestId = GUID.create();
        addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function (e:HTTPStatusEvent):void {
            _responseStatusEvent = e;
        });
    }

    public function get requestId():String {
        return m_requestId;
    }

    public function addRequestHeader(h:URLRequestHeader):void {
        if (requestHeaders == null) {
            requestHeaders = new Array();
        }
        requestHeaders.push(h);
    }


    public function doGetRequest(url:String, parameters:URLVariables, additinalRequestHeaders:Array = null):void {
        var request:URLRequest = new URLRequest(url);//+urlParams);
        request.data = parameters;
        request.method = URLRequestMethod.GET;
        prepareRequestHeaders(request, additinalRequestHeaders);
        load(request);
    }

    public function doPostRequest(url:String, parameters:URLVariables, additinalRequestHeaders:Array = null):void {
        var request:URLRequest = new URLRequest(url);
        request.data = parameters;
        request.method = URLRequestMethod.POST;
        prepareRequestHeaders(request, additinalRequestHeaders);
        load(request);
    }

    private function prepareRequestHeaders(request:URLRequest, additinalRequestHeaders:Array):void {
        for (var h1:URLRequestHeader in requestHeaders) {
            request.requestHeaders.push(h1);
        }
        for (var h2:URLRequestHeader in additinalRequestHeaders) {
            request.requestHeaders.push(h2);
        }
    }

    public function get responseStatusEvent():flash.events.HTTPStatusEvent {
        return _responseStatusEvent;
    }
}
}
