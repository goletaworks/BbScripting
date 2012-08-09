package com.goletaworks.bb.learn.bbscripting;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;

public class RecursivePropertyExclusionStrategy implements ExclusionStrategy {
	
	public RecursivePropertyExclusionStrategy(){
		
	}
	
	@Override
	public boolean shouldSkipClass(Class<?> clazz) {
		if(clazz.getPackage() != null && 
				clazz.getPackage().getName().equals("org.apache.naming.resources") ||
				clazz == java.lang.Throwable.class ||
				clazz == java.lang.ref.Reference.class ){
			return true;
		}
		return false;
	}

	@Override
	public boolean shouldSkipField(FieldAttributes f) {
		if(f.getName().equals("cacheKey") ||
				f.getName().equals("lmap")){
			return true;
		}
		return false;
	}

}