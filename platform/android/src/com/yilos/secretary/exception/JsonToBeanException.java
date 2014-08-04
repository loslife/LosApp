package com.yilos.secretary.exception;

public class JsonToBeanException extends Exception {

	private static final long serialVersionUID = 1L;

	public JsonToBeanException(String msg) {
		super(msg);
	}

	public JsonToBeanException() {
		super();
	}

}