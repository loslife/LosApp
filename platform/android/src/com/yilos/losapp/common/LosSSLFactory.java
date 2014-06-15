package com.yilos.losapp.common;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.KeyStore;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import android.content.Context;


public class LosSSLFactory {
	
	private static final String P12PWD = "Los1933e";
	
	public SSLSocketFactory getFactory(final Context applicationContext)throws GeneralSecurityException, IOException{

		KeyManagerFactory keyManagerFactory = KeyManagerFactory
				.getInstance("X509");
		// 使用p12格式的证书
		KeyStore keyStore = KeyStore.getInstance("PKCS12");
		keyStore.load(applicationContext.getAssets().open("client.p12"),
				P12PWD.toCharArray());
		keyManagerFactory.init(keyStore, P12PWD.toCharArray());

		SSLContext context = SSLContext.getInstance("TLS");
		// init的第一个参数是验证客户端证书，第二个参数验证CA证书，私签的CA
		context.init(keyManagerFactory.getKeyManagers(),
				new TrustManager[] { new DefaultTrustManager() }, null);
		return context.getSocketFactory();
	}

	class DefaultTrustManager implements X509TrustManager {

		@Override
		public void checkClientTrusted(X509Certificate[] arg0, String arg1)
				throws CertificateException {
		}

		@Override
		public void checkServerTrusted(X509Certificate[] arg0, String arg1)
				throws CertificateException {
		}

		@Override
		public X509Certificate[] getAcceptedIssuers() {
			return null;
		}
	}
}
