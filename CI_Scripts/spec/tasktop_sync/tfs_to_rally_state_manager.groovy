/*
 For using the script:
 Below is the example of TFS -> Rally mapping:
  <attribute-mapping>
            <attribute caster="value-map" id="BG_STATUS">
                <caster-configuration>
                    <map>
                        <entry value="Active" key="Active"/>
                        <entry value="Closed" key="Closed"/>
                        <entry value="Proposed" key="Proposed"/>
                    </map>
                </caster-configuration>
            </attribute>
            <attribute strategy="ignore" caster="value-map" id="System.State">
                <caster-configuration>
                    <map>
                        <entry value="Active" key="Active"/>
                        <entry value="Closed" key="Closed"/>
                        <entry value="Proposed" key="Proposed"/>
                    </map>
                </caster-configuration>
            </attribute>
        </attribute-mapping>
  You also need to have an attribute handler in your synchronizer.xml, please see the example below:
 <attribute-handler apply-always="true" script="script/TFS-ALM-StatusHandler-BFS.groovy" id="BG_STATUS" language="groovy"></attribute-handler>
 */

 /*
 <attribute-mapping>
            <attribute caster="value-map" id="System.State">
                <caster-configuration>
                    <map>
                        <entry value="New" key="Submitted"/>
                        <entry value="Approved" key="Open"/>
                        <entry value="Resolved" key="Verified"/>
                        <entry value="Resolved" key="Fixed"/>
                        <entry value="Removed" key="Deferred"/>
                        <entry value="Done" key="Closed"/>
                    </map>
                </caster-configuration>
            </attribute>
            <attribute caster="value-map" id="State">
                <caster-configuration>
                    <map>
                        <entry value="Submitted" key="New"/>
                        <entry value="Open" key="Approved"/>
                        <entry value="Open" key="Committed"/>
                        <entry value="Closed" key="Done"/>
                        <entry value="Fixed" key="Resolved"/>
                        <entry value="Deferred" key="Removed"/>
                    </map>
                </caster-configuration>
            </attribute>
        </attribute-mapping>
        <attribute-mapping>
*/

import org.apache.log4j.Logger


def getDefaultTargetState(){
	return 'Proposed'
}

// task.common.resolution
def getSourceResolutionAttributeId(){
	return null
}

// task.common.resolution
def getTargetResolutionAttributeId(){
	return 'System.Reason'
}

def getTargetStateAttributeId() {
	return "System.State"
}

// task.common.operation
def getTargetOperationAttributeId() {
	return null
}

def getStatusDictionary() {

	return ['Closed':'Closed','Active':'Active','Proposed':'Proposed','Resolved':'Resolved']
}

def getResolutionDictionary() {
	// Map of TFS resolution names to equivalent TFS reason names
	return [""]
}

def getStateIDs() {
	// State name to id of state
	return ['Closed':'Closed','Active':'Active','Proposed':'Proposed','Resolved':'Resolved']
}

def getConnectorKind(){
	return "com.tasktop.microsoft.tfs"
}


class GEdge {
	String node1, node2
	String operation
	String resolution
}



def getStateGraph() {
	return [
		//start progress
		new GEdge(node1:'Active', node2:'Resolved', resolution:'Fixed'), // As Designed, Cannot Reproduce, Copied to Backlog, Deferred, Duplicate, Obsolete
		new GEdge(node1:'Active', node2:'Proposed', resolution:'Investigation Complete'),

		new GEdge(node1:'Resolved', node2:'Active', resolution:'Not fixed'), // Test Failed
		new GEdge(node1:'Resolved', node2:'Closed', resolution:'Verified'),

		new GEdge(node1:'Closed', node2:'Active', resolution:'Closed in Error'), // or Reactivated

		new GEdge(node1:'Proposed', node2:'Active', resolution:'Approved'), // or Investigate
		new GEdge(node1:'Proposed', node2:'Closed', resolution:'Rejected'), // or Deferred

	]

}


// --- Do not modify below this line ------------------------

// For testing:
//def dictionary = getStatusDictionary()
//def stateMappings = getStateIDs()
//def graph = getStateGraph()
//def bfs = new BFSShortestPathAlgoritm(graph, 'New', 'Rejected')
//def path =  bfs.calculateShortestPath()
//System.out.print(path)




