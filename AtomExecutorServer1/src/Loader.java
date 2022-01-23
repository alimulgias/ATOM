import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class Loader {

	String[] serviceNames;
	List<Container> containers;

	public Loader(String[] serviceNames) {
		// TODO Auto-generated constructor stub
		this.serviceNames = serviceNames;
		containers = new ArrayList<>();
	}

	public List<Container> loadContainers() {
		// TODO Auto-generated method stub

		String linuxCommandResult = "";

		Process p = null;

		try {
			Thread.sleep(24000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		try {
			p = Runtime.getRuntime().exec(new String[] { "docker", "ps", "--format", "{{.ID}}, {{.Names}}" });
		} catch (IOException e) {

			e.printStackTrace();
		}

		BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

		BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));

		try {
			while ((linuxCommandResult = stdInput.readLine()) != null) {

				for (String serviceName : serviceNames) {
					if (linuxCommandResult.contains(serviceName + ".")) {

						System.out.println(linuxCommandResult);
						String[] parts = linuxCommandResult.split(",");

						containers.add(new Container(parts[0], serviceName, parts[1]));

					}
				}

			}

			while ((linuxCommandResult = stdError.readLine()) != null) {

				System.out.println(linuxCommandResult);

			}
		} catch (Exception e) {

			e.printStackTrace();
		}

		System.out.println(containers.size());
		return containers;
	}

	public static void main(String[] args) {

		String[] serviceNames = { "edge-router", "front-end", "carts", "catalogue", "carts-db", "catalogue-db" };

		// String cmd = "docker ps --format '{{.ID}}, {{.Names}}'";
		// String cmd = "docker ps --format {{.ID}}";
		// System.out.println(cmd);

		List<Container> containers = new ArrayList<>();

		String linuxCommandResult;

		Process p = null;
		try {
			p = Runtime.getRuntime().exec(new String[] { "docker", "ps", "--format", "{{.ID}}, {{.Names}}" });
		} catch (IOException e) {

			e.printStackTrace();
		}

		BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

		BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));

		try {
			while ((linuxCommandResult = stdInput.readLine()) != null) {

				for (String serviceName : serviceNames) {
					if (linuxCommandResult.contains(serviceName)) {

						String[] parts = linuxCommandResult.split(",");

						containers.add(new Container(parts[0], serviceName, parts[1]));

					}
				}

			}

			while ((linuxCommandResult = stdError.readLine()) != null) {

				System.out.println(linuxCommandResult);

			}
		} catch (Exception e) {

			e.printStackTrace();
		}

		for (Container container : containers) {

			System.out.println(container.id + ", " + container.containerName + ", " + container.serviceName);
		}
	}

}
