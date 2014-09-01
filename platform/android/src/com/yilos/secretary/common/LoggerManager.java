package com.yilos.secretary.common;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import org.apache.log4j.Logger;

import android.content.Context;
import android.content.pm.PackageInfo;


import com.yilos.secretary.AppContext;

public class LoggerManager {

	private static final Logger LOGGER = LoggerFactory
			.getLogger(LoggerManager.class);

	private static final String VERSION_FILE_NAME = "version.txt";
	private static final String VERSION_FILE_PATH = Constants.YILOS_NAILSHOP_LOGPATH
			+ VERSION_FILE_NAME;

	/**
	 * 日志文件上传
	 * 
	 * @param context
	 * @param uploadFileSizeLimit
	 *            上传文件大小限制，单位为字节
	 */
	public synchronized static void uploadLoggerFile(final Context context,
			final long uploadFileSizeLimit) {
		// 单独起一个线程处理日志文件上传，防止上传异常阻塞主线程
		new Thread("upload-secretary-app-log") {
			public void run() {
				try {
					// 删除本地日志文件
					File file = new File(Constants.YILOS_NAILSHOP_LOGPATH);
					if (getDirectorySize(file) > uploadFileSizeLimit) {
						
						String zipFilePath = Constants.YILOS_NAILSHOP_LOGPATH
								+ "../secretaryAppLog_" +AppContext.getInstance(context).getUserAccount()+ "_"
								+ System.currentTimeMillis()
								+ Constants.FILE_SUFFIX_ZIP;
						// 记录设备信息
						recorDeviceInfo(context);
						// 压缩日志文件夹
						ZipHelper.zip(Constants.YILOS_NAILSHOP_LOGPATH,
								zipFilePath);
						// 删除本地日志文件
						removeBackupLogFile(file);
						// 上传日志文件
						file = new File(zipFilePath);
						UploadHelper.uploadFile(context,
								Constants.LOGGER_UPLOAD_SERVICE, file);
						file.delete();
					}
				} catch (Exception e) {
					LOGGER.error("", e);
				}

			};
		}.start();
	}

	/**
	 * 获取文件夹大小（字节）
	 * 
	 * @param file
	 * @return 文件夹大小（字节）
	 */
	private static long getDirectorySize(File file) {
		// 判断文件是否存在
		if (file.exists()) {
			// 如果是目录则递归计算其内容的总大小
			if (file.isDirectory()) {
				File[] children = file.listFiles();
				long size = 0;
				for (File f : children)
					size += getDirectorySize(f);
				return size;
			} else {
				return file.length();
			}
		} else {
			return 0;
		}
	}

	private static boolean removeBackupLogFile(File file) {
		File[] files = file.listFiles();
		for (File deleteFile : files) {
			if (deleteFile.isDirectory()) {
				// 如果是文件夹，则递归删除下面的文件后再删除该文件夹
				if (!removeBackupLogFile(deleteFile)) {
					// 如果失败则返回
					return false;
				}
			} else {
				// 删除产生的备份日志文件
				if (!deleteFile.delete()) {
					// 如果失败则返回
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * 记录设备信息
	 * 
	 * @param context
	 */
	private static void recorDeviceInfo(Context context) {
		File file = new File(VERSION_FILE_PATH);
		if (!file.exists()) {
			BufferedWriter bw = null;
			FileWriter fw = null;
			try {
				file.createNewFile();
				fw = new FileWriter(file, true);
				bw = new BufferedWriter(fw);
				String versionName = "";
				int versionCode = 0;
				try {
					PackageInfo pkgInfonfo = context.getPackageManager()
							.getPackageInfo(context.getPackageName(), 0);
					// 当前应用的版本名称和版本号
					if (null != pkgInfonfo) {
						versionName = pkgInfonfo.versionName;
						versionCode = pkgInfonfo.versionCode;
					}
				} catch (Exception e) {
					LOGGER.error("获取secretaryApp版本信息异常", e);
				}
				StringBuilder info = new StringBuilder();
				// App版本号
				info.append("versionCode : " + versionCode + "\n");
				// App版本名称
				info.append("versionName : " + versionName + "\n");
				// 手机系统版本
				info.append("systemVersion ："
						+ android.os.Build.VERSION.RELEASE + "\n");
				// 手机型号
				info.append("model ：" + android.os.Build.MODEL + "\n");
				// 清空之前的内容
				bw.write("");
				// 写入新的内容
				bw.write(info.toString());
				bw.flush();

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (null != bw) {
					try {
						bw.close();
					} catch (IOException e) {
						LOGGER.error(e);
					}
				}
				if (null != fw) {
					try {
						fw.close();
					} catch (IOException e) {
						LOGGER.error(e);
					}
				}
			}
		}
	}

}
