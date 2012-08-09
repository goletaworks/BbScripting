A Blackboard Learn building block for testing Blackboard APIs. It provides a provides a script engine selector, a simple text area for entering code, and an output area.

**WARNING**: not for production use!

## Building BbScripting ##
To build, your Maven repository must include two jars from your <blackboard>`/systemlib` directory. See the POM file for more information.

## Using BbScripting ##

The BbScripting context contains the following objects:

    persistenceManager (a BbPersistenceManager instance)
    request (HttpServletRequest instance)

The following example retrieves all courses and prints their titles and descriptions. Note the value of the last line (`nameStr;`) is treated as the return value and will be displayed in the results box.

    var courseLoader = persistenceManager.getLoader('CourseDbLoader');
    var courseList = courseLoader.loadAllCourses();
    var courseNames = [];
    var size = courseList.size();
    for(var i=0; i<size; i++){
        var course = courseList.get(i);
        courseNames.push(course.getTitle() + '(' + course.getDescription() + ')');
    }
    var nameStr = courseNames.join("\n");
    nameStr;
