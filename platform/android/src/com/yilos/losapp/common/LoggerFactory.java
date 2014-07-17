package com.yilos.losapp.common;

import java.io.File;
import java.io.IOException;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;


import de.mindpipe.android.logging.log4j.LogConfigurator;

public class LoggerFactory {

	public static final String LOGGERFILENAME = "nailAppLog.log";
	private static boolean hasInitLogFlag = false;

	private LoggerFactory() {
	}

	/**
	 * 获取日志输出实例
	 * 
	 * @return
	 */
	public static Logger getLogger(Class<?> cls) {
		if (!hasInitLogFlag) {
			hasInitLogFlag = true;
			initLog();
		}
		return Logger.getLogger(cls.getName());
	}

	private static void initLog() {
		LogConfigurator logConfigurator = new LogConfigurator();
		File sdPath = new File(Constants.YILOS_NAILSHOP_LOGPATH);
		if (!sdPath.exists()) {
			sdPath.mkdirs();
		}
		File logFile = new File(sdPath, LOGGERFILENAME);
		if (!logFile.exists()) {
			try {
				logFile.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		logConfigurator.setFileName(logFile.getAbsolutePath());
		logConfigurator.setFilePattern("%d{ISO8601} %p %c.%M:%L [T=%t] %m%n");
		logConfigurator.setLogCatPattern("%d{ISO8601} %p %c.%M:%L [T=%t] %m%n");
		logConfigurator.setMaxFileSize(Constants.ONE_MB_SIZE);
		logConfigurator.setMaxBackupSize(2);
		logConfigurator.setImmediateFlush(true);
		logConfigurator.setRootLevel(Level.ERROR);
		logConfigurator.configure();
	}


}
