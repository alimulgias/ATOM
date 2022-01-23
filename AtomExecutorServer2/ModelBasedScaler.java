import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

public class ModelBasedScaler implements Runnable {

	Socket socket;

	public ModelBasedScaler(Socket socket) {
		// TODO Auto-generated constructor stub
		this.socket = socket;
	}

	private void executeCommand(String[] command) {

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

	private void replicaCommand(int[] replica) {

		for (int i = 0; i < 2; i++) {

			String serviceName = null;
			int replicaValue = 0;

			if (i == 0) {
				serviceName = "carts";
				replicaValue = replica[0];

			} else {
				serviceName = "catalogue";
				replicaValue = replica[1];

			}

			List<String> cmd = new ArrayList<>();

			cmd.add("docker");
			cmd.add("service");
			cmd.add("scale");
			String stackName = "sockshop";
			cmd.add(stackName + "_" + serviceName + "=" + replicaValue);

			String[] s = new String[cmd.size()];
			s = cmd.toArray(s);
			executeCommand(s);
		}
	}

	private void cpuShareCommand(double[] cpuShares) {
		String[] serviceNames = { "carts", "catalogue", "catalogue-db" };

		Loader loader = new Loader(serviceNames);
		List<Container> containers = loader.loadContainers();

		List<String[]> commands = new ArrayList<>();

		for (Container container : containers) {

			double cpu = 0;

			if (container.serviceName.equals("carts"))
				cpu = cpuShares[0];
			else if (container.serviceName.equals("catalogue"))
				cpu = cpuShares[1];
			else if (container.serviceName.equals("catalogue-db"))
				cpu = cpuShares[2];

			int quota = (int) (cpu * 100000);
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

		for (String[] strings : commands) {

			executeCommand(strings);

		}
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub

		try {
			ObjectInputStream inStream = new ObjectInputStream(socket.getInputStream());
			double[] shares = (double[]) inStream.readObject();

			int[] replica = new int[2];

			replica[0] = (int) shares[3];
			replica[1] = (int) shares[4];

			replicaCommand(replica);

			cpuShareCommand(shares);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
