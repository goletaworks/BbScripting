package com.goletaworks.bb.learn.bbscripting;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineFactory;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

public class BbScripting {
	
	private ScriptEngineManager factory;
	
	public BbScripting(){
		factory = new ScriptEngineManager();
	}
	
	public Map<String, String> getEngineNames(){
		HashMap<String, String> engineNames = new HashMap<String, String>();
		List<ScriptEngineFactory> factories = factory.getEngineFactories();
        
        for(ScriptEngineFactory factory : factories){
        	List<String> shortNames = factory.getNames(); // assume there's always at least one, otherwise not findable
        	engineNames.put(shortNames.get(0), factory.getLanguageName() + 
        			" " + factory.getLanguageVersion());
        }
        return engineNames;
	}

	public Object execute(String engineName, Map<String, Object> objects, String script) 
			throws ScriptException {
		if(engineName == null || engineName.trim().equals("")){
			Map<String, String> engineNames = this.getEngineNames();
			Set<String> engineNameKeys = engineNames.keySet();
			if(engineNameKeys.size() > 0){
				engineName = engineNameKeys.iterator().next();
			}
		}
		
		ScriptEngine engine = factory.getEngineByName(engineName);
		
		if(engine == null){
			throw new ScriptException("Failed to create engine for " + engineName);
		}
		
		Set<String> keys = objects.keySet();
		for(String key : keys){
			engine.put(key, objects.get(key));
		}
		
		Object result = engine.eval(script);
		return result;
	}
}
