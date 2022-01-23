import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

public class Snapshot {

	ConcurrentHashMap<String, List<Integer>> data;
	
	private static Snapshot snapshot=null;
	
	private Snapshot() {
	
		data=new ConcurrentHashMap<>();
	}
	
	public static Snapshot getSnapshot() {
		
		if(snapshot==null)
			snapshot=new Snapshot();
		
		return snapshot;
	}
	
	public void reset() {
		
		data=new ConcurrentHashMap<>();
		
	}
	

}
