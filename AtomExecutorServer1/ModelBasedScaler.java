import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

public class ModelBasedScaler implements Runnable{
	
	Socket socket;
	
	public ModelBasedScaler(Socket socket) {
		// TODO Auto-generated constructor stub
		this.socket=socket;
	}

	private void executeCommand(String [] command) {
		
		String linuxCommandResult = "";
		Process p = null;
		try {
			p = Runtime.getRuntime().exec(command);
		} catch (IOException e) {

			e.printStackTrace();
		}

		BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

		BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));

		try {
			while ((linuxCommandResult = stdInput.readLine()) != null) {

				System.out.println(linuxCommandResult);

			}

			while ((linuxCommandResult = stdError.readLine()) != null) {

				System.out.println(linuxCommandResult);

			}
		} catch (Exception e) {

			e.printStackTrace();
		}
		
		try {
			Thread.sleep(3000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	private void replicaCommand(int replica) {
		
		List<String> cmd = new ArrayList<>();

		cmd.add("docker");
		cmd.add("service");
		cmd.add("scale");
		String stackName = "sockshop";
		String serviceName="front-end";
		cmd.add(stackName + "_" + serviceName + "=" + replica);

		String[] s = new String[cmd.size()];
		s = cmd.toArray(s);
		
		executeCommand(s);
		
		

	}
	
	
	private void cpuShareCommand(double [] cpuShares) {
		String [] serviceNames = { "edge-router", "front-end", "carts-db" };
		
		Loader loader = new Loader(serviceNames);
		List<Container> containers = loader.loadContainers();
		
		List<String[]> commands = new ArrayList<>();
		
		for (Container container : containers) {
			
			double cpu=0;
			
			if(container.serviceName.equals("edge-router"))
				cpu=cpuShares[0];
			else if (container.serviceName.equals("front-end"))
				cpu=cpuShares[1];
			else if (container.serviceName.equals("carts-db"))
				cpu=cpuShares[2];
			
			int quota=(int)(cpu*100000);
			List<String> cmd = new ArrayList<>();

			cmd.add("docker");
			cmd.add("container");
			cmd.add("update");
     		cmd.add("--cpu-quota=" + quota);
     		cmd.add(container.id);
     		
			String[] s = new String[cmd.size()];
			s = cmd.toArray(s);

				commands.add(s);
		}
		
		for (String [] strings : commands) {
			
			executeCommand(strings);
			
		}
		
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		
		try {
			ObjectInputStream inStream = new ObjectInputStream(socket.getInputStream());
			double [] shares =  (double[]) inStream.readObject();
			
			int replica=(int) shares[3];
			
			replicaCommand(replica);

			cpuShareCommand(shares);
			
			

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
	}

}
