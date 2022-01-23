
public class Container {

	String id;
	String serviceName;
	String containerName;
	float aggUtilization;
	int aggCount;

	public Container(String id, String serviceName, String containerName) {
		this.id = id;
		this.serviceName = serviceName;
		this.containerName = containerName;
		aggCount=0;

	}

	public void updateAggUtilization(float newUtilization) {
		aggUtilization += newUtilization;
	}
	
	public float getUtilization() {
		
		return aggUtilization/aggCount;
	}

}
