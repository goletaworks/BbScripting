<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.Map,
		java.util.HashMap,
		java.util.Set,
		javax.script.ScriptException,
		blackboard.persist.BbPersistenceManager,
		blackboard.platform.persistence.PersistenceServiceFactory,
		com.goletaworks.bb.learn.bbscripting.BbScripting"%>
<%@ taglib uri="/bbNG" prefix="bbNG"%>
<bbNG:learningSystemPage>
	<bbNG:jsFile href="js/jquery-1.7.2.min.js"/>
	<bbNG:cssFile href="../css/bbscripting.css"/>
	
	<bbNG:pageHeader>
		<bbNG:pageTitleBar title="BbScripting Building Block"/>
	</bbNG:pageHeader>
	<bbNG:breadcrumbBar environment="SYS_ADMIN_PANEL" navItem="">
		<bbNG:breadcrumb>BbScripting Building Block</bbNG:breadcrumb>
	</bbNG:breadcrumbBar>
<%
	String script = request.getParameter("script");
	String engineName = request.getParameter("engine");
	String noGui = request.getParameter("nogui");
	String result = null;
	
	boolean showConsoleGui = true;
	if(noGui != null){
		noGui = noGui.trim().toUpperCase();
		if(noGui.equals("1") || noGui.equals("YES") || noGui.equals("Y")){
			showConsoleGui = false;
		}
	}
	
	if(script == null){
		script = "";
	}
	if(engineName == null){
		engineName = "";
	}
	
	BbScripting bbScripting = new BbScripting();
	
	Map<String, String> engineList = bbScripting.getEngineNames();
	Set<String> engineListKeys = engineList.keySet();

	if(!script.trim().equals("")){
		BbPersistenceManager persistenceManager =
			PersistenceServiceFactory.getInstance().getDbPersistenceManager();
		HashMap<String, Object> objects = new HashMap<String, Object>();
		objects.put("request", request);
		objects.put("persistenceManager", persistenceManager);
		try {
			result = (String) bbScripting.execute(engineName, objects, script);
		}
		catch(Exception e){
			result = e.toString() + "\n";
			StackTraceElement[] ste = e.getStackTrace();
			for(int i=0; i<ste.length; i++){
				result += ste[i].toString() + "\n";
			}
		}
	}
	
	if(showConsoleGui){
%>
	<div class="warning">This Building Block is for API testing only. It is not intended for use in a production environment.</div>
	<p>The BbScripting context contains the following objects:</p>
	<ul><li>persistenceManager (a BbPersistenceManager instance)</li>
	<li>request (HttpServletRequest instance)</li></ul>
		
	<p>The following example retrieves all courses and prints their titles and descriptions. 
	Note the value of the last line (<code>nameStr;</code>)
	is treated as the return value and will be displayed in the results box.</p>
	<pre id="sample">var courseLoader = persistenceManager.getLoader('CourseDbLoader');
var courseList = courseLoader.loadAllCourses();
var courseNames = [];
var size = courseList.size();
for(var i=0; i&lt;size; i++){
    var course = courseList.get(i);
    courseNames.push(course.getTitle() + '(' + course.getDescription() + ')');
}
var nameStr = courseNames.join("\n");
nameStr;</pre>		
		<label>Engine:</label><select id="engine" name="engine">
		<%
		String options = "";
		for(String key : engineListKeys){
			String selectedEngine = "";
			if(engineName.equals(key)){
				selectedEngine = " selected=\"selected\"";
			}
			options += "<option value=\"" + key + "\"" + selectedEngine + ">" + 
			engineList.get(key) + "</option>\n";
		}
		out.print(options);
		%>
		</select>
		<div><label for="script">Script:</label><br/></div>
		<textarea id="script" name="script" rows="10" cols="80"><% out.print(script); %></textarea>
		<p><button id="submit">Submit</button></p>
		<script>
		jQuery(document).ready(function(){
			jQuery('#submit').on('click', function(){
				
				var selectedEngine = jQuery('#engine').val();
				var script = jQuery('#script').val();
				
				jQuery.ajax({
						url : 'index-json.jsp',
						dataType : 'json',
						type : 'post',
						data : {
							script : script,
							engine : selectedEngine					
						},
						success : function(result, textStatus, jqXHR){
							console.dir(result);
							jQuery('#result').text(result);
						}
				});
			});
		});
		</script>
	<pre id="result" style="width: 1024px; height: 400px; overflow: auto; background-color: black; color: white">
	</pre>
<%
} else {
	out.print(result);
}
%>
</bbNG:learningSystemPage>