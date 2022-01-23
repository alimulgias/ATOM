
public class Filter {

	String tcpFilter;
	String requestType;
	String requestName;

	public Filter(String requestType, String requestName, String tcpFilter) {

		this.tcpFilter = tcpFilter;
		this.requestType = requestType;
		this.requestName = requestName;
	}

}
