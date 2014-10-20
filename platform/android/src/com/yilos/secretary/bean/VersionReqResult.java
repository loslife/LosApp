package com.yilos.secretary.bean;

import java.util.List;

public class VersionReqResult 
{  
     private String version_code;
     
     private String has_new_version;
     
     private List<String> feature_descriptions;

	public String getVersion_code() {
		return version_code;
	}

	public void setVersion_code(String version_code) {
		this.version_code = version_code;
	}

	public String getHas_new_version() {
		return has_new_version;
	}

	public void setHas_new_version(String has_new_version) {
		this.has_new_version = has_new_version;
	}


	public List<String> getFeature_descriptions() {
		return feature_descriptions;
	}

	public void setFeature_descriptions(List<String> feature_descriptions) {
		this.feature_descriptions = feature_descriptions;
	}
    
     
}