def map(context, sourceAttribute, targetTask) {

	if(!getConnectorKind().equals(targetTask.getConnectorKind())){
		return
	}


	Logger logger = Logger.getLogger("status-handler")
	def statusSourceAttribute = sourceAttribute.model.taskData.root.attributes[sourceAttribute.id]
	if(targetTask.isNew()) {
		logger.info("New task")

		targetStateAttribute = targetTask.root.attributes.(getTargetStateAttributeId())
		if (targetStateAttribute == null) {
			targetStateAttribute = targetTask.root.createAttribute(getTargetStateAttributeId())
		}
		targetStateAttribute.value = getDefaultTargetState()


		context.setSyncAgain(true)
		return
	}

	def resolutionSourceAttribute = null
	if(getSourceResolutionAttributeId() != null){
		resolutionSourceAttribute = sourceAttribute.model.taskData.root.attributes[getSourceResolutionAttributeId()]
	}

	def statusDictionary = getStatusDictionary()
	def resolutionDictionary = getResolutionDictionary()
	def stateMappings = getStateIDs()
	def graph = getStateGraph()
	def statusAttributeId = getTargetStateAttributeId()
	def resolutionAttributeId = getTargetResolutionAttributeId()
	def operationAttributeId = getTargetOperationAttributeId()

	def statusAttribute = targetTask.root.attributes[statusAttributeId]

	def status = statusAttribute.value

	if(status == null || status.equals('')) {
		status = getDefaultTargetState()
	}


	logger.info("State Mappings: "+ stateMappings)
	logger.info("Status: "+status + " Source: " + sourceAttribute.value)

	def resolutionAttribute = null
	if(resolutionAttributeId != null){
		resolutionAttribute = targetTask.root.attributes[resolutionAttributeId]
		if(resolutionAttribute == null) {
			resolutionAttribute = targetTask.root.createAttribute(resolutionAttributeId)
		}
	}


	def operationAttribute = null
	if(operationAttributeId != null){
		operationAttribute = targetTask.root.attributes[operationAttributeId]
		if(operationAttribute == null) {
			operationAttribute = targetTask.root.createAttribute(operationAttributeId)

		}
	}


	def targetResolution = null
	if(resolutionSourceAttribute != null){
		// Look up the target state from the attribute's metadata
		def targetResolutionKey = "__TARGET_RESOLUTION__"
		targetResolution = resolutionSourceAttribute.metaData.getValue(targetResolutionKey)
		if (targetResolution == null) {
			targetResolution = resolutionDictionary[resolutionSourceAttribute.value]
			if(targetResolution != null) {
				statusSourceAttribute.metaData.putValue(targetResolutionKey, targetResolution)
			}
		}
	}



	// Look up the target state from the attribute's metadata
	def targetStateKey = "__TARGET_STATE__"
	def targetState = statusSourceAttribute.metaData.getValue(targetStateKey)
	if (targetState == null) {
		targetState = statusDictionary[sourceAttribute.value]
		statusSourceAttribute.metaData.putValue(targetStateKey, targetState)
	}



	def currentState = stateMappings.find { it.value == status }.key
	logger.info("currentState = "+currentState)
	logger.info("targetState = "+targetState)

	if(currentState.equals(targetState)) {
		// no state transition required so just...
		logger.info("Current state "+ currentState + " equals target state "+targetState)
		return
	}

	def bfs = new BFSShortestPathAlgoritm(graph, currentState, targetState)
	def LinkedList path = bfs.calculateShortestPath()
	def numOfSteps = path.size()
	logger.info("Path: "+path)
	def nextStep = path[0]

	logger.info("nextState = "+nextStep)
	logger.info("number of transitions = "+numOfSteps)

	def GEdge e = graph.find {it.node1 == currentState && it.node2 == nextStep}

	if(operationAttribute != null) {
		// Set the operation
		operationAttribute.value = e.operation
		logger.info("applying operation: "+operationAttribute.value)
	}else{
		statusAttribute.value = e.node2
		logger.info("applying status: "+statusAttribute.value)
	}

	if(e.resolution != null && resolutionAttribute != null) {
		// This transition also requires a resolution to be set
		def resolutionValue = e.resolution

		if("USE_MAPPED".equals(resolutionValue)){
			resolutionValue = targetResolution
			if(targetResolution == null){
				resolutionValue = resolutionDictionary[""]
				logger.info("using default resolution: " + resolutionValue)
			}
		} else if ("LEAVE_ALONE".equals(resolutionValue)){
			resolutionValue = null
		}
		if(resolutionValue != null){
			resolutionAttribute.value = resolutionValue
			logger.info("applying resolution: "+resolutionAttribute.value)
		}
	}

	if (numOfSteps > 1) {
		context.setSyncAgain(true)
		statusSourceAttribute.value = statusDictionary.find { it.value == e.node2 }.key
		logger.info("realSource Final: "+statusSourceAttribute.value)
	}
}



// BFS -> Parent Matrix -> Shortest Path
class BFSShortestPathAlgoritm {
	def graph, start, destination

	private  LinkedList<Node> queue = new LinkedList<Node>();
	private  LinkedList<Node> path = new LinkedList<Node>();
	def distances = [:]
	def parents = [:]

	public BFSShortestPathAlgoritm(graph, start, destination) {
		this.graph = graph
		this.start = start
		this.destination = destination
		distances[start] = 0
		queue.add(start)
	}


	public calculateShortestPath() {

		// Initialize distances
		graph.each {
			distances[it.node1] = -1
			distances[it.node2] = -1
		}

		int numIterations = 0
		while(!queue.isEmpty()) {
			def state = queue.remove();
			getAdjacent(state).each { e ->
				if(distances[e.node2] == -1) {
					parents[e.node2] = e.node1
					distances[e.node2] = distances[e.node1] + 1
					queue.add(e.node2)
				}
			}
			numIterations++
			if(numIterations >= 100){
				throw new Exception("Max iterations for status reached.  Please check that all status and transitions are correct")
			}
		}

		def current = destination

		numIterations = 0
		while( current != start ) {
			path.add( current);
			current = parents[current];
			numIterations++
			if(numIterations >= 100){
				throw new Exception("Max iterations for status reached.  Please check that all status and transitions are correct")
			}
		}

		path = path.reverse()

		return path;
	}

	def getAdjacent(node) {
		graph.findAll { e ->
			e.node1 == node
		}
	}


}