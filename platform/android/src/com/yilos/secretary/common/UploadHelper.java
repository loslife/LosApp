package com.yilos.secretary.common;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import org.apache.commons.httpclient.HttpStatus;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import android.content.Context;



public class UploadHelper {

	private static final Logger LOGGER = LoggerFactory
			.getLogger(UploadHelper.class);
	private static final int BUFFER_SIZE = 1024;

	private static final String CHARSET_NAME = "UTF-8";

	// rfc1867协议
	// private static final String FIELD_SEP = ": ";
	private static final String CR_LF = "\r\n";
	private static final String TWO_DASHES = "--";
	private static final String BOUNDARY = "---------------------------7d33a816d302b6";

	/**
	 * 文件上传
	 * 
	 * @param uploadUrl
	 *            文件上传的url
	 * @param file
	 *            要上传的文件
	 * @param user
	 *            用户信息
	 * @throws Exception
	 */
	public static void uploadFile(Context context,String uploadUrl, File file)
			throws Exception {
		if (file.exists()) {
	
			URL url = null;
			HttpsURLConnection urlConnection = null;
			OutputStream out = null;
			
			LosSSLFactory losSSLFactory = new LosSSLFactory();
			try {
				url = new URL(uploadUrl);
				urlConnection = (HttpsURLConnection) url.openConnection();
				urlConnection.setRequestMethod("POST");
				// 忽略主机名验证
				urlConnection.setHostnameVerifier(new HostnameVerifier() {
					@Override
					public boolean verify(String arg0, SSLSession arg1) {
						return true;
					}
				});
				urlConnection.setDoOutput(true);
				urlConnection.setRequestProperty("Content-Type",
						"multipart/form-data; boundary=" + BOUNDARY + "; charset="
								+ CHARSET_NAME);
				urlConnection.setSSLSocketFactory(losSSLFactory.getFactory(context));
				/*if (null != user) {
					if (null != user.getToken() && !user.getToken().isEmpty()) {
						urlConnection.setRequestProperty("Authorization", "Bearer "
								+ user.getToken());
					}
					if (null != user.getEnterpriseId()
							&& !user.getEnterpriseId().isEmpty()) {
						urlConnection.setRequestProperty("custom-enterpriseId",
								user.getEnterpriseId());
					}
				}*/
				out = new BufferedOutputStream(urlConnection.getOutputStream());// 请求

			} catch (IOException e) {
				LOGGER.error("", e);
				urlConnection.disconnect();
				throw new Exception(e);
			}

			StringBuilder form = new StringBuilder();
			form = builderForm(file);

			FileInputStream fStream = null;
			try {
				out.write(form.toString().getBytes(CHARSET_NAME));

				fStream = new FileInputStream(file);
				byte[] buffer = new byte[BUFFER_SIZE];
				int length = -1;
				while ((length = fStream.read(buffer)) != -1) {
					out.write(buffer, 0, length);
				}
				out.write(CR_LF.getBytes(CHARSET_NAME));

				out.write((TWO_DASHES + BOUNDARY + TWO_DASHES + CR_LF)
						.getBytes(CHARSET_NAME));
				out.flush();
			} catch (IOException e) {
				LOGGER.error("", e);
				try {
					out.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				urlConnection.disconnect();
				throw new Exception(e);
			} finally {
				try {
					if (null != fStream) {
						fStream.close();
					}
					if (null != out) {
						out.close();
					}
				} catch (IOException e) {
					LOGGER.error("", e);
				}
			}
			
			InputStream in = null;
			try {
				// 响应
				in = new BufferedInputStream(urlConnection.getInputStream());
			} catch (IOException e) {
				LOGGER.error("", e);
				urlConnection.disconnect();
				throw new Exception(e);
			}

			BufferedReader reader = null;
			try {
				reader = new BufferedReader(new InputStreamReader(in, CHARSET_NAME));
			
			StringBuilder result = new StringBuilder();
			String tmp = null;
				while ((tmp = reader.readLine()) != null) {
					result.append(tmp);
				}
			int status = urlConnection.getResponseCode();
				if (HttpStatus.SC_OK == status) {
					JSONObject jsonObj = new JSONObject(result.toString());
					// 如果服务端返回失败，则抛出异常
					if (!"0".equals(jsonObj.optString(
							"code", ""))) {
						LOGGER.error("上传文件：" + file.getName() + "失败，status："
								+ status + "，response： " + result);
						throw new Exception("上传文件：" + file.getName()
								+ "失败，status：" + result + "，response： "
								+ result);
					}
				} else {
					LOGGER.error("上传文件：" + file.getName() + "失败，status："
							+ result + "，Body： " + result);
					throw new Exception("上传文件：" + file.getName() + "失败，status："
							+ result + "，response： " + result);
				}
			} catch (Exception e) {
				LOGGER.error("上传文件：" + file.getName() + "失败", e);
				throw e;
			} finally {
				try {
					if (null != in) {
						in.close();
					}
					if (null != reader) {
						reader.close();
					}
					urlConnection.disconnect();
				} catch (IOException e) {
					LOGGER.error("", e);
				}
			}
		} else {
			throw new Exception("文件：" + file.getName() + "不存在");
		}
	}
	
	private static StringBuilder builderForm(File file)
	{
		StringBuilder form = new StringBuilder();
		form.append(TWO_DASHES + BOUNDARY + CR_LF);
		form.append("Content-Disposition: form-data; name=\"name\"" + CR_LF);
		form.append("Content-Type: text/plain; charset=" + CHARSET_NAME + CR_LF);
		form.append("Content-Transfer-Encoding: 8bit" + CR_LF);
		form.append(CR_LF);
		form.append(CR_LF);
		form.append(TWO_DASHES + BOUNDARY + CR_LF);
		form.append("Content-Disposition: form-data; name=\"file\";filename=\""
				+ file.getName() + "\"" + CR_LF);
		form.append("Content-Type: application/zip; charset=" + CHARSET_NAME
				+ CR_LF);
		form.append("Content-Transfer-Encoding: binary" + CR_LF);
		form.append(CR_LF);
		
		return form;
	}

	public static void downloadFile(String fileURL, String descPath)
			throws Exception {
		URL url = null;
		try {
			url = new URL(fileURL);
		} catch (MalformedURLException e) {
			LOGGER.error("", e);
			throw new Exception(e);
		}
		// 下载网络文件
		int bytesum = 0;
		int byteread = 0;
		URLConnection conn;
		InputStream inStream = null;
		FileOutputStream fs = null;
		try {
			conn = url.openConnection();
			inStream = conn.getInputStream();
			fs = new FileOutputStream(descPath);

			byte[] buffer = new byte[1204];
			while ((byteread = inStream.read(buffer)) != -1) {
				bytesum += byteread;
				fs.write(buffer, 0, byteread);
			}
		} catch (Exception e) {
			LOGGER.error("下载文件失败，fileURL：" + fileURL + "，descPath：" + descPath,
					e);
			throw e;
		} finally {
			try {
				if (null != inStream) {
					inStream.close();
				}
				if (null != fs) {
					fs.close();
				}
			} catch (Exception e) {
				LOGGER.error("", e);
			}
		}
	}

}
