package com.yilos.secretary.common;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.log4j.Logger;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.State;



public class NetworkUtil 
{

	private static final Logger LOGGER = LoggerFactory
			.getLogger(NetworkUtil.class);
	/** 没有网络 */
	public final static int NONE = 0; // no network

	/** Wifi网络 */
	public final static int WIFI = 1; // Wi-Fi

	/** 移动网络 */
	public final static int MOBILE = 2; // 3G,GPRS

	private static int networkState;

	/**
	 * 得到网络状态
	 * 
	 * @param context
	 *            Context
	 * @return 网络状态值
	 */
	public static int getNetworkState(Context context) {
		ConnectivityManager connManager = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		// Wifi
		NetworkInfo network = connManager
				.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
		if (null != network
				&& (State.CONNECTED == network.getState() || State.CONNECTING == network
						.getState())) {
			return WIFI;
		}
		// mobile
		network = connManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
		if (null != network
				&& (State.CONNECTED == network.getState() || State.CONNECTING == network
						.getState())) {
			return MOBILE;
		}
		return NONE;
	}

	// 判断当前网络是否为wifi
	public static boolean isWifi(Context mContext) {
		ConnectivityManager connectivityManager = (ConnectivityManager) mContext
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo activeNetInfo = connectivityManager.getActiveNetworkInfo();
		if (activeNetInfo != null
				&& activeNetInfo.getType() == ConnectivityManager.TYPE_WIFI) {
			return true;
		}
		return false;
	}

	/**
	 * 判断当前的网络是否可以连接到服务器上
	 * 
	 * @param context
	 * @param callback
	 */
	public static int checkNetworkIsOk(Context context) {
		networkState = getNetworkState(context);
		if (NONE == networkState) {
			return NONE;
		} else {
			Thread thread = new Thread() {
				public void run() {
					GetMethod postMethod = new GetMethod(
							Constants.SERVICE_ADDRESS);
					try {
						HttpClient httpClient = new HttpClient();
						// 请求超时
						httpClient.getParams().setParameter(
								CoreConnectionPNames.CONNECTION_TIMEOUT, 3000);
						// 读取超时
						httpClient.getParams().setParameter(
								CoreConnectionPNames.SO_TIMEOUT, 3000);
						// TODO 目前只判断返回的是否为404，后续还需要根据错误码判断
						if (HttpStatus.SC_NOT_FOUND == httpClient
								.executeMethod(postMethod)) {
							networkState = NONE;
						}
					} catch (Exception e) {
						LOGGER.error("检查网络连接异常", e);
						// 网络连接不可用
						networkState = NONE;
					} finally {
						// 释放连接
						if (null != postMethod) {
							postMethod.releaseConnection();
						}
					}
				};
			};
			thread.start();
			try {
				thread.join();
			} catch (Exception e) {
				LOGGER.error("检查网络连接异常", e);
			}
			return networkState;
		}
	}

}
