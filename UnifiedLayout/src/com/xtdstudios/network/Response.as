/**
 * Created by R on 5/9/2014.
 */
package com.xtdstudios.network {
import flash.events.HTTPStatusEvent;

public class Response {
    private var _responseURL:String;
    private var _redirected: Boolean;
    private var _status:int;
    private var _responseHeaders:Array;
    private var _body:*;

    public function Response(responseURL: String, redirected: Boolean, status:int, responseHeaders:Array,  body: *) {
        this._responseURL = responseURL;
        this._redirected = redirected;
        this._status = status;
        this._responseHeaders = responseHeaders;
        this._body = body;
    }

    public function get responseURL():String {
        return _responseURL;
    }

    public function get redirected():Boolean {
        return _redirected;
    }

    public function get status():int {
        return _status;
    }

    public function get responseHeaders():Array {
        return _responseHeaders;
    }

    public function get body():* {
        return _body;
    }
}
}
