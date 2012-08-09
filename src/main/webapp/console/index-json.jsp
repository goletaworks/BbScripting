<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.Map,
		java.util.HashMap,
		java.util.Set,
		javax.script.ScriptException,
		com.google.gson.Gson,
		com.google.gson.GsonBuilder,
		blackboard.persist.BbPersistenceManager,
		blackboard.platform.persistence.PersistenceServiceFactory,
		com.goletaworks.bb.learn.bbscripting.BbScripting,
		com.goletaworks.bb.learn.bbscripting.RecursivePropertyExclusionStrategy"%>
		
<%
	String script = request.getParameter("script");
	String engineName = request.getParameter("engine");
	String result = null;
	
	if(script == null){
		script = "";
	}
	if(engineName == null){
		engineName = "";
	}
	
	BbScripting bbScripting = new BbScripting();
	if(script.trim().equals("")){
		out.print("{}");
	}
	else {
		BbPersistenceManager persistenceManager =
			PersistenceServiceFactory.getInstance().getDbPersistenceManager();
		HashMap<String, Object> objects = new HashMap<String, Object>();
		objects.put("request", request);
		objects.put("persistenceManager", persistenceManager);
		Gson gson = new GsonBuilder()
				.setExclusionStrategies(new RecursivePropertyExclusionStrategy())
		        .serializeNulls()
		        .create();
		try {			
			result = gson.toJson(bbScripting.execute(engineName, objects, script).toString());			
		}
		catch(Exception e){
			result = e.toString() + "\n";
			StackTraceElement[] ste = e.getStackTrace();
			for(int i=0; i<ste.length; i++){
				result += ste[i].toString() + "\n";
			}
			result = gson.toJson(result);
		}
		finally {
			out.print(result);
		}
	}		
%>