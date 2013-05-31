package com.goletaworks.bb.learn.bbscripting;

import java.util.ArrayList;
import java.util.List;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;

public class ConfigurableExclusionStrategy implements ExclusionStrategy {
	
	private List<String> skipPackages;
	private List<String> skipClasses;
	private List<String> skipFields;
	
	public ConfigurableExclusionStrategy(){
		skipPackages = new ArrayList<String>();
		skipClasses = new ArrayList<String>();
		skipFields = new ArrayList<String>();
	}
	
	public List<String> getSkipPackages() {
		return skipPackages;
	}

	public void setSkipPackages(List<String> skipPackages) {
		this.skipPackages = skipPackages;
	}

	public List<String> getSkipClasses() {
		return skipClasses;
	}

	public void setSkipClasses(List<String> skipClasses) {
		this.skipClasses = skipClasses;
	}

	public List<String> getSkipFields() {
		return skipFields;
	}

	public void setSkipFields(List<String> skipFields) {
		this.skipFields = skipFields;
	}

	@Override
	public boolean shouldSkipClass(Class<?> clazz) {		
		if(clazz.getPackage() != null && skipPackages.contains(clazz.getPackage().getName())){
			return true;
		}		
		if(skipClasses.contains(clazz.getName())){
			return true;
		}
		return false;
	}

	@Override
	public boolean shouldSkipField(FieldAttributes f) {
		if(skipFields.contains(f.getName())){
			return true;
		}
		return false;
	}
}