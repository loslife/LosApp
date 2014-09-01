package com.yilos.secretary.common;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import org.apache.log4j.Logger;


public class ZipHelper {

	private final static Logger LOGGER = LoggerFactory
			.getLogger(ZipHelper.class);

	/**
	 * 
	 * @param sourceDir
	 *            D://backup
	 * @param zipFile
	 *            格式： D://backup//zipFile.zip
	 */
	public static void zip(String sourceDir, String zipFile) throws Exception {
		FileOutputStream os = null;
		BufferedOutputStream bos = null;
		ZipOutputStream zos = null;
		try {
			os = new FileOutputStream(zipFile);
			bos = new BufferedOutputStream(os);
			zos = new ZipOutputStream(bos);
			File file = new File(sourceDir);
			String basePath = file.isDirectory() ? file.getPath() : file
					.getParent();
			zipFile(file, basePath, zos);
		} catch (Exception e) {
			LOGGER.error("", e);
			throw e;
		} finally {
			try {
				if (null != zos) {
					zos.closeEntry();
					zos.close();
				}
				if (null != bos) {
					bos.close();
				}
				if (null != os) {
					os.close();
				}
			} catch (IOException e) {
				LOGGER.error("", e);
				throw e;
			}
		}
	}

	private static void zipFile(File source, String basePath,
			ZipOutputStream zos) throws Exception {
		File[] files = new File[0];
		if (source.isDirectory()) {
			files = source.listFiles();
		} else {
			files = new File[1];
			files[0] = source;
		}

		String pathName;
		byte[] buf = new byte[1024];
		int length = 0;
		for (File file : files) {
			if (file.isDirectory()) {
				pathName = file.getPath().substring(basePath.length() + 1)
						+ "/";
				try {
					zos.putNextEntry(new ZipEntry(pathName));
				} catch (IOException e) {
					e.printStackTrace();
				}
				zipFile(file, basePath, zos);
			} else {
				pathName = file.getPath().substring(basePath.length() + 1);
				BufferedInputStream bis = null;
				try {
					bis = new BufferedInputStream(new FileInputStream(file));
					zos.putNextEntry(new ZipEntry(pathName));
					while ((length = bis.read(buf)) > 0) {
						zos.write(buf, 0, length);
					}
				} catch (Exception e) {
					LOGGER.error("", e);
					throw e;
				} finally {
					if (null != bis) {
						try {
							bis.close();
						} catch (IOException e) {
							LOGGER.error("", e);
							throw e;
						}
					}
				}
			}
		}
	}

	/**
	 * 
	 * @param zipfile
	 *            D://zipFile.zip
	 * @param destDir
	 *            格式： D://unzip//
	 * @param overwrite
	 *            解压时是否覆盖已有文件，true覆盖，false不覆盖
	 */
	public static void unZip(String zipfile, String destDir, boolean overwrite)
			throws Exception {
		destDir = destDir.endsWith("//") ? destDir : destDir + "//";
		byte b[] = new byte[1024];
		int length;

		try {
			ZipFile zipFile = new ZipFile(new File(zipfile));
			Enumeration enumeration = zipFile.entries();
			ZipEntry zipEntry = null;
			File localFile = null;
			OutputStream outputStream = null;
			InputStream inputStream = null;
			while (enumeration.hasMoreElements()) {
				zipEntry = (ZipEntry) enumeration.nextElement();
				localFile = new File(destDir + zipEntry.getName());

				if (zipEntry.isDirectory()) {
					localFile.mkdirs();
				} else {
					// 判断如果该文件已经存在，并且不覆盖原有文件的话，则返回
					if (!overwrite && localFile.exists()) {
						continue;
					}
					if (!localFile.getParentFile().exists()) {
						localFile.getParentFile().mkdirs();
					}

					inputStream = zipFile.getInputStream(zipEntry);
					outputStream = new FileOutputStream(localFile);

					while ((length = inputStream.read(b)) > 0) {
						outputStream.write(b, 0, length);
					}
					inputStream.close();
					outputStream.close();
				}
			}
		} catch (IOException e) {
			LOGGER.error("", e);
			throw new Exception(e);
		}
	}

}
