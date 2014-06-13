package com.yilos.losapp.util;

import java.security.KeyStore;

import javax.net.ssl.KeyManagerFactory;

import org.apache.http.HttpVersion;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;

import android.content.Context;

public class HttpClientHelper {
	public static DefaultHttpClient getNewHttpClient(Context acontext) {
		try {
			KeyManagerFactory keyManagerFactory = KeyManagerFactory
					.getInstance("X509"); // 使用p12格式的证书
			KeyStore keyStore = KeyStore.getInstance("PKCS12");

			keyStore.load(
					acontext.getApplicationContext().getAssets()
							.open("client.p12"), "Los1933e".toCharArray());

			keyManagerFactory.init(keyStore, "Los1933e".toCharArray());

			SSLSocketFactory socketFactory = new MySSLSocketFactory(
					keyManagerFactory.getKeyManagers(), keyStore);
			socketFactory
					.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);
			HttpParams params = new BasicHttpParams();
			HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
			HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);

			SchemeRegistry registry = new SchemeRegistry();
			registry.register(new Scheme("http", PlainSocketFactory
					.getSocketFactory(), 80));
			registry.register(new Scheme("https", socketFactory, 443));

			ClientConnectionManager ccm = new ThreadSafeClientConnManager(
					params, registry);

			return new DefaultHttpClient(ccm, params);
		} catch (Exception e) {
			return new DefaultHttpClient();
		}
	}
}
